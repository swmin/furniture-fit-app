import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furniturefit/data/local/app_database.dart';
import 'package:furniturefit/data/repositories/home_repository.dart';
import 'package:furniturefit/data/repositories/layout_repository.dart';

void main() {
  late AppDatabase db;
  late HomeRepository homeRepo;
  late LayoutRepository layoutRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    homeRepo = HomeRepository(db);
    layoutRepo = LayoutRepository(db);
  });

  tearDown(() => db.close());

  test('배치안 복제 시 모든 가구가 새 배치안으로 깊은 복사된다', () async {
    final homeId = await homeRepo.createEmptyRoomHome(
      name: '테스트 집',
      roomWidthMm: 3600,
      roomDepthMm: 4200,
    );
    final layouts0 = await homeRepo.watchLayouts(homeId).first;
    expect(layouts0, hasLength(1));
    final firstId = layouts0.first.id;

    await layoutRepo.addItem(
      layoutId: firstId,
      spec: const FurnitureSpec(
        name: '퀸 침대',
        widthMm: 1500,
        depthMm: 2000,
        colorValue: 0xFF8D6E63,
      ),
      xMm: 1200,
      yMm: 1500,
    );
    await layoutRepo.addItem(
      layoutId: firstId,
      spec: const FurnitureSpec(
        name: '장롱 4자',
        widthMm: 1200,
        depthMm: 600,
        colorValue: 0xFFA1887F,
        doorType: 'double',
        doorSwingMm: 550,
      ),
      xMm: 2600,
      yMm: 800,
    );

    final copyId = await homeRepo.duplicateLayout(firstId, '배치안 1 사본');
    final copyItems = await layoutRepo.watchItems(copyId).first;
    expect(copyItems, hasLength(2));
    expect(copyItems.map((i) => i.name), containsAll(['퀸 침대', '장롱 4자']));
    // ID가 원본과 달라야 함
    final origItems = await layoutRepo.watchItems(firstId).first;
    expect(
      copyItems.map((i) => i.id).toSet().intersection(
            origItems.map((i) => i.id).toSet(),
          ),
      isEmpty,
    );
  });

  test('배치안 이름 변경 및 최소 1개 배치안 삭제 방어', () async {
    final homeId = await homeRepo.createEmptyRoomHome(
      name: '테스트 집',
      roomWidthMm: 3600,
      roomDepthMm: 4200,
    );
    final first = (await homeRepo.watchLayouts(homeId).first).single;

    // 1개뿐일 때 삭제 시 StateError
    await expectLater(homeRepo.deleteLayout(first.id), throwsStateError);

    // 이름 변경
    await homeRepo.renameLayout(first.id, '침대 창가안');
    final renamed = (await homeRepo.watchLayouts(homeId).first).single;
    expect(renamed.name, '침대 창가안');

    // 2번째 배치안 추가 후 삭제 가능
    final secondId = await homeRepo.createLayout(homeId, '배치안 2');
    expect(await homeRepo.watchLayouts(homeId).first, hasLength(2));
    await homeRepo.deleteLayout(secondId);
    expect(await homeRepo.watchLayouts(homeId).first, hasLength(1));
  });

  test('replaceItems로 실행취소/다시실행 스냅샷을 복원할 수 있다', () async {
    final homeId = await homeRepo.createEmptyRoomHome(
      name: '테스트 집',
      roomWidthMm: 3600,
      roomDepthMm: 4200,
    );
    final layoutId = (await homeRepo.watchLayouts(homeId).first).single.id;

    await layoutRepo.addItem(
      layoutId: layoutId,
      spec: const FurnitureSpec(
        name: '책상',
        widthMm: 1200,
        depthMm: 600,
        colorValue: 0xFF90A4AE,
      ),
      xMm: 1000,
      yMm: 1000,
    );
    final snap1 = await layoutRepo.watchItems(layoutId).first;
    expect(snap1, hasLength(1));

    await layoutRepo.addItem(
      layoutId: layoutId,
      spec: const FurnitureSpec(
        name: '의자',
        widthMm: 600,
        depthMm: 600,
        colorValue: 0xFF78909C,
      ),
      xMm: 1000,
      yMm: 1700,
    );
    final snap2 = await layoutRepo.watchItems(layoutId).first;
    expect(snap2, hasLength(2));

    // Undo → snap1
    await layoutRepo.replaceItems(layoutId, snap1);
    final afterUndo = await layoutRepo.watchItems(layoutId).first;
    expect(afterUndo, hasLength(1));
    expect(afterUndo.single.name, '책상');

    // Redo → snap2
    await layoutRepo.replaceItems(layoutId, snap2);
    final afterRedo = await layoutRepo.watchItems(layoutId).first;
    expect(afterRedo, hasLength(2));
  });
}
