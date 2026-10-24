import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/units.dart';
import '../../../data/local/app_database.dart';
import '../../../domain/models/calibration.dart';

/// 배치 편집 화면.
///
/// Step 1: 방 렌더링(그리드·치수) + 줌/팬 + 배치안 전환/추가.
/// Step 3에서 가구 추가·드래그·회전·간격 표시가 붙는다.
class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key, required this.homeId});

  final String homeId;

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  String? _selectedLayoutId;

  @override
  Widget build(BuildContext context) {
    final home = ref.watch(homeProvider(widget.homeId));
    final layouts = ref.watch(layoutsProvider(widget.homeId));

    return home.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (h) {
        if (h == null) {
          return const Scaffold(body: Center(child: Text('삭제된 집입니다.')));
        }
        final layoutList = layouts.value ?? const <Layout>[];
        final selected = layoutList.isEmpty
            ? null
            : layoutList.firstWhere(
                (l) => l.id == _selectedLayoutId,
                orElse: () => layoutList.first,
              );

        return Scaffold(
          appBar: AppBar(
            title: Text(h.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              if (h.floorPlanPath != null)
                IconButton(
                  tooltip: '축척 다시 맞추기',
                  icon: const Icon(Icons.straighten),
                  onPressed: () => context.push('/homes/${h.id}/calibrate'),
                ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: _LayoutBar(
                layouts: layoutList,
                selectedId: selected?.id,
                onSelect: (id) => setState(() => _selectedLayoutId = id),
                onAdd: () => _addLayout(layoutList.length + 1),
              ),
            ),
          ),
          body: h.floorPlanPath != null
              ? _FloorPlanCanvas(home: h)
              : _RoomCanvas(home: h),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FilledButton.tonalIcon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('가구 배치 기능은 Step 3에서 추가됩니다.')),
                ),
                icon: const Icon(Icons.add),
                label: const Text('가구 추가'),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addLayout(int nextNumber) async {
    final id = await ref
        .read(homeRepositoryProvider)
        .createLayout(widget.homeId, '배치안 $nextNumber');
    setState(() => _selectedLayoutId = id);
  }
}

class _LayoutBar extends StatelessWidget {
  const _LayoutBar({
    required this.layouts,
    required this.selectedId,
    required this.onSelect,
    required this.onAdd,
  });

  final List<Layout> layouts;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          for (final l in layouts)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(l.name),
                selected: l.id == selectedId,
                onSelected: (_) => onSelect(l.id),
              ),
            ),
          ActionChip(
            avatar: const Icon(Icons.add, size: 18),
            label: const Text('배치안'),
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}

/// 방을 mm 월드 좌표로 그리고 화면에 맞춰 축소한다.
class _RoomCanvas extends StatelessWidget {
  const _RoomCanvas({required this.home});

  final Home home;

  @override
  Widget build(BuildContext context) {
    final roomW = home.roomWidthMm;
    final roomD = home.roomDepthMm;
    if (roomW == null || roomD == null) {
      return const Center(child: Text('도면 표시는 Step 2에서 지원됩니다.'));
    }
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 여백(치수 라벨 공간)을 두고 화면에 꽉 차게 맞춘다.
        const margin = 56.0;
        final scale = math.min(
          (constraints.maxWidth - margin * 2) / roomW,
          (constraints.maxHeight - margin * 2) / roomD,
        );
        final canvasSize = Size(
          roomW * scale + margin * 2,
          roomD * scale + margin * 2,
        );

        return InteractiveViewer(
          minScale: 0.5,
          maxScale: 8,
          boundaryMargin: const EdgeInsets.all(200),
          child: Center(
            child: CustomPaint(
              size: canvasSize,
              painter: RoomPainter(
                roomWidthMm: roomW,
                roomDepthMm: roomD,
                pxPerMm: scale,
                margin: margin,
                wallColor: scheme.onSurface,
                gridColor: scheme.outlineVariant,
                floorColor: scheme.surfaceContainerLowest,
                labelColor: scheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 도면 이미지를 배경으로 그리고, 축척이 맞춰졌으면 1m 스케일 바와 기준선을 표시한다.
class _FloorPlanCanvas extends ConsumerWidget {
  const _FloorPlanCanvas({required this.home});

  final Home home;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(floorPlanFileProvider(home.floorPlanPath!)).value;
    final imgW = home.floorPlanWidthPx?.toDouble();
    final imgH = home.floorPlanHeightPx?.toDouble();
    if (file == null || imgW == null || imgH == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final scheme = Theme.of(context).colorScheme;
    final mmPerPixel = home.mmPerPixel;
    final calibration = Calibration.tryParse(home.calibrationJson);

    return Column(
      children: [
        if (mmPerPixel == null)
          MaterialBanner(
            backgroundColor: scheme.errorContainer,
            content: const Text(
              '축척이 아직 맞춰지지 않았어요. 가구를 정확히 배치하려면 먼저 축척을 맞춰 주세요.',
            ),
            actions: [
              FilledButton(
                onPressed: () => context.push('/homes/${home.id}/calibrate'),
                child: const Text('축척 맞추기'),
              ),
            ],
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const margin = 16.0;
              // fit: 화면 px / 이미지 px
              final fit = math.min(
                (constraints.maxWidth - margin * 2) / imgW,
                (constraints.maxHeight - margin * 2) / imgH,
              );
              final size = Size(imgW * fit, imgH * fit);
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 10,
                boundaryMargin: const EdgeInsets.all(200),
                child: Center(
                  child: SizedBox.fromSize(
                    size: size,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          file,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.medium,
                        ),
                        if (mmPerPixel != null)
                          CustomPaint(
                            painter: FloorPlanOverlayPainter(
                              screenPxPerMm: fit / mmPerPixel,
                              calibrationP1: calibration == null
                                  ? null
                                  : calibration.p1 * fit,
                              calibrationP2: calibration == null
                                  ? null
                                  : calibration.p2 * fit,
                              color: scheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 도면 위 오버레이: 좌하단 1m 스케일 바 + 축척 기준선(점선 느낌의 반투명 선).
class FloorPlanOverlayPainter extends CustomPainter {
  FloorPlanOverlayPainter({
    required this.screenPxPerMm,
    required this.calibrationP1,
    required this.calibrationP2,
    required this.color,
  });

  final double screenPxPerMm;
  final Offset? calibrationP1;
  final Offset? calibrationP2;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (calibrationP1 != null && calibrationP2 != null) {
      canvas.drawLine(
        calibrationP1!,
        calibrationP2!,
        Paint()
          ..color = color.withValues(alpha: 0.5)
          ..strokeWidth = 2,
      );
    }

    // 1m 스케일 바 (너무 짧거나 길면 0.5m / 2m로 조정).
    var barMm = 1000.0;
    if (barMm * screenPxPerMm < 40) barMm = 2000;
    if (barMm * screenPxPerMm > size.width * 0.5) barMm = 500;
    final barPx = barMm * screenPxPerMm;
    final start = Offset(12, size.height - 14);
    final end = start + Offset(barPx, 0);

    final bg = Paint()..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(start.dx - 6, start.dy - 26, end.dx + 6, start.dy + 8),
        const Radius.circular(6),
      ),
      bg,
    );
    final bar = Paint()
      ..color = color
      ..strokeWidth = 3;
    canvas.drawLine(start, end, bar);
    canvas.drawLine(
      start - const Offset(0, 5),
      start + const Offset(0, 5),
      bar,
    );
    canvas.drawLine(end - const Offset(0, 5), end + const Offset(0, 5), bar);

    final tp = TextPainter(
      text: TextSpan(
        text: formatLength(barMm),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((start.dx + end.dx - tp.width) / 2, start.dy - 22));
  }

  @override
  bool shouldRepaint(FloorPlanOverlayPainter old) =>
      old.screenPxPerMm != screenPxPerMm ||
      old.calibrationP1 != calibrationP1 ||
      old.calibrationP2 != calibrationP2 ||
      old.color != color;
}

/// 방 바닥·그리드(100mm/500mm)·벽·치수선을 그린다.
class RoomPainter extends CustomPainter {
  RoomPainter({
    required this.roomWidthMm,
    required this.roomDepthMm,
    required this.pxPerMm,
    required this.margin,
    required this.wallColor,
    required this.gridColor,
    required this.floorColor,
    required this.labelColor,
  });

  final int roomWidthMm;
  final int roomDepthMm;
  final double pxPerMm;
  final double margin;
  final Color wallColor;
  final Color gridColor;
  final Color floorColor;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    final room = Rect.fromLTWH(
      margin,
      margin,
      roomWidthMm * pxPerMm,
      roomDepthMm * pxPerMm,
    );

    canvas.drawRect(room, Paint()..color = floorColor);

    // 그리드: 100mm 가는 선, 500mm 진한 선.
    final fine = Paint()
      ..color = gridColor.withValues(alpha: 0.35)
      ..strokeWidth = 0.5;
    final bold = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var x = 100; x < roomWidthMm; x += 100) {
      final dx = room.left + x * pxPerMm;
      canvas.drawLine(
        Offset(dx, room.top),
        Offset(dx, room.bottom),
        x % 500 == 0 ? bold : fine,
      );
    }
    for (var y = 100; y < roomDepthMm; y += 100) {
      final dy = room.top + y * pxPerMm;
      canvas.drawLine(
        Offset(room.left, dy),
        Offset(room.right, dy),
        y % 500 == 0 ? bold : fine,
      );
    }

    // 벽.
    canvas.drawRect(
      room,
      Paint()
        ..color = wallColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // 치수선 (상단: 가로, 왼쪽: 세로).
    final dim = Paint()
      ..color = labelColor
      ..strokeWidth = 1;
    final topY = room.top - 24;
    canvas.drawLine(Offset(room.left, topY), Offset(room.right, topY), dim);
    canvas.drawLine(
      Offset(room.left, topY - 6),
      Offset(room.left, topY + 6),
      dim,
    );
    canvas.drawLine(
      Offset(room.right, topY - 6),
      Offset(room.right, topY + 6),
      dim,
    );
    _label(
      canvas,
      formatLength(roomWidthMm),
      Offset(room.center.dx, topY - 12),
    );

    final leftX = room.left - 24;
    canvas.drawLine(Offset(leftX, room.top), Offset(leftX, room.bottom), dim);
    canvas.drawLine(
      Offset(leftX - 6, room.top),
      Offset(leftX + 6, room.top),
      dim,
    );
    canvas.drawLine(
      Offset(leftX - 6, room.bottom),
      Offset(leftX + 6, room.bottom),
      dim,
    );
    canvas.save();
    canvas.translate(leftX - 12, room.center.dy);
    canvas.rotate(-math.pi / 2);
    _label(canvas, formatLength(roomDepthMm), Offset.zero);
    canvas.restore();
  }

  void _label(Canvas canvas, String text, Offset center) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: labelColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(RoomPainter old) =>
      old.roomWidthMm != roomWidthMm ||
      old.roomDepthMm != roomDepthMm ||
      old.pxPerMm != pxPerMm ||
      old.wallColor != wallColor;
}
