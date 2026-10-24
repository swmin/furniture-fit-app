import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/calibration.dart';
import '../local/app_database.dart';
import '../services/floor_plan_storage.dart';

/// 홈 목록 화면에 표시할 요약 정보.
class HomeSummary {
  const HomeSummary({required this.home, required this.layoutCount});

  final Home home;
  final int layoutCount;
}

/// 집과 배치안 데이터의 단일 진입점.
class HomeRepository {
  HomeRepository(this._db, {FloorPlanStorage? storage})
    : _storage = storage ?? FloorPlanStorage();

  final AppDatabase _db;
  final FloorPlanStorage _storage;
  static const _uuid = Uuid();

  /// 최근 수정 순으로 집 목록과 배치안 개수를 실시간 감시한다.
  Stream<List<HomeSummary>> watchHomeSummaries() {
    final layoutCount = _db.layouts.id.count();
    final query =
        _db.select(_db.homes).join([
            leftOuterJoin(
              _db.layouts,
              _db.layouts.homeId.equalsExp(_db.homes.id),
            ),
          ])
          ..addColumns([layoutCount])
          ..groupBy([_db.homes.id])
          ..orderBy([OrderingTerm.desc(_db.homes.updatedAt)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => HomeSummary(
              home: row.readTable(_db.homes),
              layoutCount: row.read(layoutCount) ?? 0,
            ),
          )
          .toList(),
    );
  }

  Future<int> countHomes() async {
    final count = _db.homes.id.count();
    final row = await (_db.selectOnly(
      _db.homes,
    )..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  Stream<Home?> watchHome(String id) => (_db.select(
    _db.homes,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  Stream<List<Layout>> watchLayouts(String homeId) =>
      (_db.select(_db.layouts)
            ..where((t) => t.homeId.equals(homeId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  /// 빈 방(직사각형) 집을 만들고 기본 배치안 1개를 함께 생성한다.
  Future<String> createEmptyRoomHome({
    required String name,
    required int roomWidthMm,
    required int roomDepthMm,
  }) {
    return _db.transaction(() async {
      final now = DateTime.now();
      final homeId = _uuid.v4();
      await _db
          .into(_db.homes)
          .insert(
            HomesCompanion.insert(
              id: homeId,
              name: name,
              roomWidthMm: Value(roomWidthMm),
              roomDepthMm: Value(roomDepthMm),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _insertLayout(homeId, '배치안 1', now);
      return homeId;
    });
  }

  /// 도면 이미지를 앱 저장소로 복사해 집을 만들고 기본 배치안을 생성한다.
  /// 축척 보정은 이후 [updateCalibration]으로 저장한다.
  Future<String> createFloorPlanHome({
    required String name,
    required String sourceImagePath,
  }) async {
    final homeId = _uuid.v4();
    final plan = await _storage.save(
      sourcePath: sourceImagePath,
      homeId: homeId,
    );
    try {
      await _db.transaction(() async {
        final now = DateTime.now();
        await _db
            .into(_db.homes)
            .insert(
              HomesCompanion.insert(
                id: homeId,
                name: name,
                floorPlanPath: Value(plan.relativePath),
                floorPlanWidthPx: Value(plan.widthPx),
                floorPlanHeightPx: Value(plan.heightPx),
                createdAt: now,
                updatedAt: now,
              ),
            );
        await _insertLayout(homeId, '배치안 1', now);
      });
    } catch (_) {
      await _storage.delete(plan.relativePath);
      rethrow;
    }
    return homeId;
  }

  /// 축척 보정 결과 저장. 두 점이 너무 가까우면 [ArgumentError].
  Future<void> updateCalibration(String homeId, Calibration calibration) {
    final mmPerPixel = calibration.mmPerPixel;
    if (mmPerPixel == null) {
      throw ArgumentError('기준선이 너무 짧습니다.');
    }
    return (_db.update(_db.homes)..where((t) => t.id.equals(homeId))).write(
      HomesCompanion(
        mmPerPixel: Value(mmPerPixel),
        calibrationJson: Value(calibration.toJson()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> renameHome(String id, String name) =>
      (_db.update(_db.homes)..where((t) => t.id.equals(id))).write(
        HomesCompanion(name: Value(name), updatedAt: Value(DateTime.now())),
      );

  /// 배치안·가구는 FK cascade로 함께 삭제되고, 도면 파일도 지운다.
  Future<void> deleteHome(String id) async {
    final home = await (_db.select(
      _db.homes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    await (_db.delete(_db.homes)..where((t) => t.id.equals(id))).go();
    final path = home?.floorPlanPath;
    if (path != null) await _storage.delete(path);
  }

  Future<String> createLayout(String homeId, String name) =>
      _insertLayout(homeId, name, DateTime.now());

  /// 배치안 이름 변경.
  Future<void> renameLayout(String layoutId, String name) async {
    final now = DateTime.now();
    await (_db.update(_db.layouts)..where((t) => t.id.equals(layoutId))).write(
      LayoutsCompanion(name: Value(name), updatedAt: Value(now)),
    );
  }

  /// 배치안과 그 안의 모든 가구를 복제해 새 배치안을 만든다.
  Future<String> duplicateLayout(String sourceLayoutId, String newName) {
    return _db.transaction(() async {
      final src = await (_db.select(
        _db.layouts,
      )..where((t) => t.id.equals(sourceLayoutId))).getSingle();
      final now = DateTime.now();
      final newLayoutId = await _insertLayout(src.homeId, newName, now);
      final items = await (_db.select(
        _db.layoutItems,
      )..where((t) => t.layoutId.equals(sourceLayoutId))).get();
      await _db.batch((b) {
        for (final it in items) {
          b.insert(
            _db.layoutItems,
            LayoutItemsCompanion.insert(
              id: _uuid.v4(),
              layoutId: newLayoutId,
              furnitureId: Value(it.furnitureId),
              name: it.name,
              widthMm: it.widthMm,
              depthMm: it.depthMm,
              heightMm: Value(it.heightMm),
              xMm: it.xMm,
              yMm: it.yMm,
              rotationDeg: Value(it.rotationDeg),
              colorValue: it.colorValue,
              doorType: Value(it.doorType),
              doorSwingMm: Value(it.doorSwingMm),
              zIndex: Value(it.zIndex),
            ),
          );
        }
      });
      await (_db.update(_db.homes)..where((t) => t.id.equals(src.homeId)))
          .write(HomesCompanion(updatedAt: Value(now)));
      return newLayoutId;
    });
  }

  /// 배치안을 삭제한다. 집에 배치안이 1개뿐이면 [StateError].
  Future<void> deleteLayout(String layoutId) async {
    final target = await (_db.select(
      _db.layouts,
    )..where((t) => t.id.equals(layoutId))).getSingleOrNull();
    if (target == null) return;
    final countExp = _db.layouts.id.count();
    final row =
        await (_db.selectOnly(_db.layouts)
              ..addColumns([countExp])
              ..where(_db.layouts.homeId.equals(target.homeId)))
            .getSingle();
    if ((row.read(countExp) ?? 0) <= 1) {
      throw StateError('최소 1개의 배치안은 남겨 두어야 합니다.');
    }
    await (_db.delete(_db.layouts)..where((t) => t.id.equals(layoutId))).go();
  }

  Future<String> _insertLayout(String homeId, String name, DateTime now) async {
    final id = _uuid.v4();
    await _db
        .into(_db.layouts)
        .insert(
          LayoutsCompanion.insert(
            id: id,
            homeId: homeId,
            name: name,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return id;
  }
}
