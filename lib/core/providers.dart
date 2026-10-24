import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../data/repositories/furniture_library_repository.dart';
import '../data/repositories/home_repository.dart';
import '../domain/models/furniture_preset.dart';

/// 의존성 주입 (Riverpod). 테스트에서는 [databaseProvider]를 override 한다.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final homeRepositoryProvider =
    Provider<HomeRepository>((ref) => HomeRepository(ref.watch(databaseProvider)));

final furnitureLibraryRepositoryProvider =
    Provider<FurnitureLibraryRepository>((ref) => FurnitureLibraryRepository());

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

/// Pro 구매 여부. Step 5(인앱 결제 연동)에서 실제 구매 상태로 교체 예정.
class ProStatusNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// 개발용 토글 (디버그 빌드 설정 화면에서만 노출).
  void debugSet(bool value) => state = value;
}

final proStatusProvider =
    NotifierProvider<ProStatusNotifier, bool>(ProStatusNotifier.new);
