import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

/// 배치에 추가할 가구 사양 (라이브러리 프리셋 / 내 가구 / 직접 입력 공통).
class FurnitureSpec {
  const FurnitureSpec({
    this.furnitureId,
    required this.name,
    required this.widthMm,
    required this.depthMm,
    this.heightMm,
    required this.colorValue,
    this.doorType,
    this.doorSwingMm,
  });

  final String? furnitureId;
  final String name;
  final int widthMm;
  final int depthMm;
  final int? heightMm;
  final int colorValue;
  final String? doorType;
  final int? doorSwingMm;
}

/// 배치안 위 가구와 "내 가구" 목록을 다룬다.
class LayoutRepository {
  LayoutRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Stream<List<LayoutItem>> watchItems(String layoutId) =>
      (_db.select(_db.layoutItems)
            ..where((t) => t.layoutId.equals(layoutId))
            ..orderBy([(t) => OrderingTerm.asc(t.zIndex)]))
          .watch();

  Future<String> addItem({
    required String layoutId,
    required FurnitureSpec spec,
    required double xMm,
    required double yMm,
  }) async {
    final maxZ = _db.layoutItems.zIndex.max();
    final row =
        await (_db.selectOnly(_db.layoutItems)
              ..addColumns([maxZ])
              ..where(_db.layoutItems.layoutId.equals(layoutId)))
            .getSingle();
    final id = _uuid.v4();
    await _db
        .into(_db.layoutItems)
        .insert(
          LayoutItemsCompanion.insert(
            id: id,
            layoutId: layoutId,
            furnitureId: Value(spec.furnitureId),
            name: spec.name,
            widthMm: spec.widthMm,
            depthMm: spec.depthMm,
            heightMm: Value(spec.heightMm),
            xMm: xMm,
            yMm: yMm,
            colorValue: spec.colorValue,
            doorType: Value(spec.doorType),
            doorSwingMm: Value(spec.doorSwingMm),
            zIndex: Value((row.read(maxZ) ?? 0) + 1),
          ),
        );
    await _touchLayout(layoutId);
    return id;
  }

  Future<void> updateItem(LayoutItem item) async {
    await _db.update(_db.layoutItems).replace(item);
    await _touchLayout(item.layoutId);
  }

  Future<void> deleteItem(LayoutItem item) async {
    await (_db.delete(
      _db.layoutItems,
    )..where((t) => t.id.equals(item.id))).go();
    await _touchLayout(item.layoutId);
  }

  /// 실행취소/다시실행을 위해 배치안의 가구 목록 전체를 주어진 스냅샷으로 교체한다.
  Future<void> replaceItems(String layoutId, List<LayoutItem> snapshot) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.layoutItems,
      )..where((t) => t.layoutId.equals(layoutId))).go();
      await _db.batch((b) {
        for (final it in snapshot) {
          b.insert(_db.layoutItems, it);
        }
      });
    });
    await _touchLayout(layoutId);
  }

  /// 오른쪽 아래로 살짝 비켜서 복제한다.
  Future<String> duplicateItem(LayoutItem item) => addItem(
    layoutId: item.layoutId,
    spec: FurnitureSpec(
      furnitureId: item.furnitureId,
      name: item.name,
      widthMm: item.widthMm,
      depthMm: item.depthMm,
      heightMm: item.heightMm,
      colorValue: item.colorValue,
      doorType: item.doorType,
      doorSwingMm: item.doorSwingMm,
    ),
    xMm: item.xMm + 200,
    yMm: item.yMm + 200,
  );

  Future<void> _touchLayout(String layoutId) async {
    final now = DateTime.now();
    final layout = await (_db.select(
      _db.layouts,
    )..where((t) => t.id.equals(layoutId))).getSingleOrNull();
    if (layout == null) return;
    await (_db.update(_db.layouts)..where((t) => t.id.equals(layoutId))).write(
      LayoutsCompanion(updatedAt: Value(now)),
    );
    await (_db.update(_db.homes)..where((t) => t.id.equals(layout.homeId)))
        .write(HomesCompanion(updatedAt: Value(now)));
  }

  // ---------- 내 가구 ----------

  Stream<List<CustomFurniture>> watchCustomFurnitures() => (_db.select(
    _db.customFurnitures,
  )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  Future<int> countCustomFurnitures() async {
    final c = _db.customFurnitures.id.count();
    final row = await (_db.selectOnly(
      _db.customFurnitures,
    )..addColumns([c])).getSingle();
    return row.read(c) ?? 0;
  }

  Future<String> saveCustomFurniture(FurnitureSpec spec) async {
    final id = 'custom_${_uuid.v4()}';
    await _db
        .into(_db.customFurnitures)
        .insert(
          CustomFurnituresCompanion.insert(
            id: id,
            name: spec.name,
            category: 'etc',
            widthMm: spec.widthMm,
            depthMm: spec.depthMm,
            heightMm: Value(spec.heightMm),
            colorValue: spec.colorValue,
            doorType: Value(spec.doorType),
            doorSwingMm: Value(spec.doorSwingMm),
            createdAt: DateTime.now(),
          ),
        );
    return id;
  }

  Future<void> deleteCustomFurniture(String id) =>
      (_db.delete(_db.customFurnitures)..where((t) => t.id.equals(id))).go();
}
