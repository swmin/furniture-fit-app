import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:furniturefit/data/local/app_database.dart';
import 'package:furniturefit/data/repositories/home_repository.dart';
import 'package:furniturefit/data/services/floor_plan_storage.dart';
import 'package:furniturefit/domain/models/calibration.dart';

Future<File> _writePng(Directory dir, int w, int h) async {
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder)
      .drawRect(Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()), Paint());
  final image = await recorder.endRecording().toImage(w, h);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  final f = File('${dir.path}/src.png');
  await f.writeAsBytes(bytes!.buffer.asUint8List());
  return f;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Calibration', () {
    test('mmPerPixel = 실제 길이 / 픽셀 거리', () {
      const c = Calibration(
        p1: Offset(100, 200),
        p2: Offset(400, 200),
        lengthMm: 3600,
      );
      expect(c.distancePx, 300);
      expect(c.mmPerPixel, 12);
    });

    test('기준선이 너무 짧으면 null', () {
      const c = Calibration(
        p1: Offset(100, 100),
        p2: Offset(105, 100),
        lengthMm: 1000,
      );
      expect(c.mmPerPixel, isNull);
    });

    test('JSON 왕복', () {
      const c = Calibration(
        p1: Offset(1.5, 2),
        p2: Offset(300, 4),
        lengthMm: 4200,
      );
      final r = Calibration.tryParse(c.toJson())!;
      expect(r.p1, c.p1);
      expect(r.p2, c.p2);
      expect(r.lengthMm, 4200);
      expect(Calibration.tryParse('broken'), isNull);
    });
  });

  group('도면 집', () {
    late Directory tmp;
    late AppDatabase db;
    late HomeRepository repo;

    setUp(() async {
      tmp = await Directory.systemTemp.createTemp('ff_test');
      db = AppDatabase(NativeDatabase.memory());
      repo = HomeRepository(
        db,
        storage: FloorPlanStorage(baseDir: () async => tmp),
      );
    });

    tearDown(() async {
      await db.close();
      await tmp.delete(recursive: true);
    });

    test('도면 복사·크기 저장 → 축척 저장 → 삭제 시 파일 제거', () async {
      final src = await _writePng(tmp, 640, 480);
      final id = await repo.createFloorPlanHome(
        name: '도면 집',
        sourceImagePath: src.path,
      );

      var home = (await repo.watchHome(id).first)!;
      expect(home.floorPlanWidthPx, 640);
      expect(home.floorPlanHeightPx, 480);
      expect(home.mmPerPixel, isNull);
      final stored = File('${tmp.path}/${home.floorPlanPath}');
      expect(stored.existsSync(), isTrue);

      await repo.updateCalibration(
        id,
        const Calibration(p1: Offset(0, 0), p2: Offset(320, 0), lengthMm: 4000),
      );
      home = (await repo.watchHome(id).first)!;
      expect(home.mmPerPixel, 12.5);
      expect(Calibration.tryParse(home.calibrationJson)!.lengthMm, 4000);

      await repo.deleteHome(id);
      expect(stored.existsSync(), isFalse);
    });

    test('너무 짧은 기준선은 저장 거부', () async {
      final src = await _writePng(tmp, 100, 100);
      final id = await repo.createFloorPlanHome(
        name: 'x',
        sourceImagePath: src.path,
      );
      expect(
        () => repo.updateCalibration(
          id,
          const Calibration(p1: Offset(0, 0), p2: Offset(5, 0), lengthMm: 1000),
        ),
        throwsArgumentError,
      );
    });
  });
}
