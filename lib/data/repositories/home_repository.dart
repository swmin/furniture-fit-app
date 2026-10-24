import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

/// 홈 목록 화면에 표시할 요약 정보.
class HomeSummary {
  const HomeSummary({required this.home, required this.layoutCount});

  final Home home;
  final int layoutCount;
}

/// 집과 배치안 데이터의 단일 진입점.
class HomeRepository {
  HomeRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  /// 최근 수정 순으로 집 목록과 배치안 개수를 실시간 감시한다.
  Stream<List<HomeSummary>> watchHomeSummaries() {
    final layoutCount = _db.layouts.id.count();
    final query = _db.select(_db.homes).join([
      leftOuterJoin(_db.layouts, _db.layouts.homeId.equalsExp(_db.homes.id)),
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
    final row = await (_db.selectOnly(_db.homes)..addColumns([count]))
        .getSingle();
    return row.read(count) ?? 0;
  }

  Stream<Home?> watchHome(String id) =>
      (_db.select(_db.homes)..where((t) => t.id.equals(id)))
          .watchSingleOrNull();

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
      await _db.into(_db.homes).insert(
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

  Future<void> renameHome(String id, String name) =>
      (_db.update(_db.homes)..where((t) => t.id.equals(id))).write(
        HomesCompanion(name: Value(name), updatedAt: Value(DateTime.now())),
      );

  /// 배치안·가구는 FK cascade로 함께 삭제된다.
  Future<void> deleteHome(String id) =>
      (_db.delete(_db.homes)..where((t) => t.id.equals(id))).go();

  Future<String> createLayout(String homeId, String name) =>
      _insertLayout(homeId, name, DateTime.now());

  Future<String> _insertLayout(String homeId, String name, DateTime now) async {
    final id = _uuid.v4();
    await _db.into(_db.layouts).insert(
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
