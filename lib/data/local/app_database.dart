import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// 집(프로젝트). 도면 이미지 1장 또는 직사각형 빈 방 1개를 가진다.
///
/// 모든 길이 값은 mm 단위 월드 좌표로 저장한다.
class Homes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 60)();

  /// 앱 내부 저장소에 복사된 도면 이미지 경로 (빈 방이면 null).
  TextColumn get floorPlanPath => text().nullable()();

  /// 축척 보정 결과: 도면 이미지 1px 당 실제 mm.
  RealColumn get mmPerPixel => real().nullable()();

  /// 축척 보정에 사용한 기준선 (JSON: {"p1":[x,y],"p2":[x,y],"lengthMm":3600}).
  TextColumn get calibrationJson => text().nullable()();

  /// 빈 방 직접 만들기 시 방 크기.
  IntColumn get roomWidthMm => integer().nullable()();
  IntColumn get roomDepthMm => integer().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 배치안. 집 하나에 여러 개 (무료/Pro 모두 무제한).
class Layouts extends Table {
  TextColumn get id => text()();
  TextColumn get homeId =>
      text().references(Homes, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 배치안 위에 놓인 가구 1개.
class LayoutItems extends Table {
  TextColumn get id => text()();
  TextColumn get layoutId =>
      text().references(Layouts, #id, onDelete: KeyAction.cascade)();

  /// 라이브러리 프리셋 ID 또는 내 가구 ID (직접 입력 1회성이면 null).
  TextColumn get furnitureId => text().nullable()();
  TextColumn get name => text()();
  IntColumn get widthMm => integer()();
  IntColumn get depthMm => integer()();
  IntColumn get heightMm => integer().nullable()();

  /// 가구 중심점 좌표 (mm).
  RealColumn get xMm => real()();
  RealColumn get yMm => real()();
  RealColumn get rotationDeg => real().withDefault(const Constant(0))();
  IntColumn get colorValue => integer()();

  /// 문 종류: null | 'single' | 'double' | 'drawer'
  TextColumn get doorType => text().nullable()();
  IntColumn get doorSwingMm => integer().nullable()();
  IntColumn get zIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 사용자가 직접 입력해 저장한 "내 가구" (무료 10개 / Pro 무제한).
class CustomFurnitures extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  TextColumn get category => text()();
  IntColumn get widthMm => integer()();
  IntColumn get depthMm => integer()();
  IntColumn get heightMm => integer().nullable()();
  IntColumn get colorValue => integer()();
  TextColumn get doorType => text().nullable()();
  IntColumn get doorSwingMm => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Homes, Layouts, LayoutItems, CustomFurnitures])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'furniturefit'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
