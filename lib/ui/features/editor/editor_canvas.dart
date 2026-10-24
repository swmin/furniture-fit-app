import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/units.dart';
import '../../../data/local/app_database.dart';
import '../../../domain/geometry/placement.dart';

/// 배치 상태 분석 결과 (경고 표시용).
class PlacementReport {
  const PlacementReport({
    this.overlapping = const {},
    this.doorBlocked = const {},
    this.outOfRoom = const {},
  });

  final Set<String> overlapping;
  final Set<String> doorBlocked;
  final Set<String> outOfRoom;

  bool get hasIssues =>
      overlapping.isNotEmpty || doorBlocked.isNotEmpty || outOfRoom.isNotEmpty;
}

FurnitureRect rectOf(LayoutItem i) => FurnitureRect(
  center: Offset(i.xMm, i.yMm),
  width: i.widthMm.toDouble(),
  depth: i.depthMm.toDouble(),
  rotationDeg: i.rotationDeg,
);

/// 겹침·문 열림 방해·방 밖 이탈을 분석한다.
PlacementReport analyzePlacement(List<LayoutItem> items, {Rect? room}) {
  final rects = {for (final i in items) i.id: rectOf(i)};
  final overlapping = <String>{};
  final doorBlocked = <String>{};
  final outOfRoom = <String>{};

  for (var a = 0; a < items.length; a++) {
    final ia = items[a];
    final ra = rects[ia.id]!;
    for (var b = a + 1; b < items.length; b++) {
      final ib = items[b];
      if (ra.overlaps(rects[ib.id]!)) {
        overlapping
          ..add(ia.id)
          ..add(ib.id);
      }
    }
    final door = DoorGeometry.of(ia.doorType, ia.doorSwingMm, ra.width);
    if (door != null) {
      final zone = door.zone(ra);
      final blocked = items.any(
        (o) => o.id != ia.id && zone.overlaps(rects[o.id]!),
      );
      final outside = room != null && !_inside(zone.bounds, room);
      if (blocked || outside) doorBlocked.add(ia.id);
    }
    if (room != null && !_inside(ra.bounds, room)) outOfRoom.add(ia.id);
  }
  return PlacementReport(
    overlapping: overlapping,
    doorBlocked: doorBlocked,
    outOfRoom: outOfRoom,
  );
}

bool _inside(Rect r, Rect room) =>
    r.left >= room.left - 0.5 &&
    r.top >= room.top - 0.5 &&
    r.right <= room.right + 0.5 &&
    r.bottom <= room.bottom + 0.5;

/// 가구 배치 캔버스: 방/도면 배경 위에서 가구 선택·이동·회전 + 줌/팬.
class EditorCanvas extends StatefulWidget {
  const EditorCanvas({
    super.key,
    required this.world,
    required this.isRoom,
    this.imageFile,
    required this.items,
    required this.selectedId,
    required this.showDoors,
    required this.onSelect,
    required this.onCommit,
  });

  /// 배경 전체 영역 (mm). 빈 방이면 방 자체, 도면이면 도면 이미지 전체.
  final Rect world;

  /// true면 [world]를 방 벽으로 간주해 벽 간격/이탈을 계산한다.
  final bool isRoom;
  final File? imageFile;
  final List<LayoutItem> items;
  final String? selectedId;
  final bool showDoors;
  final ValueChanged<String?> onSelect;

  /// 드래그/회전이 끝났을 때 최종 상태를 저장한다.
  final ValueChanged<LayoutItem> onCommit;

  @override
  State<EditorCanvas> createState() => EditorCanvasState();
}

enum _Mode { none, transform, move, rotate }

class EditorCanvasState extends State<EditorCanvas> {
  double _scale = 1; // 화면 px / mm
  Offset _offset = Offset.zero;
  Size _viewport = Size.zero;
  bool _fitted = false;

  /// 드래그 중이거나 DB 반영 대기 중인 가구 상태.
  final Map<String, LayoutItem> _overrides = {};

  _Mode _mode = _Mode.none;
  Offset? _downLocal;
  Offset _grabOffset = Offset.zero;
  double _startScale = 1;
  Offset _startWorldFocal = Offset.zero;
  String? _activeId;

  static const _rotateHandleGap = 36.0; // 화면 px
  static const _handleHitRadius = 28.0;
  static const _snapPx = 10.0;

  double get _margin => widget.isRoom ? 52 : 16;

  Offset toWorld(Offset screen) => (screen - _offset) / _scale;
  Offset toScreen(Offset world) => world * _scale + _offset;

  /// 새 가구를 놓을 위치: 현재 화면 중앙(배경 영역 안으로 제한).
  Offset viewportCenterWorld() {
    final c = toWorld(_viewport.center(Offset.zero));
    return Offset(
      c.dx.clamp(widget.world.left, widget.world.right),
      c.dy.clamp(widget.world.top, widget.world.bottom),
    );
  }

  void fit() {
    final w = widget.world;
    final s = math.min(
      (_viewport.width - _margin * 2) / w.width,
      (_viewport.height - _margin * 2) / w.height,
    );
    _scale = s;
    _offset = Offset(
      (_viewport.width - w.width * s) / 2 - w.left * s,
      (_viewport.height - w.height * s) / 2 - w.top * s,
    );
  }

  void zoomBy(double factor) {
    final c = _viewport.center(Offset.zero);
    final w = toWorld(c);
    setState(() {
      _scale = (_scale * factor).clamp(_minScale, _maxScale);
      _offset = c - w * _scale;
    });
  }

  void fitToScreen() => setState(fit);

  double get _fitScale => math.min(
    _viewport.width / widget.world.width,
    _viewport.height / widget.world.height,
  );
  double get _minScale => _fitScale * 0.4;
  double get _maxScale => _fitScale * 12;

  @override
  void didUpdateWidget(EditorCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.world != widget.world) _fitted = false;
    // DB에 반영된 항목은 override 제거.
    _overrides.removeWhere((id, o) {
      if (_mode != _Mode.none && id == _activeId) return false;
      final fresh = widget.items.where((i) => i.id == id).firstOrNull;
      return fresh == null ||
          (fresh.xMm == o.xMm &&
              fresh.yMm == o.yMm &&
              fresh.rotationDeg == o.rotationDeg);
    });
  }

  List<LayoutItem> get _items => [
    for (final i in widget.items) _overrides[i.id] ?? i,
  ];

  LayoutItem? get _selected =>
      _items.where((i) => i.id == widget.selectedId).firstOrNull;

  Offset? _rotateHandleScreen(LayoutItem item) {
    final r = rectOf(item);
    final topCenter = toScreen(r.toWorld(Offset(0, -r.depth / 2)));
    final centerS = toScreen(r.center);
    final dir = topCenter - centerS;
    final len = dir.distance;
    final unit = len < 0.001
        ? Offset(math.sin(r.rad), -math.cos(r.rad))
        : dir / len;
    return topCenter + unit * _rotateHandleGap;
  }

  LayoutItem? _hitItem(Offset screen) {
    final w = toWorld(screen);
    final slop = 6 / _scale;
    for (final i in _items.reversed) {
      if (rectOf(i).contains(w, slop: slop)) return i;
    }
    return null;
  }

  // ---------- 제스처 ----------

  void _onTapUp(TapUpDetails d) {
    final hit = _hitItem(d.localPosition);
    widget.onSelect(hit?.id);
  }

  void _onScaleStart(ScaleStartDetails d) {
    final focal = d.localFocalPoint;
    final down = _downLocal ?? focal;
    _mode = _Mode.transform;
    if (d.pointerCount == 1) {
      final sel = _selected;
      if (sel != null) {
        final h = _rotateHandleScreen(sel);
        if (h != null && (h - down).distance <= _handleHitRadius) {
          _mode = _Mode.rotate;
          _activeId = sel.id;
          _onScaleUpdate(
            ScaleUpdateDetails(localFocalPoint: focal, pointerCount: 1),
          );
          return;
        }
      }
      final hit = _hitItem(down);
      if (hit != null) {
        if (hit.id != widget.selectedId) widget.onSelect(hit.id);
        _mode = _Mode.move;
        _activeId = hit.id;
        _grabOffset = Offset(hit.xMm, hit.yMm) - toWorld(down);
        HapticFeedback.selectionClick();
        _onScaleUpdate(
          ScaleUpdateDetails(localFocalPoint: focal, pointerCount: 1),
        );
        return;
      }
    }
    _startScale = _scale;
    _startWorldFocal = toWorld(focal);
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    final focal = d.localFocalPoint;
    switch (_mode) {
      case _Mode.move:
        final item = _items.firstWhere((i) => i.id == _activeId);
        var c = toWorld(focal) + _grabOffset;
        c = Offset(
          c.dx.clamp(widget.world.left, widget.world.right),
          c.dy.clamp(widget.world.top, widget.world.bottom),
        );
        final moved = rectOf(item).copyWith(center: c);
        final others = _items
            .where((i) => i.id != item.id)
            .map((i) => rectOf(i).bounds);
        final xEdges = <double>[
          if (widget.isRoom) ...[widget.world.left, widget.world.right],
          for (final o in others) ...[o.left, o.right],
        ];
        final yEdges = <double>[
          if (widget.isRoom) ...[widget.world.top, widget.world.bottom],
          for (final o in others) ...[o.top, o.bottom],
        ];
        final snap = snapDelta(
          moved.bounds,
          xEdges: xEdges,
          yEdges: yEdges,
          tolerance: _snapPx / _scale,
        );
        c += snap;
        setState(
          () => _overrides[item.id] = item.copyWith(
            xMm: c.dx.roundToDouble(),
            yMm: c.dy.roundToDouble(),
          ),
        );
      case _Mode.rotate:
        final item = _items.firstWhere((i) => i.id == _activeId);
        final centerS = toScreen(Offset(item.xMm, item.yMm));
        final v = focal - centerS;
        final deg = math.atan2(v.dy, v.dx) * 180 / math.pi + 90;
        setState(
          () =>
              _overrides[item.id] = item.copyWith(rotationDeg: snapAngle(deg)),
        );
      case _Mode.transform:
        setState(() {
          _scale = (_startScale * d.scale).clamp(_minScale, _maxScale);
          _offset = focal - _startWorldFocal * _scale;
        });
      case _Mode.none:
        break;
    }
  }

  void _onScaleEnd(ScaleEndDetails d) {
    final id = _activeId;
    final mode = _mode;
    _mode = _Mode.none;
    _activeId = null;
    if ((mode == _Mode.move || mode == _Mode.rotate) && id != null) {
      final item = _overrides[id];
      if (item != null) widget.onCommit(item);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewport = constraints.biggest;
        if (!_fitted) {
          fit();
          _fitted = true;
        }
        final items = _items;
        final room = widget.isRoom ? widget.world : null;
        final report = analyzePlacement(items, room: room);
        final sel = _selected;
        final gaps = sel == null
            ? const <Gap>[]
            : computeGaps(
                rectOf(sel).bounds,
                items.where((i) => i.id != sel.id).map((i) => rectOf(i).bounds),
                room: room,
              );

        return ClipRect(
          child: Listener(
            onPointerDown: (e) => _downLocal = e.localPosition,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: _onTapUp,
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onScaleEnd: _onScaleEnd,
              child: ColoredBox(
                color: scheme.surfaceContainer,
                child: Stack(
                  children: [
                    if (widget.imageFile != null)
                      Positioned(
                        left: _offset.dx + widget.world.left * _scale,
                        top: _offset.dy + widget.world.top * _scale,
                        width: widget.world.width * _scale,
                        height: widget.world.height * _scale,
                        child: Image.file(
                          widget.imageFile!,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.medium,
                          gaplessPlayback: true,
                        ),
                      ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: EditorPainter(
                          scale: _scale,
                          offset: _offset,
                          world: widget.world,
                          drawRoom: widget.isRoom,
                          items: items,
                          report: report,
                          selectedId: widget.selectedId,
                          showDoors: widget.showDoors,
                          gaps: gaps,
                          rotateHandle: sel == null
                              ? null
                              : _rotateHandleScreen(sel),
                          scheme: scheme,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 방·그리드·가구·문 반경·간격·회전 핸들을 그린다.
class EditorPainter extends CustomPainter {
  EditorPainter({
    required this.scale,
    required this.offset,
    required this.world,
    required this.drawRoom,
    required this.items,
    required this.report,
    required this.selectedId,
    required this.showDoors,
    required this.gaps,
    required this.rotateHandle,
    required this.scheme,
  });

  final double scale;
  final Offset offset;
  final Rect world;
  final bool drawRoom;
  final List<LayoutItem> items;
  final PlacementReport report;
  final String? selectedId;
  final bool showDoors;
  final List<Gap> gaps;
  final Offset? rotateHandle;
  final ColorScheme scheme;

  static const _warnColor = Color(0xFFE65100);
  static const _narrowPassageMm = 600;

  Offset s(Offset w) => w * scale + offset;

  @override
  void paint(Canvas canvas, Size size) {
    if (drawRoom) _paintRoom(canvas);

    for (final item in items) {
      _paintItem(canvas, item);
    }
    for (final item in items) {
      _paintLabel(canvas, item);
    }
    _paintGaps(canvas);
    _paintRotateHandle(canvas);
    _paintScaleBar(canvas, size);
  }

  void _paintRoom(Canvas canvas) {
    final room = Rect.fromPoints(s(world.topLeft), s(world.bottomRight));
    canvas.drawRect(room, Paint()..color = scheme.surfaceContainerLowest);

    final fine = Paint()
      ..color = scheme.outlineVariant.withValues(alpha: 0.35)
      ..strokeWidth = 0.5;
    final bold = Paint()
      ..color = scheme.outlineVariant
      ..strokeWidth = 1;
    final step = scale * 100 < 4 ? 500 : 100; // 너무 촘촘하면 50cm만
    for (var x = step; x < world.width; x += step) {
      final dx = room.left + x * scale;
      canvas.drawLine(
        Offset(dx, room.top),
        Offset(dx, room.bottom),
        x % 500 == 0 ? bold : fine,
      );
    }
    for (var y = step; y < world.height; y += step) {
      final dy = room.top + y * scale;
      canvas.drawLine(
        Offset(room.left, dy),
        Offset(room.right, dy),
        y % 500 == 0 ? bold : fine,
      );
    }
    canvas.drawRect(
      room,
      Paint()
        ..color = scheme.onSurface
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    final dim = Paint()
      ..color = scheme.primary
      ..strokeWidth = 1;
    final topY = room.top - 22;
    canvas.drawLine(Offset(room.left, topY), Offset(room.right, topY), dim);
    canvas.drawLine(
      Offset(room.left, topY - 5),
      Offset(room.left, topY + 5),
      dim,
    );
    canvas.drawLine(
      Offset(room.right, topY - 5),
      Offset(room.right, topY + 5),
      dim,
    );
    _text(
      canvas,
      formatLength(world.width),
      Offset(room.center.dx, topY - 11),
      color: scheme.primary,
      bold: true,
    );

    final leftX = room.left - 22;
    canvas.drawLine(Offset(leftX, room.top), Offset(leftX, room.bottom), dim);
    canvas.drawLine(
      Offset(leftX - 5, room.top),
      Offset(leftX + 5, room.top),
      dim,
    );
    canvas.drawLine(
      Offset(leftX - 5, room.bottom),
      Offset(leftX + 5, room.bottom),
      dim,
    );
    canvas.save();
    canvas.translate(leftX - 11, room.center.dy);
    canvas.rotate(-math.pi / 2);
    _text(
      canvas,
      formatLength(world.height),
      Offset.zero,
      color: scheme.primary,
      bold: true,
    );
    canvas.restore();
  }

  void _paintItem(Canvas canvas, LayoutItem item) {
    final r = rectOf(item);
    final selected = item.id == selectedId;
    final overlap =
        report.overlapping.contains(item.id) ||
        report.outOfRoom.contains(item.id);
    final doorBlocked = report.doorBlocked.contains(item.id);
    final door = DoorGeometry.of(item.doorType, item.doorSwingMm, r.width);

    canvas.save();
    canvas.translate(s(r.center).dx, s(r.center).dy);
    canvas.rotate(r.rad);
    canvas.scale(scale);
    final px = 1 / scale; // 1 화면 px (mm 단위)
    final body = Rect.fromCenter(
      center: Offset.zero,
      width: r.width,
      height: r.depth,
    );

    // 문 열림 반경
    if (door != null && (showDoors || selected || doorBlocked)) {
      final c = doorBlocked ? _warnColor : scheme.tertiary;
      final fill = Paint()..color = c.withValues(alpha: 0.10);
      final line = Paint()
        ..color = c.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 * px;
      final front = r.depth / 2;
      if (door.type == 'drawer') {
        final z = Rect.fromLTWH(-r.width / 2, front, r.width, door.zoneDepth);
        canvas.drawRect(z, fill);
        _dashedRect(canvas, z, line, 6 * px);
      } else {
        for (final leaf in door.leaves) {
          final hinge = Offset(leaf.hingeX, front);
          final arcRect = Rect.fromCircle(center: hinge, radius: leaf.length);
          // 닫힌 위치(앞면을 따라) → 열린 위치(앞쪽으로 수직)까지 90° 부채꼴
          final start = leaf.opensToRight ? 0.0 : math.pi;
          final sweep = leaf.opensToRight ? math.pi / 2 : -math.pi / 2;
          final path = Path()
            ..moveTo(hinge.dx, hinge.dy)
            ..arcTo(arcRect, start, sweep, false)
            ..close();
          canvas.drawPath(path, fill);
          canvas.drawArc(arcRect, start, sweep, false, line);
          canvas.drawLine(hinge, hinge + Offset(0, leaf.length), line);
        }
      }
    }

    // 본체
    final color = Color(item.colorValue);
    canvas.drawRect(body, Paint()..color = color.withValues(alpha: 0.88));
    // 앞면 표시 (문/앞쪽 방향)
    canvas.drawLine(
      Offset(-r.width / 2, r.depth / 2),
      Offset(r.width / 2, r.depth / 2),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.45)
        ..strokeWidth = 3 * px,
    );
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (selected || overlap ? 3 : 1) * px
      ..color = overlap
          ? scheme.error
          : selected
          ? scheme.primary
          : Colors.black.withValues(alpha: 0.4);
    canvas.drawRect(body, stroke);
    if (overlap) {
      canvas.drawRect(
        body,
        Paint()..color = scheme.error.withValues(alpha: 0.15),
      );
    }
    canvas.restore();
  }

  void _paintLabel(Canvas canvas, LayoutItem item) {
    final r = rectOf(item);
    final minSide = math.min(r.width, r.depth) * scale;
    if (minSide < 28 && item.id != selectedId) return;
    final center = s(r.center);
    final lines = <String>[
      item.name,
      if (minSide >= 44 || item.id == selectedId)
        formatSize(item.widthMm, item.depthMm),
    ];
    _text(
      canvas,
      lines.join('\n'),
      center,
      color: Colors.black87,
      size: 10.5,
      bold: item.id == selectedId,
      background: Colors.white70,
    );
  }

  void _paintGaps(Canvas canvas) {
    for (final g in gaps) {
      final a = s(g.from), b = s(g.to);
      if ((b - a).distance < 2) continue;
      final narrow = g.mm < _narrowPassageMm;
      final c = narrow ? _warnColor : scheme.primary;
      final p = Paint()
        ..color = c
        ..strokeWidth = 1.5;
      canvas.drawLine(a, b, p);
      final n = (b - a) / (b - a).distance;
      final perp = Offset(-n.dy, n.dx) * 5;
      canvas.drawLine(a - perp, a + perp, p);
      canvas.drawLine(b - perp, b + perp, p);
      var labelPos = (a + b) / 2;
      // 회전 핸들과 겹치면 라벨을 옆으로 비켜 표시.
      final h = rotateHandle;
      if (h != null && (labelPos - h).distance < 80) {
        labelPos += Offset(-n.dy, n.dx) * 30;
      }
      _text(
        canvas,
        formatLength(g.mm),
        labelPos,
        color: Colors.white,
        size: 10.5,
        bold: true,
        background: c,
      );
    }
  }

  void _paintRotateHandle(Canvas canvas) {
    final h = rotateHandle;
    final sel = items.where((i) => i.id == selectedId).firstOrNull;
    if (h == null || sel == null) return;
    final r = rectOf(sel);
    final top = s(r.toWorld(Offset(0, -r.depth / 2)));
    final p = Paint()
      ..color = scheme.primary
      ..strokeWidth = 1.5;
    canvas.drawLine(top, h, p);
    canvas.drawCircle(h, 13, Paint()..color = scheme.primary);
    canvas.drawCircle(
      h,
      13,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final icon = Icons.rotate_right;
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 16,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, h - Offset(tp.width / 2, tp.height / 2));
    _text(
      canvas,
      '${sel.rotationDeg.round()}°',
      h + const Offset(0, -24),
      color: scheme.primary,
      size: 10,
      bold: true,
      background: Colors.white70,
    );
  }

  void _paintScaleBar(Canvas canvas, Size size) {
    var barMm = 1000.0;
    if (barMm * scale < 40) barMm = 2000;
    if (barMm * scale < 40) barMm = 5000;
    if (barMm * scale > size.width * 0.4) barMm = 500;
    final barPx = barMm * scale;
    final start = Offset(16, size.height - 16);
    final end = start + Offset(barPx, 0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(start.dx - 6, start.dy - 26, end.dx + 6, start.dy + 8),
        const Radius.circular(6),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
    final bar = Paint()
      ..color = scheme.primary
      ..strokeWidth = 3;
    canvas.drawLine(start, end, bar);
    canvas.drawLine(
      start - const Offset(0, 5),
      start + const Offset(0, 5),
      bar,
    );
    canvas.drawLine(end - const Offset(0, 5), end + const Offset(0, 5), bar);
    _text(
      canvas,
      formatLength(barMm),
      Offset((start.dx + end.dx) / 2, start.dy - 15),
      color: scheme.primary,
      size: 11,
      bold: true,
    );
  }

  void _dashedRect(Canvas canvas, Rect r, Paint p, double dash) {
    void dashed(Offset a, Offset b) {
      final len = (b - a).distance;
      final n = (b - a) / len;
      for (var t = 0.0; t < len; t += dash * 2) {
        canvas.drawLine(a + n * t, a + n * math.min(t + dash, len), p);
      }
    }

    dashed(r.topLeft, r.topRight);
    dashed(r.topRight, r.bottomRight);
    dashed(r.bottomRight, r.bottomLeft);
    dashed(r.bottomLeft, r.topLeft);
  }

  void _text(
    Canvas canvas,
    String text,
    Offset center, {
    required Color color,
    double size = 12,
    bool bold = false,
    Color? background,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size,
          height: 1.15,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    final topLeft = center - Offset(tp.width / 2, tp.height / 2);
    if (background != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            topLeft.dx - 4,
            topLeft.dy - 2,
            tp.width + 8,
            tp.height + 4,
          ),
          const Radius.circular(4),
        ),
        Paint()..color = background,
      );
    }
    tp.paint(canvas, topLeft);
  }

  @override
  bool shouldRepaint(EditorPainter old) => true;
}
