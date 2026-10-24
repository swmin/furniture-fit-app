import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../data/repositories/furniture_library_repository.dart';
import '../data/repositories/home_repository.dart';
import '../data/repositories/layout_repository.dart';
import '../data/services/floor_plan_storage.dart';
import '../domain/models/furniture_preset.dart';

/// 의존성 주입 (Riverpod). 테스트에서는 [databaseProvider]를 override 한다.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final floorPlanStorageProvider = Provider<FloorPlanStorage>(
  (ref) => FloorPlanStorage(),
);

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepository(
    ref.watch(databaseProvider),
    storage: ref.watch(floorPlanStorageProvider),
  ),
);

/// 도면 상대 경로 → 실제 파일.
final floorPlanFileProvider = FutureProvider.family<File, String>(
  (ref, relativePath) =>
      ref.watch(floorPlanStorageProvider).resolve(relativePath),
);

final furnitureLibraryRepositoryProvider = Provider<FurnitureLibraryRepository>(
  (ref) => FurnitureLibraryRepository(),
);

final homeSummariesProvider = StreamProvider<List<HomeSummary>>(
  (ref) => ref.watch(homeRepositoryProvider).watchHomeSummaries(),
);

final homeProvider = StreamProvider.family<Home?, String>(
  (ref, id) => ref.watch(homeRepositoryProvider).watchHome(id),
);

final layoutsProvider = StreamProvider.family<List<Layout>, String>(
  (ref, homeId) => ref.watch(homeRepositoryProvider).watchLayouts(homeId),
);

final furniturePresetsProvider = FutureProvider<List<FurniturePreset>>(
  (ref) => ref.watch(furnitureLibraryRepositoryProvider).loadPresets(),
);

final layoutRepositoryProvider = Provider<LayoutRepository>(
  (ref) => LayoutRepository(ref.watch(databaseProvider)),
);

final layoutItemsProvider = StreamProvider.family<List<LayoutItem>, String>(
  (ref, layoutId) => ref.watch(layoutRepositoryProvider).watchItems(layoutId),
);

final customFurnituresProvider = StreamProvider<List<CustomFurniture>>(
  (ref) => ref.watch(layoutRepositoryProvider).watchCustomFurnitures(),
);

/// Pro 구매 여부. Step 5(인앱 결제 연동)에서 실제 구매 상태로 교체 예정.
class ProStatusNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// 개발용 토글 (디버그 빌드 설정 화면에서만 노출).
  void debugSet(bool value) => state = value;
}

final proStatusProvider = NotifierProvider<ProStatusNotifier, bool>(
  ProStatusNotifier.new,
);
