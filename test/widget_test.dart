import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:furniturefit/core/units.dart';
import 'package:furniturefit/data/local/app_database.dart';
import 'package:furniturefit/data/repositories/home_repository.dart';

void main() {
  group('units', () {
    test('mm 기본 표시', () {
      expect(formatLength(3600), '3,600mm');
      expect(formatSize(1500, 2000), '1,500 × 2,000mm');
      expect(formatArea(3600, 4200), '15.1m²');
    });

    test('cm 표시', () {
      expect(formatLength(3605, unit: LengthUnit.cm), '360.5cm');
    });
  });

  group('HomeRepository', () {
    late AppDatabase db;
    late HomeRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = HomeRepository(db);
    });

    tearDown(() => db.close());

    test('빈 방 집 생성 시 기본 배치안 1개가 함께 생성된다', () async {
      final id = await repo.createEmptyRoomHome(
          name: '테스트 집', roomWidthMm: 3600, roomDepthMm: 4200);

      final summaries = await repo.watchHomeSummaries().first;
      expect(summaries, hasLength(1));
      expect(summaries.single.home.id, id);
      expect(summaries.single.layoutCount, 1);
      expect(await repo.countHomes(), 1);
    });

    test('배치안 추가 및 집 삭제 시 cascade 삭제', () async {
      final id = await repo.createEmptyRoomHome(
          name: '집', roomWidthMm: 3000, roomDepthMm: 3000);
      await repo.createLayout(id, '배치안 2');
      expect(await repo.watchLayouts(id).first, hasLength(2));

      await repo.deleteHome(id);
      expect(await repo.countHomes(), 0);
      expect(await db.select(db.layouts).get(), isEmpty);
    });
  });
}
