import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/local/app_database.dart';
import '../features/editor/editor_canvas.dart';

/// 배치도를 PNG 이미지 파일로 렌더링하는 서비스.
class LayoutImageExporter {
  const LayoutImageExporter._();

  /// 배치도를 오프스크린 캔버스에 렌더링하여 임시 PNG 파일로 저장한다.
  ///
  /// - [hd]: true면 고해상도(긴 변 2400px), false면 표준 해상도(긴 변 1280px).
  /// - [watermark]: true면 우측 하단에 `"가구들어갈까"` 워터마크를 표시한다.
  static Future<File> exportPng({
    required String title,
    required Rect world,
    required bool isRoom,
    File? floorPlanFile,
    required List<LayoutItem> items,
    required ColorScheme scheme,
    required bool hd,
    required bool watermark,
  }) async {
    final maxSidePx = hd ? 2400.0 : 1280.0;
    const marginPx = 72.0;
    const headerPx = 64.0;
    const footerPx = 44.0;

    final aspect = world.width / math.max(1.0, world.height);
    late final double bodyW;
    late final double bodyH;
    if (aspect >= 1) {
      bodyW = maxSidePx - marginPx * 2;
      bodyH = (bodyW / aspect).clamp(320.0, maxSidePx);
    } else {
      bodyH = maxSidePx - marginPx * 2 - headerPx - footerPx;
      bodyW = (bodyH * aspect).clamp(320.0, maxSidePx);
    }

    final widthPx = (bodyW + marginPx * 2).roundToDouble();
    final heightPx =
        (bodyH + marginPx * 2 + headerPx + footerPx).roundToDouble();
    final scale = math.min(bodyW / world.width, bodyH / world.height);
    final drawW = world.width * scale;
    final drawH = world.height * scale;
    final offset = Offset(
      (widthPx - drawW) / 2 - world.left * scale,
      headerPx + marginPx + (bodyH - drawH) / 2 - world.top * scale,
    );

    ui.Image? bgImage;
    if (floorPlanFile != null && await floorPlanFile.exists()) {
      final bytes = await floorPlanFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      bgImage = frame.image;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(widthPx, heightPx);

    // 1. 전체 배경
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF6F7F4),
    );

    // 2. 상단 타이틀 바
    _paintHeader(canvas, title, widthPx, scheme, hd: hd);

    // 3. 도면 이미지 (있을 때)
    if (bgImage != null) {
      final dst = Rect.fromLTWH(
        offset.dx + world.left * scale,
        offset.dy + world.top * scale,
        drawW,
        drawH,
      );
      canvas.drawImageRect(
        bgImage,
        Rect.fromLTWH(
          0,
          0,
          bgImage.width.toDouble(),
          bgImage.height.toDouble(),
        ),
        dst,
        Paint()..filterQuality = FilterQuality.high,
      );
    }

    // 4. 방·가구·문 열림 반경·축척 바
    final room = isRoom ? world : null;
    final report = analyzePlacement(items, room: room);
    final painter = EditorPainter(
      scale: scale,
      offset: offset,
      world: world,
      drawRoom: isRoom,
      items: items,
      report: report,
      selectedId: null,
      showDoors: true,
      gaps: const [],
      rotateHandle: null,
      scheme: scheme,
    );
    painter.paint(canvas, size);

    // 5. 워터마크 (무료 표준 내보내기)
    if (watermark) {
      _paintWatermark(canvas, size, scheme);
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(widthPx.round(), heightPx.round());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    img.dispose();
    bgImage?.dispose();

    final dir = await getTemporaryDirectory();
    final safeName = title.replaceAll(RegExp(r'[^\w가-힣\- ]'), '_').trim();
    final file = File(
      p.join(
        dir.path,
        'furniturefit_${safeName.isEmpty ? "layout" : safeName}_${DateTime.now().millisecondsSinceEpoch}.png',
      ),
    );
    await file.writeAsBytes(byteData!.buffer.asUint8List(), flush: true);
    return file;
  }

  static void _paintHeader(
    Canvas canvas,
    String title,
    double widthPx,
    ColorScheme scheme, {
    required bool hd,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(
          color: scheme.onSurface,
          fontSize: hd ? 28 : 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: widthPx - 96);
    tp.paint(canvas, Offset(48, 28));
  }

  static void _paintWatermark(Canvas canvas, Size size, ColorScheme scheme) {
    final tp = TextPainter(
      text: TextSpan(
        text: '가구들어갈까 · 치수 시뮬레이션',
        style: TextStyle(
          color: scheme.primary.withValues(alpha: 0.75),
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final pos = Offset(
      size.width - tp.width - 28,
      size.height - tp.height - 20,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(pos.dx - 10, pos.dy - 5, tp.width + 20, tp.height + 10),
        const Radius.circular(8),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.88),
    );
    tp.paint(canvas, pos);
  }
}
