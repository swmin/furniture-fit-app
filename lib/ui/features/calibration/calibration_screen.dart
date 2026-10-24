import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/units.dart';
import '../../../data/local/app_database.dart';
import '../../../domain/models/calibration.dart';

/// 축척 보정 화면.
///
/// 도면 위에서 길이를 아는 벽의 양 끝 두 점을 찍고 실제 길이(mm)를 입력하면
/// `mmPerPixel`을 계산해 저장한다.
class CalibrationScreen extends ConsumerWidget {
  const CalibrationScreen({super.key, required this.homeId});

  final String homeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider(homeId)).value;
    final path = home?.floorPlanPath;
    final file = path == null
        ? null
        : ref.watch(floorPlanFileProvider(path)).value;

    if (home == null || file == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('축척 맞추기')),
        body: Center(
          child: home != null && path == null
              ? const Text('도면이 없는 집입니다.')
              : const CircularProgressIndicator(),
        ),
      );
    }
    return _CalibrationView(home: home, file: file);
  }
}

class _CalibrationView extends ConsumerStatefulWidget {
  const _CalibrationView({required this.home, required this.file});

  final Home home;
  final File file;

  @override
  ConsumerState<_CalibrationView> createState() => _CalibrationViewState();
}

enum _Gesture { none, transform, dragP1, dragP2 }

class _CalibrationViewState extends ConsumerState<_CalibrationView> {
  /// 화면 좌표 = 이미지 좌표 × [_scale] + [_offset]
  double _scale = 1;
  Offset _offset = Offset.zero;
  bool _fitted = false;
  Size _viewport = Size.zero;

  Offset? _p1;
  Offset? _p2;
  bool _snapAxis = true;
  final _length = TextEditingController();
  bool _saving = false;

  // 제스처 상태
  _Gesture _gesture = _Gesture.none;
  double _startScale = 1;
  Offset _startImageFocal = Offset.zero;
  Offset _grabOffset = Offset.zero;
  Offset? _fingerLocal;
  Offset? _downLocal;

  static const _handleHitRadius = 32.0; // 화면 px
  static const _snapToleranceDeg = 4.0;

  Size get _imageSize => Size(
    (widget.home.floorPlanWidthPx ?? 1).toDouble(),
    (widget.home.floorPlanHeightPx ?? 1).toDouble(),
  );

  @override
  void initState() {
    super.initState();
    final saved = Calibration.tryParse(widget.home.calibrationJson);
    if (saved != null) {
      _p1 = saved.p1;
      _p2 = saved.p2;
      _length.text = saved.lengthMm.toString();
    }
  }

  @override
  void dispose() {
    _length.dispose();
    super.dispose();
  }

  // ---------- 좌표 변환 ----------

  Offset _toImage(Offset screen) => (screen - _offset) / _scale;
  Offset _toScreen(Offset image) => image * _scale + _offset;

  Offset _clampToImage(Offset p) =>
      Offset(p.dx.clamp(0, _imageSize.width), p.dy.clamp(0, _imageSize.height));

  void _fit(Size viewport) {
    const pad = 16.0;
    final s = math.min(
      (viewport.width - pad * 2) / _imageSize.width,
      (viewport.height - pad * 2) / _imageSize.height,
    );
    _scale = s;
    _offset = Offset(
      (viewport.width - _imageSize.width * s) / 2,
      (viewport.height - _imageSize.height * s) / 2,
    );
  }

  double get _minScale {
    final fit = math.min(
      _viewport.width / _imageSize.width,
      _viewport.height / _imageSize.height,
    );
    return fit * 0.5;
  }

  double get _maxScale => math.max(_minScale * 2, 8.0);

  /// 다른 점과 거의 수평/수직이면 정확히 맞춘다.
  Offset _snap(Offset p, Offset? other) {
    if (!_snapAxis || other == null) return p;
    final d = p - other;
    final tol = math.tan(_snapToleranceDeg * math.pi / 180);
    if (d.dy.abs() <= d.dx.abs() * tol) return Offset(p.dx, other.dy);
    if (d.dx.abs() <= d.dy.abs() * tol) return Offset(other.dx, p.dy);
    return p;
  }

  // ---------- 제스처 ----------

  void _onTapUp(TapUpDetails d) {
    if (_p1 != null && _p2 != null) return;
    final img = _toImage(d.localPosition);
    if (img.dx < 0 ||
        img.dy < 0 ||
        img.dx > _imageSize.width ||
        img.dy > _imageSize.height) {
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      if (_p1 == null) {
        _p1 = img;
      } else {
        _p2 = _snap(img, _p1);
      }
    });
  }

  void _onScaleStart(ScaleStartDetails d) {
    final focal = d.localFocalPoint;
    _gesture = _Gesture.transform;
    // 제스처는 터치 슬롭(약 18px)을 넘긴 뒤에 시작되므로, 핸들 판정과
    // 잡은 위치 오프셋은 손가락을 처음 댄 위치(_downLocal) 기준으로 계산한다.
    final down = _downLocal ?? focal;
    if (d.pointerCount == 1) {
      for (final (point, mode) in [
        (_p2, _Gesture.dragP2),
        (_p1, _Gesture.dragP1),
      ]) {
        if (point != null &&
            (_toScreen(point) - down).distance <= _handleHitRadius) {
          _gesture = mode;
          _grabOffset = point - _toImage(down);
          _onScaleUpdate(
            ScaleUpdateDetails(localFocalPoint: focal, pointerCount: 1),
          );
          return;
        }
      }
    }
    _startScale = _scale;
    _startImageFocal = _toImage(focal);
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    final focal = d.localFocalPoint;
    switch (_gesture) {
      case _Gesture.dragP1:
        setState(() {
          _p1 = _snap(_clampToImage(_toImage(focal) + _grabOffset), _p2);
          _fingerLocal = focal;
        });
      case _Gesture.dragP2:
        setState(() {
          _p2 = _snap(_clampToImage(_toImage(focal) + _grabOffset), _p1);
          _fingerLocal = focal;
        });
      case _Gesture.transform:
        setState(() {
          _scale = (_startScale * d.scale).clamp(_minScale, _maxScale);
          _offset = focal - _startImageFocal * _scale;
        });
      case _Gesture.none:
        break;
    }
  }

  void _onScaleEnd(ScaleEndDetails d) {
    setState(() {
      _gesture = _Gesture.none;
      _fingerLocal = null;
    });
  }

  void _zoomBy(double factor) {
    final center = _viewport.center(Offset.zero);
    final img = _toImage(center);
    setState(() {
      _scale = (_scale * factor).clamp(_minScale, _maxScale);
      _offset = center - img * _scale;
    });
  }

  // ---------- 저장 ----------

  Calibration? get _calibration {
    final len = int.tryParse(_length.text);
    if (_p1 == null || _p2 == null || len == null || len <= 0) return null;
    final c = Calibration(p1: _p1!, p2: _p2!, lengthMm: len);
    return c.mmPerPixel == null ? null : c;
  }

  Future<void> _save() async {
    final c = _calibration;
    if (c == null) return;
    setState(() => _saving = true);
    await ref.read(homeRepositoryProvider).updateCalibration(widget.home.id, c);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '축척 저장 완료 · 도면 1px ≈ ${c.mmPerPixel!.toStringAsFixed(1)}mm',
        ),
      ),
    );
    Navigator.pop(context);
  }

  void _reset() => setState(() {
    _p1 = null;
    _p2 = null;
  });

  // ---------- UI ----------

  String get _guide {
    if (_p1 == null) return '① 길이를 아는 벽의 한쪽 끝을 탭하세요';
    if (_p2 == null) return '② 같은 벽의 반대쪽 끝을 탭하세요';
    return '③ 실제 길이를 입력하세요 · 점을 끌어 미세 조정';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final c = _calibration;
    final distancePx = (_p1 != null && _p2 != null)
        ? (_p2! - _p1!).distance
        : null;
    final tooShort =
        distancePx != null && distancePx < Calibration.minDistancePx;

    return Scaffold(
      appBar: AppBar(
        title: const Text('축척 맞추기'),
        actions: [
          IconButton(
            tooltip: '점 다시 찍기',
            onPressed: (_p1 != null || _p2 != null) ? _reset : null,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: Column(
        children: [
          Material(
            color: scheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    color: scheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _guide,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _viewport = constraints.biggest;
                if (!_fitted) {
                  _fit(_viewport);
                  _fitted = true;
                }
                return ClipRect(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Listener(
                          onPointerDown: (e) => _downLocal = e.localPosition,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapUp: _onTapUp,
                            onScaleStart: _onScaleStart,
                            onScaleUpdate: _onScaleUpdate,
                            onScaleEnd: _onScaleEnd,
                            child: ColoredBox(
                              color: scheme.surfaceContainerHighest,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: _offset.dx,
                                    top: _offset.dy,
                                    width: _imageSize.width * _scale,
                                    height: _imageSize.height * _scale,
                                    child: Image.file(
                                      widget.file,
                                      fit: BoxFit.fill,
                                      filterQuality: FilterQuality.medium,
                                      gaplessPlayback: true,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: _CalibrationPainter(
                                        p1: _p1 == null
                                            ? null
                                            : _toScreen(_p1!),
                                        p2: _p2 == null
                                            ? null
                                            : _toScreen(_p2!),
                                        lengthLabel: c != null
                                            ? formatLength(c.lengthMm)
                                            : null,
                                        color: scheme.error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_fingerLocal != null) _magnifier(_fingerLocal!),
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Column(
                          children: [
                            IconButton.filledTonal(
                              onPressed: () => _zoomBy(1.5),
                              icon: const Icon(Icons.zoom_in),
                            ),
                            IconButton.filledTonal(
                              onPressed: () => _zoomBy(1 / 1.5),
                              icon: const Icon(Icons.zoom_out),
                            ),
                            IconButton.filledTonal(
                              tooltip: '화면에 맞추기',
                              onPressed: () => setState(() => _fit(_viewport)),
                              icon: const Icon(Icons.fit_screen_outlined),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _bottomPanel(theme, c, distancePx, tooShort),
        ],
      ),
    );
  }

  /// 드래그 중인 점 주변을 확대해 보여주는 돋보기.
  ///
  /// RawMagnifier(BackdropFilter)는 일부 기기/에뮬레이터에서 렌더링되지 않아
  /// 이미지를 직접 확대해 그리는 방식으로 구현한다.
  Widget _magnifier(Offset finger) {
    final point = _gesture == _Gesture.dragP1 ? _p1 : _p2;
    if (point == null) return const SizedBox.shrink();
    const size = 120.0;
    const lift = 110.0;
    final zoom = math.max(_scale * 3, 1.0);
    final color = Theme.of(context).colorScheme.error;
    // 손가락 위쪽에 표시하되, 화면 위 끝에 닿으면 아래쪽에 표시.
    final above = finger.dy - lift - size / 2 > 0;
    final center = Offset(finger.dx, finger.dy + (above ? -lift : lift));
    return Positioned(
      left: center.dx - size / 2,
      top: center.dy - size / 2,
      width: size,
      height: size,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black38)],
          ),
          child: ClipOval(
            child: ColoredBox(
              color: Colors.white,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    left: size / 2 - point.dx * zoom,
                    top: size / 2 - point.dy * zoom,
                    width: _imageSize.width * zoom,
                    height: _imageSize.height * zoom,
                    child: Image.file(
                      widget.file,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.none,
                      gaplessPlayback: true,
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(painter: _CrosshairPainter(color)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomPanel(
    ThemeData theme,
    Calibration? c,
    double? distancePx,
    bool tooShort,
  ) {
    final hasLine = _p1 != null && _p2 != null;
    return Material(
      elevation: 8,
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _length,
                      enabled: hasLine,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: '기준선 실제 길이',
                        hintText: '예) 3600',
                        suffixText: 'mm',
                        isDense: true,
                        errorText: tooShort ? '두 점을 더 멀리 찍어 주세요' : null,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('수평/수직'),
                    selected: _snapAxis,
                    onSelected: (v) => setState(() => _snapAxis = v),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                c != null
                    ? '도면 1px ≈ ${c.mmPerPixel!.toStringAsFixed(2)}mm · '
                          '도면 전체 ≈ ${formatSize(_imageSize.width * c.mmPerPixel!, _imageSize.height * c.mmPerPixel!)}'
                    : '팁: 도면에 적힌 가장 긴 치수(예: 거실 폭)를 쓰면 더 정확해요.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: (c != null && !_saving) ? _save : null,
                icon: const Icon(Icons.check),
                label: const Text('축척 저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 돋보기 중앙 십자선 + 테두리.
class _CrosshairPainter extends CustomPainter {
  _CrosshairPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    canvas.drawLine(c - const Offset(18, 0), c - const Offset(4, 0), p);
    canvas.drawLine(c + const Offset(4, 0), c + const Offset(18, 0), p);
    canvas.drawLine(c - const Offset(0, 18), c - const Offset(0, 4), p);
    canvas.drawLine(c + const Offset(0, 4), c + const Offset(0, 18), p);
    canvas.drawCircle(c, 1.5, p);
    canvas.drawCircle(
      c,
      size.shortestSide / 2 - 1.5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_CrosshairPainter old) => old.color != color;
}

/// 기준선과 두 점 핸들을 화면 좌표로 그린다 (줌과 무관하게 일정한 크기).
class _CalibrationPainter extends CustomPainter {
  _CalibrationPainter({
    required this.p1,
    required this.p2,
    required this.lengthLabel,
    required this.color,
  });

  final Offset? p1;
  final Offset? p2;
  final String? lengthLabel;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = color
      ..strokeWidth = 2;
    if (p1 != null && p2 != null) {
      canvas.drawLine(p1!, p2!, line);
      if (lengthLabel != null) _label(canvas, lengthLabel!, (p1! + p2!) / 2);
    }
    for (final p in [p1, p2]) {
      if (p != null) _handle(canvas, p);
    }
  }

  void _handle(Canvas canvas, Offset p) {
    canvas.drawCircle(p, 14, Paint()..color = color.withValues(alpha: 0.18));
    canvas.drawCircle(
      p,
      14,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final cross = Paint()
      ..color = color
      ..strokeWidth = 1;
    canvas.drawLine(p - const Offset(20, 0), p + const Offset(20, 0), cross);
    canvas.drawLine(p - const Offset(0, 20), p + const Offset(0, 20), cross);
  }

  void _label(Canvas canvas, String text, Offset center) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rect = Rect.fromCenter(
      center: center - const Offset(0, 22),
      width: tp.width + 14,
      height: tp.height + 6,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      Paint()..color = color,
    );
    tp.paint(canvas, rect.topLeft + const Offset(7, 3));
  }

  @override
  bool shouldRepaint(_CalibrationPainter old) =>
      old.p1 != p1 ||
      old.p2 != p2 ||
      old.lengthLabel != lengthLabel ||
      old.color != color;
}
