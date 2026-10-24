// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HomesTable extends Homes with TableInfo<$HomesTable, Home> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HomesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _floorPlanPathMeta = const VerificationMeta(
    'floorPlanPath',
  );
  @override
  late final GeneratedColumn<String> floorPlanPath = GeneratedColumn<String>(
    'floor_plan_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _floorPlanWidthPxMeta = const VerificationMeta(
    'floorPlanWidthPx',
  );
  @override
  late final GeneratedColumn<int> floorPlanWidthPx = GeneratedColumn<int>(
    'floor_plan_width_px',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _floorPlanHeightPxMeta = const VerificationMeta(
    'floorPlanHeightPx',
  );
  @override
  late final GeneratedColumn<int> floorPlanHeightPx = GeneratedColumn<int>(
    'floor_plan_height_px',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mmPerPixelMeta = const VerificationMeta(
    'mmPerPixel',
  );
  @override
  late final GeneratedColumn<double> mmPerPixel = GeneratedColumn<double>(
    'mm_per_pixel',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calibrationJsonMeta = const VerificationMeta(
    'calibrationJson',
  );
  @override
  late final GeneratedColumn<String> calibrationJson = GeneratedColumn<String>(
    'calibration_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roomWidthMmMeta = const VerificationMeta(
    'roomWidthMm',
  );
  @override
  late final GeneratedColumn<int> roomWidthMm = GeneratedColumn<int>(
    'room_width_mm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roomDepthMmMeta = const VerificationMeta(
    'roomDepthMm',
  );
  @override
  late final GeneratedColumn<int> roomDepthMm = GeneratedColumn<int>(
    'room_depth_mm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    floorPlanPath,
    floorPlanWidthPx,
    floorPlanHeightPx,
    mmPerPixel,
    calibrationJson,
    roomWidthMm,
    roomDepthMm,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'homes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Home> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('floor_plan_path')) {
      context.handle(
        _floorPlanPathMeta,
        floorPlanPath.isAcceptableOrUnknown(
          data['floor_plan_path']!,
          _floorPlanPathMeta,
        ),
      );
    }
    if (data.containsKey('floor_plan_width_px')) {
      context.handle(
        _floorPlanWidthPxMeta,
        floorPlanWidthPx.isAcceptableOrUnknown(
          data['floor_plan_width_px']!,
          _floorPlanWidthPxMeta,
        ),
      );
    }
    if (data.containsKey('floor_plan_height_px')) {
      context.handle(
        _floorPlanHeightPxMeta,
        floorPlanHeightPx.isAcceptableOrUnknown(
          data['floor_plan_height_px']!,
          _floorPlanHeightPxMeta,
        ),
      );
    }
    if (data.containsKey('mm_per_pixel')) {
      context.handle(
        _mmPerPixelMeta,
        mmPerPixel.isAcceptableOrUnknown(
          data['mm_per_pixel']!,
          _mmPerPixelMeta,
        ),
      );
    }
    if (data.containsKey('calibration_json')) {
      context.handle(
        _calibrationJsonMeta,
        calibrationJson.isAcceptableOrUnknown(
          data['calibration_json']!,
          _calibrationJsonMeta,
        ),
      );
    }
    if (data.containsKey('room_width_mm')) {
      context.handle(
        _roomWidthMmMeta,
        roomWidthMm.isAcceptableOrUnknown(
          data['room_width_mm']!,
          _roomWidthMmMeta,
        ),
      );
    }
    if (data.containsKey('room_depth_mm')) {
      context.handle(
        _roomDepthMmMeta,
        roomDepthMm.isAcceptableOrUnknown(
          data['room_depth_mm']!,
          _roomDepthMmMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Home map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Home(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      floorPlanPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}floor_plan_path'],
      ),
      floorPlanWidthPx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}floor_plan_width_px'],
      ),
      floorPlanHeightPx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}floor_plan_height_px'],
      ),
      mmPerPixel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mm_per_pixel'],
      ),
      calibrationJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calibration_json'],
      ),
      roomWidthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}room_width_mm'],
      ),
      roomDepthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}room_depth_mm'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HomesTable createAlias(String alias) {
    return $HomesTable(attachedDatabase, alias);
  }
}

class Home extends DataClass implements Insertable<Home> {
  final String id;
  final String name;

  /// 앱 내부 저장소(문서 폴더) 기준 도면 이미지 상대 경로 (빈 방이면 null).
  final String? floorPlanPath;

  /// 도면 이미지 픽셀 크기 (schema v2).
  final int? floorPlanWidthPx;
  final int? floorPlanHeightPx;

  /// 축척 보정 결과: 도면 이미지 1px 당 실제 mm.
  final double? mmPerPixel;

  /// 축척 보정에 사용한 기준선 (JSON: {"p1":[x,y],"p2":[x,y],"lengthMm":3600}).
  final String? calibrationJson;

  /// 빈 방 직접 만들기 시 방 크기.
  final int? roomWidthMm;
  final int? roomDepthMm;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Home({
    required this.id,
    required this.name,
    this.floorPlanPath,
    this.floorPlanWidthPx,
    this.floorPlanHeightPx,
    this.mmPerPixel,
    this.calibrationJson,
    this.roomWidthMm,
    this.roomDepthMm,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || floorPlanPath != null) {
      map['floor_plan_path'] = Variable<String>(floorPlanPath);
    }
    if (!nullToAbsent || floorPlanWidthPx != null) {
      map['floor_plan_width_px'] = Variable<int>(floorPlanWidthPx);
    }
    if (!nullToAbsent || floorPlanHeightPx != null) {
      map['floor_plan_height_px'] = Variable<int>(floorPlanHeightPx);
    }
    if (!nullToAbsent || mmPerPixel != null) {
      map['mm_per_pixel'] = Variable<double>(mmPerPixel);
    }
    if (!nullToAbsent || calibrationJson != null) {
      map['calibration_json'] = Variable<String>(calibrationJson);
    }
    if (!nullToAbsent || roomWidthMm != null) {
      map['room_width_mm'] = Variable<int>(roomWidthMm);
    }
    if (!nullToAbsent || roomDepthMm != null) {
      map['room_depth_mm'] = Variable<int>(roomDepthMm);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HomesCompanion toCompanion(bool nullToAbsent) {
    return HomesCompanion(
      id: Value(id),
      name: Value(name),
      floorPlanPath: floorPlanPath == null && nullToAbsent
          ? const Value.absent()
          : Value(floorPlanPath),
      floorPlanWidthPx: floorPlanWidthPx == null && nullToAbsent
          ? const Value.absent()
          : Value(floorPlanWidthPx),
      floorPlanHeightPx: floorPlanHeightPx == null && nullToAbsent
          ? const Value.absent()
          : Value(floorPlanHeightPx),
      mmPerPixel: mmPerPixel == null && nullToAbsent
          ? const Value.absent()
          : Value(mmPerPixel),
      calibrationJson: calibrationJson == null && nullToAbsent
          ? const Value.absent()
          : Value(calibrationJson),
      roomWidthMm: roomWidthMm == null && nullToAbsent
          ? const Value.absent()
          : Value(roomWidthMm),
      roomDepthMm: roomDepthMm == null && nullToAbsent
          ? const Value.absent()
          : Value(roomDepthMm),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Home.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Home(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      floorPlanPath: serializer.fromJson<String?>(json['floorPlanPath']),
      floorPlanWidthPx: serializer.fromJson<int?>(json['floorPlanWidthPx']),
      floorPlanHeightPx: serializer.fromJson<int?>(json['floorPlanHeightPx']),
      mmPerPixel: serializer.fromJson<double?>(json['mmPerPixel']),
      calibrationJson: serializer.fromJson<String?>(json['calibrationJson']),
      roomWidthMm: serializer.fromJson<int?>(json['roomWidthMm']),
      roomDepthMm: serializer.fromJson<int?>(json['roomDepthMm']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'floorPlanPath': serializer.toJson<String?>(floorPlanPath),
      'floorPlanWidthPx': serializer.toJson<int?>(floorPlanWidthPx),
      'floorPlanHeightPx': serializer.toJson<int?>(floorPlanHeightPx),
      'mmPerPixel': serializer.toJson<double?>(mmPerPixel),
      'calibrationJson': serializer.toJson<String?>(calibrationJson),
      'roomWidthMm': serializer.toJson<int?>(roomWidthMm),
      'roomDepthMm': serializer.toJson<int?>(roomDepthMm),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Home copyWith({
    String? id,
    String? name,
    Value<String?> floorPlanPath = const Value.absent(),
    Value<int?> floorPlanWidthPx = const Value.absent(),
    Value<int?> floorPlanHeightPx = const Value.absent(),
    Value<double?> mmPerPixel = const Value.absent(),
    Value<String?> calibrationJson = const Value.absent(),
    Value<int?> roomWidthMm = const Value.absent(),
    Value<int?> roomDepthMm = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Home(
    id: id ?? this.id,
    name: name ?? this.name,
    floorPlanPath: floorPlanPath.present
        ? floorPlanPath.value
        : this.floorPlanPath,
    floorPlanWidthPx: floorPlanWidthPx.present
        ? floorPlanWidthPx.value
        : this.floorPlanWidthPx,
    floorPlanHeightPx: floorPlanHeightPx.present
        ? floorPlanHeightPx.value
        : this.floorPlanHeightPx,
    mmPerPixel: mmPerPixel.present ? mmPerPixel.value : this.mmPerPixel,
    calibrationJson: calibrationJson.present
        ? calibrationJson.value
        : this.calibrationJson,
    roomWidthMm: roomWidthMm.present ? roomWidthMm.value : this.roomWidthMm,
    roomDepthMm: roomDepthMm.present ? roomDepthMm.value : this.roomDepthMm,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Home copyWithCompanion(HomesCompanion data) {
    return Home(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      floorPlanPath: data.floorPlanPath.present
          ? data.floorPlanPath.value
          : this.floorPlanPath,
      floorPlanWidthPx: data.floorPlanWidthPx.present
          ? data.floorPlanWidthPx.value
          : this.floorPlanWidthPx,
      floorPlanHeightPx: data.floorPlanHeightPx.present
          ? data.floorPlanHeightPx.value
          : this.floorPlanHeightPx,
      mmPerPixel: data.mmPerPixel.present
          ? data.mmPerPixel.value
          : this.mmPerPixel,
      calibrationJson: data.calibrationJson.present
          ? data.calibrationJson.value
          : this.calibrationJson,
      roomWidthMm: data.roomWidthMm.present
          ? data.roomWidthMm.value
          : this.roomWidthMm,
      roomDepthMm: data.roomDepthMm.present
          ? data.roomDepthMm.value
          : this.roomDepthMm,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Home(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('floorPlanPath: $floorPlanPath, ')
          ..write('floorPlanWidthPx: $floorPlanWidthPx, ')
          ..write('floorPlanHeightPx: $floorPlanHeightPx, ')
          ..write('mmPerPixel: $mmPerPixel, ')
          ..write('calibrationJson: $calibrationJson, ')
          ..write('roomWidthMm: $roomWidthMm, ')
          ..write('roomDepthMm: $roomDepthMm, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    floorPlanPath,
    floorPlanWidthPx,
    floorPlanHeightPx,
    mmPerPixel,
    calibrationJson,
    roomWidthMm,
    roomDepthMm,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Home &&
          other.id == this.id &&
          other.name == this.name &&
          other.floorPlanPath == this.floorPlanPath &&
          other.floorPlanWidthPx == this.floorPlanWidthPx &&
          other.floorPlanHeightPx == this.floorPlanHeightPx &&
          other.mmPerPixel == this.mmPerPixel &&
          other.calibrationJson == this.calibrationJson &&
          other.roomWidthMm == this.roomWidthMm &&
          other.roomDepthMm == this.roomDepthMm &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HomesCompanion extends UpdateCompanion<Home> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> floorPlanPath;
  final Value<int?> floorPlanWidthPx;
  final Value<int?> floorPlanHeightPx;
  final Value<double?> mmPerPixel;
  final Value<String?> calibrationJson;
  final Value<int?> roomWidthMm;
  final Value<int?> roomDepthMm;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HomesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.floorPlanPath = const Value.absent(),
    this.floorPlanWidthPx = const Value.absent(),
    this.floorPlanHeightPx = const Value.absent(),
    this.mmPerPixel = const Value.absent(),
    this.calibrationJson = const Value.absent(),
    this.roomWidthMm = const Value.absent(),
    this.roomDepthMm = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HomesCompanion.insert({
    required String id,
    required String name,
    this.floorPlanPath = const Value.absent(),
    this.floorPlanWidthPx = const Value.absent(),
    this.floorPlanHeightPx = const Value.absent(),
    this.mmPerPixel = const Value.absent(),
    this.calibrationJson = const Value.absent(),
    this.roomWidthMm = const Value.absent(),
    this.roomDepthMm = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Home> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? floorPlanPath,
    Expression<int>? floorPlanWidthPx,
    Expression<int>? floorPlanHeightPx,
    Expression<double>? mmPerPixel,
    Expression<String>? calibrationJson,
    Expression<int>? roomWidthMm,
    Expression<int>? roomDepthMm,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (floorPlanPath != null) 'floor_plan_path': floorPlanPath,
      if (floorPlanWidthPx != null) 'floor_plan_width_px': floorPlanWidthPx,
      if (floorPlanHeightPx != null) 'floor_plan_height_px': floorPlanHeightPx,
      if (mmPerPixel != null) 'mm_per_pixel': mmPerPixel,
      if (calibrationJson != null) 'calibration_json': calibrationJson,
      if (roomWidthMm != null) 'room_width_mm': roomWidthMm,
      if (roomDepthMm != null) 'room_depth_mm': roomDepthMm,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HomesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? floorPlanPath,
    Value<int?>? floorPlanWidthPx,
    Value<int?>? floorPlanHeightPx,
    Value<double?>? mmPerPixel,
    Value<String?>? calibrationJson,
    Value<int?>? roomWidthMm,
    Value<int?>? roomDepthMm,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HomesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      floorPlanPath: floorPlanPath ?? this.floorPlanPath,
      floorPlanWidthPx: floorPlanWidthPx ?? this.floorPlanWidthPx,
      floorPlanHeightPx: floorPlanHeightPx ?? this.floorPlanHeightPx,
      mmPerPixel: mmPerPixel ?? this.mmPerPixel,
      calibrationJson: calibrationJson ?? this.calibrationJson,
      roomWidthMm: roomWidthMm ?? this.roomWidthMm,
      roomDepthMm: roomDepthMm ?? this.roomDepthMm,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (floorPlanPath.present) {
      map['floor_plan_path'] = Variable<String>(floorPlanPath.value);
    }
    if (floorPlanWidthPx.present) {
      map['floor_plan_width_px'] = Variable<int>(floorPlanWidthPx.value);
    }
    if (floorPlanHeightPx.present) {
      map['floor_plan_height_px'] = Variable<int>(floorPlanHeightPx.value);
    }
    if (mmPerPixel.present) {
      map['mm_per_pixel'] = Variable<double>(mmPerPixel.value);
    }
    if (calibrationJson.present) {
      map['calibration_json'] = Variable<String>(calibrationJson.value);
    }
    if (roomWidthMm.present) {
      map['room_width_mm'] = Variable<int>(roomWidthMm.value);
    }
    if (roomDepthMm.present) {
      map['room_depth_mm'] = Variable<int>(roomDepthMm.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HomesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('floorPlanPath: $floorPlanPath, ')
          ..write('floorPlanWidthPx: $floorPlanWidthPx, ')
          ..write('floorPlanHeightPx: $floorPlanHeightPx, ')
          ..write('mmPerPixel: $mmPerPixel, ')
          ..write('calibrationJson: $calibrationJson, ')
          ..write('roomWidthMm: $roomWidthMm, ')
          ..write('roomDepthMm: $roomDepthMm, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LayoutsTable extends Layouts with TableInfo<$LayoutsTable, Layout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LayoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _homeIdMeta = const VerificationMeta('homeId');
  @override
  late final GeneratedColumn<String> homeId = GeneratedColumn<String>(
    'home_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES homes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    homeId,
    name,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'layouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Layout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('home_id')) {
      context.handle(
        _homeIdMeta,
        homeId.isAcceptableOrUnknown(data['home_id']!, _homeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_homeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Layout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Layout(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      homeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LayoutsTable createAlias(String alias) {
    return $LayoutsTable(attachedDatabase, alias);
  }
}

class Layout extends DataClass implements Insertable<Layout> {
  final String id;
  final String homeId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Layout({
    required this.id,
    required this.homeId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['home_id'] = Variable<String>(homeId);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LayoutsCompanion toCompanion(bool nullToAbsent) {
    return LayoutsCompanion(
      id: Value(id),
      homeId: Value(homeId),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Layout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Layout(
      id: serializer.fromJson<String>(json['id']),
      homeId: serializer.fromJson<String>(json['homeId']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'homeId': serializer.toJson<String>(homeId),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Layout copyWith({
    String? id,
    String? homeId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Layout(
    id: id ?? this.id,
    homeId: homeId ?? this.homeId,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Layout copyWithCompanion(LayoutsCompanion data) {
    return Layout(
      id: data.id.present ? data.id.value : this.id,
      homeId: data.homeId.present ? data.homeId.value : this.homeId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Layout(')
          ..write('id: $id, ')
          ..write('homeId: $homeId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, homeId, name, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Layout &&
          other.id == this.id &&
          other.homeId == this.homeId &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LayoutsCompanion extends UpdateCompanion<Layout> {
  final Value<String> id;
  final Value<String> homeId;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LayoutsCompanion({
    this.id = const Value.absent(),
    this.homeId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LayoutsCompanion.insert({
    required String id,
    required String homeId,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       homeId = Value(homeId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Layout> custom({
    Expression<String>? id,
    Expression<String>? homeId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (homeId != null) 'home_id': homeId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LayoutsCompanion copyWith({
    Value<String>? id,
    Value<String>? homeId,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LayoutsCompanion(
      id: id ?? this.id,
      homeId: homeId ?? this.homeId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (homeId.present) {
      map['home_id'] = Variable<String>(homeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LayoutsCompanion(')
          ..write('id: $id, ')
          ..write('homeId: $homeId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LayoutItemsTable extends LayoutItems
    with TableInfo<$LayoutItemsTable, LayoutItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LayoutItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _layoutIdMeta = const VerificationMeta(
    'layoutId',
  );
  @override
  late final GeneratedColumn<String> layoutId = GeneratedColumn<String>(
    'layout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES layouts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _furnitureIdMeta = const VerificationMeta(
    'furnitureId',
  );
  @override
  late final GeneratedColumn<String> furnitureId = GeneratedColumn<String>(
    'furniture_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMmMeta = const VerificationMeta(
    'widthMm',
  );
  @override
  late final GeneratedColumn<int> widthMm = GeneratedColumn<int>(
    'width_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depthMmMeta = const VerificationMeta(
    'depthMm',
  );
  @override
  late final GeneratedColumn<int> depthMm = GeneratedColumn<int>(
    'depth_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMmMeta = const VerificationMeta(
    'heightMm',
  );
  @override
  late final GeneratedColumn<int> heightMm = GeneratedColumn<int>(
    'height_mm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _xMmMeta = const VerificationMeta('xMm');
  @override
  late final GeneratedColumn<double> xMm = GeneratedColumn<double>(
    'x_mm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMmMeta = const VerificationMeta('yMm');
  @override
  late final GeneratedColumn<double> yMm = GeneratedColumn<double>(
    'y_mm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotationDegMeta = const VerificationMeta(
    'rotationDeg',
  );
  @override
  late final GeneratedColumn<double> rotationDeg = GeneratedColumn<double>(
    'rotation_deg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doorTypeMeta = const VerificationMeta(
    'doorType',
  );
  @override
  late final GeneratedColumn<String> doorType = GeneratedColumn<String>(
    'door_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doorSwingMmMeta = const VerificationMeta(
    'doorSwingMm',
  );
  @override
  late final GeneratedColumn<int> doorSwingMm = GeneratedColumn<int>(
    'door_swing_mm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zIndexMeta = const VerificationMeta('zIndex');
  @override
  late final GeneratedColumn<int> zIndex = GeneratedColumn<int>(
    'z_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    layoutId,
    furnitureId,
    name,
    widthMm,
    depthMm,
    heightMm,
    xMm,
    yMm,
    rotationDeg,
    colorValue,
    doorType,
    doorSwingMm,
    zIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'layout_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LayoutItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('layout_id')) {
      context.handle(
        _layoutIdMeta,
        layoutId.isAcceptableOrUnknown(data['layout_id']!, _layoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_layoutIdMeta);
    }
    if (data.containsKey('furniture_id')) {
      context.handle(
        _furnitureIdMeta,
        furnitureId.isAcceptableOrUnknown(
          data['furniture_id']!,
          _furnitureIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('width_mm')) {
      context.handle(
        _widthMmMeta,
        widthMm.isAcceptableOrUnknown(data['width_mm']!, _widthMmMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMmMeta);
    }
    if (data.containsKey('depth_mm')) {
      context.handle(
        _depthMmMeta,
        depthMm.isAcceptableOrUnknown(data['depth_mm']!, _depthMmMeta),
      );
    } else if (isInserting) {
      context.missing(_depthMmMeta);
    }
    if (data.containsKey('height_mm')) {
      context.handle(
        _heightMmMeta,
        heightMm.isAcceptableOrUnknown(data['height_mm']!, _heightMmMeta),
      );
    }
    if (data.containsKey('x_mm')) {
      context.handle(
        _xMmMeta,
        xMm.isAcceptableOrUnknown(data['x_mm']!, _xMmMeta),
      );
    } else if (isInserting) {
      context.missing(_xMmMeta);
    }
    if (data.containsKey('y_mm')) {
      context.handle(
        _yMmMeta,
        yMm.isAcceptableOrUnknown(data['y_mm']!, _yMmMeta),
      );
    } else if (isInserting) {
      context.missing(_yMmMeta);
    }
    if (data.containsKey('rotation_deg')) {
      context.handle(
        _rotationDegMeta,
        rotationDeg.isAcceptableOrUnknown(
          data['rotation_deg']!,
          _rotationDegMeta,
        ),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('door_type')) {
      context.handle(
        _doorTypeMeta,
        doorType.isAcceptableOrUnknown(data['door_type']!, _doorTypeMeta),
      );
    }
    if (data.containsKey('door_swing_mm')) {
      context.handle(
        _doorSwingMmMeta,
        doorSwingMm.isAcceptableOrUnknown(
          data['door_swing_mm']!,
          _doorSwingMmMeta,
        ),
      );
    }
    if (data.containsKey('z_index')) {
      context.handle(
        _zIndexMeta,
        zIndex.isAcceptableOrUnknown(data['z_index']!, _zIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LayoutItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LayoutItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      layoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout_id'],
      )!,
      furnitureId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}furniture_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      widthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width_mm'],
      )!,
      depthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}depth_mm'],
      )!,
      heightMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_mm'],
      ),
      xMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}x_mm'],
      )!,
      yMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}y_mm'],
      )!,
      rotationDeg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rotation_deg'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      doorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}door_type'],
      ),
      doorSwingMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}door_swing_mm'],
      ),
      zIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}z_index'],
      )!,
    );
  }

  @override
  $LayoutItemsTable createAlias(String alias) {
    return $LayoutItemsTable(attachedDatabase, alias);
  }
}

class LayoutItem extends DataClass implements Insertable<LayoutItem> {
  final String id;
  final String layoutId;

  /// 라이브러리 프리셋 ID 또는 내 가구 ID (직접 입력 1회성이면 null).
  final String? furnitureId;
  final String name;
  final int widthMm;
  final int depthMm;
  final int? heightMm;

  /// 가구 중심점 좌표 (mm).
  final double xMm;
  final double yMm;
  final double rotationDeg;
  final int colorValue;

  /// 문 종류: null | 'single' | 'double' | 'drawer'
  final String? doorType;
  final int? doorSwingMm;
  final int zIndex;
  const LayoutItem({
    required this.id,
    required this.layoutId,
    this.furnitureId,
    required this.name,
    required this.widthMm,
    required this.depthMm,
    this.heightMm,
    required this.xMm,
    required this.yMm,
    required this.rotationDeg,
    required this.colorValue,
    this.doorType,
    this.doorSwingMm,
    required this.zIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['layout_id'] = Variable<String>(layoutId);
    if (!nullToAbsent || furnitureId != null) {
      map['furniture_id'] = Variable<String>(furnitureId);
    }
    map['name'] = Variable<String>(name);
    map['width_mm'] = Variable<int>(widthMm);
    map['depth_mm'] = Variable<int>(depthMm);
    if (!nullToAbsent || heightMm != null) {
      map['height_mm'] = Variable<int>(heightMm);
    }
    map['x_mm'] = Variable<double>(xMm);
    map['y_mm'] = Variable<double>(yMm);
    map['rotation_deg'] = Variable<double>(rotationDeg);
    map['color_value'] = Variable<int>(colorValue);
    if (!nullToAbsent || doorType != null) {
      map['door_type'] = Variable<String>(doorType);
    }
    if (!nullToAbsent || doorSwingMm != null) {
      map['door_swing_mm'] = Variable<int>(doorSwingMm);
    }
    map['z_index'] = Variable<int>(zIndex);
    return map;
  }

  LayoutItemsCompanion toCompanion(bool nullToAbsent) {
    return LayoutItemsCompanion(
      id: Value(id),
      layoutId: Value(layoutId),
      furnitureId: furnitureId == null && nullToAbsent
          ? const Value.absent()
          : Value(furnitureId),
      name: Value(name),
      widthMm: Value(widthMm),
      depthMm: Value(depthMm),
      heightMm: heightMm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightMm),
      xMm: Value(xMm),
      yMm: Value(yMm),
      rotationDeg: Value(rotationDeg),
      colorValue: Value(colorValue),
      doorType: doorType == null && nullToAbsent
          ? const Value.absent()
          : Value(doorType),
      doorSwingMm: doorSwingMm == null && nullToAbsent
          ? const Value.absent()
          : Value(doorSwingMm),
      zIndex: Value(zIndex),
    );
  }

  factory LayoutItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LayoutItem(
      id: serializer.fromJson<String>(json['id']),
      layoutId: serializer.fromJson<String>(json['layoutId']),
      furnitureId: serializer.fromJson<String?>(json['furnitureId']),
      name: serializer.fromJson<String>(json['name']),
      widthMm: serializer.fromJson<int>(json['widthMm']),
      depthMm: serializer.fromJson<int>(json['depthMm']),
      heightMm: serializer.fromJson<int?>(json['heightMm']),
      xMm: serializer.fromJson<double>(json['xMm']),
      yMm: serializer.fromJson<double>(json['yMm']),
      rotationDeg: serializer.fromJson<double>(json['rotationDeg']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      doorType: serializer.fromJson<String?>(json['doorType']),
      doorSwingMm: serializer.fromJson<int?>(json['doorSwingMm']),
      zIndex: serializer.fromJson<int>(json['zIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'layoutId': serializer.toJson<String>(layoutId),
      'furnitureId': serializer.toJson<String?>(furnitureId),
      'name': serializer.toJson<String>(name),
      'widthMm': serializer.toJson<int>(widthMm),
      'depthMm': serializer.toJson<int>(depthMm),
      'heightMm': serializer.toJson<int?>(heightMm),
      'xMm': serializer.toJson<double>(xMm),
      'yMm': serializer.toJson<double>(yMm),
      'rotationDeg': serializer.toJson<double>(rotationDeg),
      'colorValue': serializer.toJson<int>(colorValue),
      'doorType': serializer.toJson<String?>(doorType),
      'doorSwingMm': serializer.toJson<int?>(doorSwingMm),
      'zIndex': serializer.toJson<int>(zIndex),
    };
  }

  LayoutItem copyWith({
    String? id,
    String? layoutId,
    Value<String?> furnitureId = const Value.absent(),
    String? name,
    int? widthMm,
    int? depthMm,
    Value<int?> heightMm = const Value.absent(),
    double? xMm,
    double? yMm,
    double? rotationDeg,
    int? colorValue,
    Value<String?> doorType = const Value.absent(),
    Value<int?> doorSwingMm = const Value.absent(),
    int? zIndex,
  }) => LayoutItem(
    id: id ?? this.id,
    layoutId: layoutId ?? this.layoutId,
    furnitureId: furnitureId.present ? furnitureId.value : this.furnitureId,
    name: name ?? this.name,
    widthMm: widthMm ?? this.widthMm,
    depthMm: depthMm ?? this.depthMm,
    heightMm: heightMm.present ? heightMm.value : this.heightMm,
    xMm: xMm ?? this.xMm,
    yMm: yMm ?? this.yMm,
    rotationDeg: rotationDeg ?? this.rotationDeg,
    colorValue: colorValue ?? this.colorValue,
    doorType: doorType.present ? doorType.value : this.doorType,
    doorSwingMm: doorSwingMm.present ? doorSwingMm.value : this.doorSwingMm,
    zIndex: zIndex ?? this.zIndex,
  );
  LayoutItem copyWithCompanion(LayoutItemsCompanion data) {
    return LayoutItem(
      id: data.id.present ? data.id.value : this.id,
      layoutId: data.layoutId.present ? data.layoutId.value : this.layoutId,
      furnitureId: data.furnitureId.present
          ? data.furnitureId.value
          : this.furnitureId,
      name: data.name.present ? data.name.value : this.name,
      widthMm: data.widthMm.present ? data.widthMm.value : this.widthMm,
      depthMm: data.depthMm.present ? data.depthMm.value : this.depthMm,
      heightMm: data.heightMm.present ? data.heightMm.value : this.heightMm,
      xMm: data.xMm.present ? data.xMm.value : this.xMm,
      yMm: data.yMm.present ? data.yMm.value : this.yMm,
      rotationDeg: data.rotationDeg.present
          ? data.rotationDeg.value
          : this.rotationDeg,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      doorType: data.doorType.present ? data.doorType.value : this.doorType,
      doorSwingMm: data.doorSwingMm.present
          ? data.doorSwingMm.value
          : this.doorSwingMm,
      zIndex: data.zIndex.present ? data.zIndex.value : this.zIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LayoutItem(')
          ..write('id: $id, ')
          ..write('layoutId: $layoutId, ')
          ..write('furnitureId: $furnitureId, ')
          ..write('name: $name, ')
          ..write('widthMm: $widthMm, ')
          ..write('depthMm: $depthMm, ')
          ..write('heightMm: $heightMm, ')
          ..write('xMm: $xMm, ')
          ..write('yMm: $yMm, ')
          ..write('rotationDeg: $rotationDeg, ')
          ..write('colorValue: $colorValue, ')
          ..write('doorType: $doorType, ')
          ..write('doorSwingMm: $doorSwingMm, ')
          ..write('zIndex: $zIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    layoutId,
    furnitureId,
    name,
    widthMm,
    depthMm,
    heightMm,
    xMm,
    yMm,
    rotationDeg,
    colorValue,
    doorType,
    doorSwingMm,
    zIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LayoutItem &&
          other.id == this.id &&
          other.layoutId == this.layoutId &&
          other.furnitureId == this.furnitureId &&
          other.name == this.name &&
          other.widthMm == this.widthMm &&
          other.depthMm == this.depthMm &&
          other.heightMm == this.heightMm &&
          other.xMm == this.xMm &&
          other.yMm == this.yMm &&
          other.rotationDeg == this.rotationDeg &&
          other.colorValue == this.colorValue &&
          other.doorType == this.doorType &&
          other.doorSwingMm == this.doorSwingMm &&
          other.zIndex == this.zIndex);
}

class LayoutItemsCompanion extends UpdateCompanion<LayoutItem> {
  final Value<String> id;
  final Value<String> layoutId;
  final Value<String?> furnitureId;
  final Value<String> name;
  final Value<int> widthMm;
  final Value<int> depthMm;
  final Value<int?> heightMm;
  final Value<double> xMm;
  final Value<double> yMm;
  final Value<double> rotationDeg;
  final Value<int> colorValue;
  final Value<String?> doorType;
  final Value<int?> doorSwingMm;
  final Value<int> zIndex;
  final Value<int> rowid;
  const LayoutItemsCompanion({
    this.id = const Value.absent(),
    this.layoutId = const Value.absent(),
    this.furnitureId = const Value.absent(),
    this.name = const Value.absent(),
    this.widthMm = const Value.absent(),
    this.depthMm = const Value.absent(),
    this.heightMm = const Value.absent(),
    this.xMm = const Value.absent(),
    this.yMm = const Value.absent(),
    this.rotationDeg = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.doorType = const Value.absent(),
    this.doorSwingMm = const Value.absent(),
    this.zIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LayoutItemsCompanion.insert({
    required String id,
    required String layoutId,
    this.furnitureId = const Value.absent(),
    required String name,
    required int widthMm,
    required int depthMm,
    this.heightMm = const Value.absent(),
    required double xMm,
    required double yMm,
    this.rotationDeg = const Value.absent(),
    required int colorValue,
    this.doorType = const Value.absent(),
    this.doorSwingMm = const Value.absent(),
    this.zIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       layoutId = Value(layoutId),
       name = Value(name),
       widthMm = Value(widthMm),
       depthMm = Value(depthMm),
       xMm = Value(xMm),
       yMm = Value(yMm),
       colorValue = Value(colorValue);
  static Insertable<LayoutItem> custom({
    Expression<String>? id,
    Expression<String>? layoutId,
    Expression<String>? furnitureId,
    Expression<String>? name,
    Expression<int>? widthMm,
    Expression<int>? depthMm,
    Expression<int>? heightMm,
    Expression<double>? xMm,
    Expression<double>? yMm,
    Expression<double>? rotationDeg,
    Expression<int>? colorValue,
    Expression<String>? doorType,
    Expression<int>? doorSwingMm,
    Expression<int>? zIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (layoutId != null) 'layout_id': layoutId,
      if (furnitureId != null) 'furniture_id': furnitureId,
      if (name != null) 'name': name,
      if (widthMm != null) 'width_mm': widthMm,
      if (depthMm != null) 'depth_mm': depthMm,
      if (heightMm != null) 'height_mm': heightMm,
      if (xMm != null) 'x_mm': xMm,
      if (yMm != null) 'y_mm': yMm,
      if (rotationDeg != null) 'rotation_deg': rotationDeg,
      if (colorValue != null) 'color_value': colorValue,
      if (doorType != null) 'door_type': doorType,
      if (doorSwingMm != null) 'door_swing_mm': doorSwingMm,
      if (zIndex != null) 'z_index': zIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LayoutItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? layoutId,
    Value<String?>? furnitureId,
    Value<String>? name,
    Value<int>? widthMm,
    Value<int>? depthMm,
    Value<int?>? heightMm,
    Value<double>? xMm,
    Value<double>? yMm,
    Value<double>? rotationDeg,
    Value<int>? colorValue,
    Value<String?>? doorType,
    Value<int?>? doorSwingMm,
    Value<int>? zIndex,
    Value<int>? rowid,
  }) {
    return LayoutItemsCompanion(
      id: id ?? this.id,
      layoutId: layoutId ?? this.layoutId,
      furnitureId: furnitureId ?? this.furnitureId,
      name: name ?? this.name,
      widthMm: widthMm ?? this.widthMm,
      depthMm: depthMm ?? this.depthMm,
      heightMm: heightMm ?? this.heightMm,
      xMm: xMm ?? this.xMm,
      yMm: yMm ?? this.yMm,
      rotationDeg: rotationDeg ?? this.rotationDeg,
      colorValue: colorValue ?? this.colorValue,
      doorType: doorType ?? this.doorType,
      doorSwingMm: doorSwingMm ?? this.doorSwingMm,
      zIndex: zIndex ?? this.zIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (layoutId.present) {
      map['layout_id'] = Variable<String>(layoutId.value);
    }
    if (furnitureId.present) {
      map['furniture_id'] = Variable<String>(furnitureId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (widthMm.present) {
      map['width_mm'] = Variable<int>(widthMm.value);
    }
    if (depthMm.present) {
      map['depth_mm'] = Variable<int>(depthMm.value);
    }
    if (heightMm.present) {
      map['height_mm'] = Variable<int>(heightMm.value);
    }
    if (xMm.present) {
      map['x_mm'] = Variable<double>(xMm.value);
    }
    if (yMm.present) {
      map['y_mm'] = Variable<double>(yMm.value);
    }
    if (rotationDeg.present) {
      map['rotation_deg'] = Variable<double>(rotationDeg.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (doorType.present) {
      map['door_type'] = Variable<String>(doorType.value);
    }
    if (doorSwingMm.present) {
      map['door_swing_mm'] = Variable<int>(doorSwingMm.value);
    }
    if (zIndex.present) {
      map['z_index'] = Variable<int>(zIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LayoutItemsCompanion(')
          ..write('id: $id, ')
          ..write('layoutId: $layoutId, ')
          ..write('furnitureId: $furnitureId, ')
          ..write('name: $name, ')
          ..write('widthMm: $widthMm, ')
          ..write('depthMm: $depthMm, ')
          ..write('heightMm: $heightMm, ')
          ..write('xMm: $xMm, ')
          ..write('yMm: $yMm, ')
          ..write('rotationDeg: $rotationDeg, ')
          ..write('colorValue: $colorValue, ')
          ..write('doorType: $doorType, ')
          ..write('doorSwingMm: $doorSwingMm, ')
          ..write('zIndex: $zIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomFurnituresTable extends CustomFurnitures
    with TableInfo<$CustomFurnituresTable, CustomFurniture> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomFurnituresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMmMeta = const VerificationMeta(
    'widthMm',
  );
  @override
  late final GeneratedColumn<int> widthMm = GeneratedColumn<int>(
    'width_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depthMmMeta = const VerificationMeta(
    'depthMm',
  );
  @override
  late final GeneratedColumn<int> depthMm = GeneratedColumn<int>(
    'depth_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMmMeta = const VerificationMeta(
    'heightMm',
  );
  @override
  late final GeneratedColumn<int> heightMm = GeneratedColumn<int>(
    'height_mm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doorTypeMeta = const VerificationMeta(
    'doorType',
  );
  @override
  late final GeneratedColumn<String> doorType = GeneratedColumn<String>(
    'door_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doorSwingMmMeta = const VerificationMeta(
    'doorSwingMm',
  );
  @override
  late final GeneratedColumn<int> doorSwingMm = GeneratedColumn<int>(
    'door_swing_mm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    widthMm,
    depthMm,
    heightMm,
    colorValue,
    doorType,
    doorSwingMm,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_furnitures';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomFurniture> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('width_mm')) {
      context.handle(
        _widthMmMeta,
        widthMm.isAcceptableOrUnknown(data['width_mm']!, _widthMmMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMmMeta);
    }
    if (data.containsKey('depth_mm')) {
      context.handle(
        _depthMmMeta,
        depthMm.isAcceptableOrUnknown(data['depth_mm']!, _depthMmMeta),
      );
    } else if (isInserting) {
      context.missing(_depthMmMeta);
    }
    if (data.containsKey('height_mm')) {
      context.handle(
        _heightMmMeta,
        heightMm.isAcceptableOrUnknown(data['height_mm']!, _heightMmMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('door_type')) {
      context.handle(
        _doorTypeMeta,
        doorType.isAcceptableOrUnknown(data['door_type']!, _doorTypeMeta),
      );
    }
    if (data.containsKey('door_swing_mm')) {
      context.handle(
        _doorSwingMmMeta,
        doorSwingMm.isAcceptableOrUnknown(
          data['door_swing_mm']!,
          _doorSwingMmMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomFurniture map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomFurniture(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      widthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width_mm'],
      )!,
      depthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}depth_mm'],
      )!,
      heightMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_mm'],
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      doorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}door_type'],
      ),
      doorSwingMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}door_swing_mm'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomFurnituresTable createAlias(String alias) {
    return $CustomFurnituresTable(attachedDatabase, alias);
  }
}

class CustomFurniture extends DataClass implements Insertable<CustomFurniture> {
  final String id;
  final String name;
  final String category;
  final int widthMm;
  final int depthMm;
  final int? heightMm;
  final int colorValue;
  final String? doorType;
  final int? doorSwingMm;
  final DateTime createdAt;
  const CustomFurniture({
    required this.id,
    required this.name,
    required this.category,
    required this.widthMm,
    required this.depthMm,
    this.heightMm,
    required this.colorValue,
    this.doorType,
    this.doorSwingMm,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['width_mm'] = Variable<int>(widthMm);
    map['depth_mm'] = Variable<int>(depthMm);
    if (!nullToAbsent || heightMm != null) {
      map['height_mm'] = Variable<int>(heightMm);
    }
    map['color_value'] = Variable<int>(colorValue);
    if (!nullToAbsent || doorType != null) {
      map['door_type'] = Variable<String>(doorType);
    }
    if (!nullToAbsent || doorSwingMm != null) {
      map['door_swing_mm'] = Variable<int>(doorSwingMm);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomFurnituresCompanion toCompanion(bool nullToAbsent) {
    return CustomFurnituresCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      widthMm: Value(widthMm),
      depthMm: Value(depthMm),
      heightMm: heightMm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightMm),
      colorValue: Value(colorValue),
      doorType: doorType == null && nullToAbsent
          ? const Value.absent()
          : Value(doorType),
      doorSwingMm: doorSwingMm == null && nullToAbsent
          ? const Value.absent()
          : Value(doorSwingMm),
      createdAt: Value(createdAt),
    );
  }

  factory CustomFurniture.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomFurniture(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      widthMm: serializer.fromJson<int>(json['widthMm']),
      depthMm: serializer.fromJson<int>(json['depthMm']),
      heightMm: serializer.fromJson<int?>(json['heightMm']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      doorType: serializer.fromJson<String?>(json['doorType']),
      doorSwingMm: serializer.fromJson<int?>(json['doorSwingMm']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'widthMm': serializer.toJson<int>(widthMm),
      'depthMm': serializer.toJson<int>(depthMm),
      'heightMm': serializer.toJson<int?>(heightMm),
      'colorValue': serializer.toJson<int>(colorValue),
      'doorType': serializer.toJson<String?>(doorType),
      'doorSwingMm': serializer.toJson<int?>(doorSwingMm),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomFurniture copyWith({
    String? id,
    String? name,
    String? category,
    int? widthMm,
    int? depthMm,
    Value<int?> heightMm = const Value.absent(),
    int? colorValue,
    Value<String?> doorType = const Value.absent(),
    Value<int?> doorSwingMm = const Value.absent(),
    DateTime? createdAt,
  }) => CustomFurniture(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    widthMm: widthMm ?? this.widthMm,
    depthMm: depthMm ?? this.depthMm,
    heightMm: heightMm.present ? heightMm.value : this.heightMm,
    colorValue: colorValue ?? this.colorValue,
    doorType: doorType.present ? doorType.value : this.doorType,
    doorSwingMm: doorSwingMm.present ? doorSwingMm.value : this.doorSwingMm,
    createdAt: createdAt ?? this.createdAt,
  );
  CustomFurniture copyWithCompanion(CustomFurnituresCompanion data) {
    return CustomFurniture(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      widthMm: data.widthMm.present ? data.widthMm.value : this.widthMm,
      depthMm: data.depthMm.present ? data.depthMm.value : this.depthMm,
      heightMm: data.heightMm.present ? data.heightMm.value : this.heightMm,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      doorType: data.doorType.present ? data.doorType.value : this.doorType,
      doorSwingMm: data.doorSwingMm.present
          ? data.doorSwingMm.value
          : this.doorSwingMm,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomFurniture(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('widthMm: $widthMm, ')
          ..write('depthMm: $depthMm, ')
          ..write('heightMm: $heightMm, ')
          ..write('colorValue: $colorValue, ')
          ..write('doorType: $doorType, ')
          ..write('doorSwingMm: $doorSwingMm, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    widthMm,
    depthMm,
    heightMm,
    colorValue,
    doorType,
    doorSwingMm,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomFurniture &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.widthMm == this.widthMm &&
          other.depthMm == this.depthMm &&
          other.heightMm == this.heightMm &&
          other.colorValue == this.colorValue &&
          other.doorType == this.doorType &&
          other.doorSwingMm == this.doorSwingMm &&
          other.createdAt == this.createdAt);
}

class CustomFurnituresCompanion extends UpdateCompanion<CustomFurniture> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> widthMm;
  final Value<int> depthMm;
  final Value<int?> heightMm;
  final Value<int> colorValue;
  final Value<String?> doorType;
  final Value<int?> doorSwingMm;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CustomFurnituresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.widthMm = const Value.absent(),
    this.depthMm = const Value.absent(),
    this.heightMm = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.doorType = const Value.absent(),
    this.doorSwingMm = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomFurnituresCompanion.insert({
    required String id,
    required String name,
    required String category,
    required int widthMm,
    required int depthMm,
    this.heightMm = const Value.absent(),
    required int colorValue,
    this.doorType = const Value.absent(),
    this.doorSwingMm = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       widthMm = Value(widthMm),
       depthMm = Value(depthMm),
       colorValue = Value(colorValue),
       createdAt = Value(createdAt);
  static Insertable<CustomFurniture> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? widthMm,
    Expression<int>? depthMm,
    Expression<int>? heightMm,
    Expression<int>? colorValue,
    Expression<String>? doorType,
    Expression<int>? doorSwingMm,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (widthMm != null) 'width_mm': widthMm,
      if (depthMm != null) 'depth_mm': depthMm,
      if (heightMm != null) 'height_mm': heightMm,
      if (colorValue != null) 'color_value': colorValue,
      if (doorType != null) 'door_type': doorType,
      if (doorSwingMm != null) 'door_swing_mm': doorSwingMm,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomFurnituresCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<int>? widthMm,
    Value<int>? depthMm,
    Value<int?>? heightMm,
    Value<int>? colorValue,
    Value<String?>? doorType,
    Value<int?>? doorSwingMm,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CustomFurnituresCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      widthMm: widthMm ?? this.widthMm,
      depthMm: depthMm ?? this.depthMm,
      heightMm: heightMm ?? this.heightMm,
      colorValue: colorValue ?? this.colorValue,
      doorType: doorType ?? this.doorType,
      doorSwingMm: doorSwingMm ?? this.doorSwingMm,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (widthMm.present) {
      map['width_mm'] = Variable<int>(widthMm.value);
    }
    if (depthMm.present) {
      map['depth_mm'] = Variable<int>(depthMm.value);
    }
    if (heightMm.present) {
      map['height_mm'] = Variable<int>(heightMm.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (doorType.present) {
      map['door_type'] = Variable<String>(doorType.value);
    }
    if (doorSwingMm.present) {
      map['door_swing_mm'] = Variable<int>(doorSwingMm.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomFurnituresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('widthMm: $widthMm, ')
          ..write('depthMm: $depthMm, ')
          ..write('heightMm: $heightMm, ')
          ..write('colorValue: $colorValue, ')
          ..write('doorType: $doorType, ')
          ..write('doorSwingMm: $doorSwingMm, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HomesTable homes = $HomesTable(this);
  late final $LayoutsTable layouts = $LayoutsTable(this);
  late final $LayoutItemsTable layoutItems = $LayoutItemsTable(this);
  late final $CustomFurnituresTable customFurnitures = $CustomFurnituresTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    homes,
    layouts,
    layoutItems,
    customFurnitures,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'homes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('layouts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'layouts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('layout_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$HomesTableCreateCompanionBuilder = HomesCompanion Function({
  required String id,
  required String name,
  Value<String?> floorPlanPath,
  Value<int?> floorPlanWidthPx,
  Value<int?> floorPlanHeightPx,
  Value<double?> mmPerPixel,
  Value<String?> calibrationJson,
  Value<int?> roomWidthMm,
  Value<int?> roomDepthMm,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$HomesTableUpdateCompanionBuilder = HomesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> floorPlanPath,
  Value<int?> floorPlanWidthPx,
  Value<int?> floorPlanHeightPx,
  Value<double?> mmPerPixel,
  Value<String?> calibrationJson,
  Value<int?> roomWidthMm,
  Value<int?> roomDepthMm,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$HomesTableReferences
    extends BaseReferences<_$AppDatabase, $HomesTable, Home> {
  $$HomesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LayoutsTable, List<Layout>> _layoutsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.layouts,
    aliasName: 'homes__id__layouts__home_id',
  );

  $$LayoutsTableProcessedTableManager get layoutsRefs {
    final manager = $$LayoutsTableTableManager(
      $_db,
      $_db.layouts,
    ).filter((f) => f.homeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_layoutsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HomesTableFilterComposer extends Composer<_$AppDatabase, $HomesTable> {
  $$HomesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get floorPlanPath => $composableBuilder(
    column: $table.floorPlanPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get floorPlanWidthPx => $composableBuilder(
    column: $table.floorPlanWidthPx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get floorPlanHeightPx => $composableBuilder(
    column: $table.floorPlanHeightPx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mmPerPixel => $composableBuilder(
    column: $table.mmPerPixel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calibrationJson => $composableBuilder(
    column: $table.calibrationJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roomWidthMm => $composableBuilder(
    column: $table.roomWidthMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roomDepthMm => $composableBuilder(
    column: $table.roomDepthMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> layoutsRefs(
    Expression<bool> Function($$LayoutsTableFilterComposer f) f,
  ) {
    final $$LayoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layouts,
      getReferencedColumn: (t) => t.homeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutsTableFilterComposer(
            $db: $db,
            $table: $db.layouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HomesTableOrderingComposer
    extends Composer<_$AppDatabase, $HomesTable> {
  $$HomesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get floorPlanPath => $composableBuilder(
    column: $table.floorPlanPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get floorPlanWidthPx => $composableBuilder(
    column: $table.floorPlanWidthPx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get floorPlanHeightPx => $composableBuilder(
    column: $table.floorPlanHeightPx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mmPerPixel => $composableBuilder(
    column: $table.mmPerPixel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calibrationJson => $composableBuilder(
    column: $table.calibrationJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roomWidthMm => $composableBuilder(
    column: $table.roomWidthMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roomDepthMm => $composableBuilder(
    column: $table.roomDepthMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HomesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HomesTable> {
  $$HomesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get floorPlanPath => $composableBuilder(
    column: $table.floorPlanPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get floorPlanWidthPx => $composableBuilder(
    column: $table.floorPlanWidthPx,
    builder: (column) => column,
  );

  GeneratedColumn<int> get floorPlanHeightPx => $composableBuilder(
    column: $table.floorPlanHeightPx,
    builder: (column) => column,
  );

  GeneratedColumn<double> get mmPerPixel => $composableBuilder(
    column: $table.mmPerPixel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calibrationJson => $composableBuilder(
    column: $table.calibrationJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get roomWidthMm => $composableBuilder(
    column: $table.roomWidthMm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get roomDepthMm => $composableBuilder(
    column: $table.roomDepthMm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> layoutsRefs<T extends Object>(
    Expression<T> Function($$LayoutsTableAnnotationComposer a) f,
  ) {
    final $$LayoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layouts,
      getReferencedColumn: (t) => t.homeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.layouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HomesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HomesTable,
          Home,
          $$HomesTableFilterComposer,
          $$HomesTableOrderingComposer,
          $$HomesTableAnnotationComposer,
          $$HomesTableCreateCompanionBuilder,
          $$HomesTableUpdateCompanionBuilder,
          (Home, $$HomesTableReferences),
          Home,
          PrefetchHooks Function({bool layoutsRefs})
        > {
  $$HomesTableTableManager(_$AppDatabase db, $HomesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HomesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HomesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HomesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> floorPlanPath = const Value.absent(),
                Value<int?> floorPlanWidthPx = const Value.absent(),
                Value<int?> floorPlanHeightPx = const Value.absent(),
                Value<double?> mmPerPixel = const Value.absent(),
                Value<String?> calibrationJson = const Value.absent(),
                Value<int?> roomWidthMm = const Value.absent(),
                Value<int?> roomDepthMm = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HomesCompanion(
                id: id,
                name: name,
                floorPlanPath: floorPlanPath,
                floorPlanWidthPx: floorPlanWidthPx,
                floorPlanHeightPx: floorPlanHeightPx,
                mmPerPixel: mmPerPixel,
                calibrationJson: calibrationJson,
                roomWidthMm: roomWidthMm,
                roomDepthMm: roomDepthMm,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> floorPlanPath = const Value.absent(),
                Value<int?> floorPlanWidthPx = const Value.absent(),
                Value<int?> floorPlanHeightPx = const Value.absent(),
                Value<double?> mmPerPixel = const Value.absent(),
                Value<String?> calibrationJson = const Value.absent(),
                Value<int?> roomWidthMm = const Value.absent(),
                Value<int?> roomDepthMm = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HomesCompanion.insert(
                id: id,
                name: name,
                floorPlanPath: floorPlanPath,
                floorPlanWidthPx: floorPlanWidthPx,
                floorPlanHeightPx: floorPlanHeightPx,
                mmPerPixel: mmPerPixel,
                calibrationJson: calibrationJson,
                roomWidthMm: roomWidthMm,
                roomDepthMm: roomDepthMm,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HomesTable, Home>(table),
                  $$HomesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({layoutsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (layoutsRefs) db.layouts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (layoutsRefs)
                    await $_getPrefetchedDataByColumns<
                      Home,
                      $HomesTable,
                      Layout,
                      $LayoutsTable
                    >(
                      currentTable: table,
                      referencedTable: $$HomesTableReferences._layoutsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$HomesTableReferences(db, table, p0).layoutsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'home_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HomesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HomesTable,
      Home,
      $$HomesTableFilterComposer,
      $$HomesTableOrderingComposer,
      $$HomesTableAnnotationComposer,
      $$HomesTableCreateCompanionBuilder,
      $$HomesTableUpdateCompanionBuilder,
      (Home, $$HomesTableReferences),
      Home,
      PrefetchHooks Function({bool layoutsRefs})
    >;
typedef $$LayoutsTableCreateCompanionBuilder = LayoutsCompanion Function({
  required String id,
  required String homeId,
  required String name,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$LayoutsTableUpdateCompanionBuilder = LayoutsCompanion Function({
  Value<String> id,
  Value<String> homeId,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$LayoutsTableReferences
    extends BaseReferences<_$AppDatabase, $LayoutsTable, Layout> {
  $$LayoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HomesTable _homeIdTable(_$AppDatabase db) =>
      db.homes.createAlias('layouts__home_id__homes__id');

  $$HomesTableProcessedTableManager get homeId {
    final $_column = $_itemColumn<String>('home_id')!;

    final manager = $$HomesTableTableManager(
      $_db,
      $_db.homes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_homeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LayoutItemsTable, List<LayoutItem>>
  _layoutItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.layoutItems,
    aliasName: 'layouts__id__layout_items__layout_id',
  );

  $$LayoutItemsTableProcessedTableManager get layoutItemsRefs {
    final manager = $$LayoutItemsTableTableManager(
      $_db,
      $_db.layoutItems,
    ).filter((f) => f.layoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_layoutItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LayoutsTableFilterComposer
    extends Composer<_$AppDatabase, $LayoutsTable> {
  $$LayoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$HomesTableFilterComposer get homeId {
    final $$HomesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeId,
      referencedTable: $db.homes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomesTableFilterComposer(
            $db: $db,
            $table: $db.homes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> layoutItemsRefs(
    Expression<bool> Function($$LayoutItemsTableFilterComposer f) f,
  ) {
    final $$LayoutItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutItems,
      getReferencedColumn: (t) => t.layoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutItemsTableFilterComposer(
            $db: $db,
            $table: $db.layoutItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LayoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $LayoutsTable> {
  $$LayoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HomesTableOrderingComposer get homeId {
    final $$HomesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeId,
      referencedTable: $db.homes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomesTableOrderingComposer(
            $db: $db,
            $table: $db.homes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LayoutsTable> {
  $$LayoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HomesTableAnnotationComposer get homeId {
    final $$HomesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeId,
      referencedTable: $db.homes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomesTableAnnotationComposer(
            $db: $db,
            $table: $db.homes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> layoutItemsRefs<T extends Object>(
    Expression<T> Function($$LayoutItemsTableAnnotationComposer a) f,
  ) {
    final $$LayoutItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutItems,
      getReferencedColumn: (t) => t.layoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.layoutItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LayoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LayoutsTable,
          Layout,
          $$LayoutsTableFilterComposer,
          $$LayoutsTableOrderingComposer,
          $$LayoutsTableAnnotationComposer,
          $$LayoutsTableCreateCompanionBuilder,
          $$LayoutsTableUpdateCompanionBuilder,
          (Layout, $$LayoutsTableReferences),
          Layout,
          PrefetchHooks Function({bool homeId, bool layoutItemsRefs})
        > {
  $$LayoutsTableTableManager(_$AppDatabase db, $LayoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LayoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LayoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LayoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> homeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LayoutsCompanion(
                id: id,
                homeId: homeId,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String homeId,
                required String name,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LayoutsCompanion.insert(
                id: id,
                homeId: homeId,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LayoutsTable, Layout>(table),
                  $$LayoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({homeId = false, layoutItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (layoutItemsRefs) db.layoutItems],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (homeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.homeId,
                        referencedTable: $$LayoutsTableReferences._homeIdTable(
                          db,
                        ),
                        referencedColumn: $$LayoutsTableReferences
                            ._homeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (layoutItemsRefs)
                    await $_getPrefetchedDataByColumns<
                      Layout,
                      $LayoutsTable,
                      LayoutItem,
                      $LayoutItemsTable
                    >(
                      currentTable: table,
                      referencedTable: $$LayoutsTableReferences
                          ._layoutItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$LayoutsTableReferences(
                        db,
                        table,
                        p0,
                      ).layoutItemsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'layout_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LayoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LayoutsTable,
      Layout,
      $$LayoutsTableFilterComposer,
      $$LayoutsTableOrderingComposer,
      $$LayoutsTableAnnotationComposer,
      $$LayoutsTableCreateCompanionBuilder,
      $$LayoutsTableUpdateCompanionBuilder,
      (Layout, $$LayoutsTableReferences),
      Layout,
      PrefetchHooks Function({bool homeId, bool layoutItemsRefs})
    >;
typedef $$LayoutItemsTableCreateCompanionBuilder =
    LayoutItemsCompanion Function({
      required String id,
      required String layoutId,
      Value<String?> furnitureId,
      required String name,
      required int widthMm,
      required int depthMm,
      Value<int?> heightMm,
      required double xMm,
      required double yMm,
      Value<double> rotationDeg,
      required int colorValue,
      Value<String?> doorType,
      Value<int?> doorSwingMm,
      Value<int> zIndex,
      Value<int> rowid,
    });
typedef $$LayoutItemsTableUpdateCompanionBuilder =
    LayoutItemsCompanion Function({
      Value<String> id,
      Value<String> layoutId,
      Value<String?> furnitureId,
      Value<String> name,
      Value<int> widthMm,
      Value<int> depthMm,
      Value<int?> heightMm,
      Value<double> xMm,
      Value<double> yMm,
      Value<double> rotationDeg,
      Value<int> colorValue,
      Value<String?> doorType,
      Value<int?> doorSwingMm,
      Value<int> zIndex,
      Value<int> rowid,
    });

final class $$LayoutItemsTableReferences
    extends BaseReferences<_$AppDatabase, $LayoutItemsTable, LayoutItem> {
  $$LayoutItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LayoutsTable _layoutIdTable(_$AppDatabase db) =>
      db.layouts.createAlias('layout_items__layout_id__layouts__id');

  $$LayoutsTableProcessedTableManager get layoutId {
    final $_column = $_itemColumn<String>('layout_id')!;

    final manager = $$LayoutsTableTableManager(
      $_db,
      $_db.layouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_layoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LayoutItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LayoutItemsTable> {
  $$LayoutItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get furnitureId => $composableBuilder(
    column: $table.furnitureId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get widthMm => $composableBuilder(
    column: $table.widthMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get depthMm => $composableBuilder(
    column: $table.depthMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightMm => $composableBuilder(
    column: $table.heightMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get xMm => $composableBuilder(
    column: $table.xMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get yMm => $composableBuilder(
    column: $table.yMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rotationDeg => $composableBuilder(
    column: $table.rotationDeg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doorType => $composableBuilder(
    column: $table.doorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doorSwingMm => $composableBuilder(
    column: $table.doorSwingMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zIndex => $composableBuilder(
    column: $table.zIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$LayoutsTableFilterComposer get layoutId {
    final $$LayoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.layouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutsTableFilterComposer(
            $db: $db,
            $table: $db.layouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LayoutItemsTable> {
  $$LayoutItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get furnitureId => $composableBuilder(
    column: $table.furnitureId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get widthMm => $composableBuilder(
    column: $table.widthMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get depthMm => $composableBuilder(
    column: $table.depthMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightMm => $composableBuilder(
    column: $table.heightMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get xMm => $composableBuilder(
    column: $table.xMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get yMm => $composableBuilder(
    column: $table.yMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rotationDeg => $composableBuilder(
    column: $table.rotationDeg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doorType => $composableBuilder(
    column: $table.doorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doorSwingMm => $composableBuilder(
    column: $table.doorSwingMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zIndex => $composableBuilder(
    column: $table.zIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$LayoutsTableOrderingComposer get layoutId {
    final $$LayoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.layouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutsTableOrderingComposer(
            $db: $db,
            $table: $db.layouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LayoutItemsTable> {
  $$LayoutItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get furnitureId => $composableBuilder(
    column: $table.furnitureId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get widthMm =>
      $composableBuilder(column: $table.widthMm, builder: (column) => column);

  GeneratedColumn<int> get depthMm =>
      $composableBuilder(column: $table.depthMm, builder: (column) => column);

  GeneratedColumn<int> get heightMm =>
      $composableBuilder(column: $table.heightMm, builder: (column) => column);

  GeneratedColumn<double> get xMm =>
      $composableBuilder(column: $table.xMm, builder: (column) => column);

  GeneratedColumn<double> get yMm =>
      $composableBuilder(column: $table.yMm, builder: (column) => column);

  GeneratedColumn<double> get rotationDeg => $composableBuilder(
    column: $table.rotationDeg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doorType =>
      $composableBuilder(column: $table.doorType, builder: (column) => column);

  GeneratedColumn<int> get doorSwingMm => $composableBuilder(
    column: $table.doorSwingMm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get zIndex =>
      $composableBuilder(column: $table.zIndex, builder: (column) => column);

  $$LayoutsTableAnnotationComposer get layoutId {
    final $$LayoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.layouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.layouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LayoutItemsTable,
          LayoutItem,
          $$LayoutItemsTableFilterComposer,
          $$LayoutItemsTableOrderingComposer,
          $$LayoutItemsTableAnnotationComposer,
          $$LayoutItemsTableCreateCompanionBuilder,
          $$LayoutItemsTableUpdateCompanionBuilder,
          (LayoutItem, $$LayoutItemsTableReferences),
          LayoutItem,
          PrefetchHooks Function({bool layoutId})
        > {
  $$LayoutItemsTableTableManager(_$AppDatabase db, $LayoutItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LayoutItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LayoutItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LayoutItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> layoutId = const Value.absent(),
                Value<String?> furnitureId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> widthMm = const Value.absent(),
                Value<int> depthMm = const Value.absent(),
                Value<int?> heightMm = const Value.absent(),
                Value<double> xMm = const Value.absent(),
                Value<double> yMm = const Value.absent(),
                Value<double> rotationDeg = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<String?> doorType = const Value.absent(),
                Value<int?> doorSwingMm = const Value.absent(),
                Value<int> zIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LayoutItemsCompanion(
                id: id,
                layoutId: layoutId,
                furnitureId: furnitureId,
                name: name,
                widthMm: widthMm,
                depthMm: depthMm,
                heightMm: heightMm,
                xMm: xMm,
                yMm: yMm,
                rotationDeg: rotationDeg,
                colorValue: colorValue,
                doorType: doorType,
                doorSwingMm: doorSwingMm,
                zIndex: zIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String layoutId,
                Value<String?> furnitureId = const Value.absent(),
                required String name,
                required int widthMm,
                required int depthMm,
                Value<int?> heightMm = const Value.absent(),
                required double xMm,
                required double yMm,
                Value<double> rotationDeg = const Value.absent(),
                required int colorValue,
                Value<String?> doorType = const Value.absent(),
                Value<int?> doorSwingMm = const Value.absent(),
                Value<int> zIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LayoutItemsCompanion.insert(
                id: id,
                layoutId: layoutId,
                furnitureId: furnitureId,
                name: name,
                widthMm: widthMm,
                depthMm: depthMm,
                heightMm: heightMm,
                xMm: xMm,
                yMm: yMm,
                rotationDeg: rotationDeg,
                colorValue: colorValue,
                doorType: doorType,
                doorSwingMm: doorSwingMm,
                zIndex: zIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LayoutItemsTable, LayoutItem>(table),
                  $$LayoutItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({layoutId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (layoutId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.layoutId,
                        referencedTable: $$LayoutItemsTableReferences
                            ._layoutIdTable(db),
                        referencedColumn: $$LayoutItemsTableReferences
                            ._layoutIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LayoutItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LayoutItemsTable,
      LayoutItem,
      $$LayoutItemsTableFilterComposer,
      $$LayoutItemsTableOrderingComposer,
      $$LayoutItemsTableAnnotationComposer,
      $$LayoutItemsTableCreateCompanionBuilder,
      $$LayoutItemsTableUpdateCompanionBuilder,
      (LayoutItem, $$LayoutItemsTableReferences),
      LayoutItem,
      PrefetchHooks Function({bool layoutId})
    >;
typedef $$CustomFurnituresTableCreateCompanionBuilder =
    CustomFurnituresCompanion Function({
      required String id,
      required String name,
      required String category,
      required int widthMm,
      required int depthMm,
      Value<int?> heightMm,
      required int colorValue,
      Value<String?> doorType,
      Value<int?> doorSwingMm,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CustomFurnituresTableUpdateCompanionBuilder =
    CustomFurnituresCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<int> widthMm,
      Value<int> depthMm,
      Value<int?> heightMm,
      Value<int> colorValue,
      Value<String?> doorType,
      Value<int?> doorSwingMm,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CustomFurnituresTableFilterComposer
    extends Composer<_$AppDatabase, $CustomFurnituresTable> {
  $$CustomFurnituresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get widthMm => $composableBuilder(
    column: $table.widthMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get depthMm => $composableBuilder(
    column: $table.depthMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightMm => $composableBuilder(
    column: $table.heightMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doorType => $composableBuilder(
    column: $table.doorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doorSwingMm => $composableBuilder(
    column: $table.doorSwingMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomFurnituresTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomFurnituresTable> {
  $$CustomFurnituresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get widthMm => $composableBuilder(
    column: $table.widthMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get depthMm => $composableBuilder(
    column: $table.depthMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightMm => $composableBuilder(
    column: $table.heightMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doorType => $composableBuilder(
    column: $table.doorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doorSwingMm => $composableBuilder(
    column: $table.doorSwingMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomFurnituresTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomFurnituresTable> {
  $$CustomFurnituresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get widthMm =>
      $composableBuilder(column: $table.widthMm, builder: (column) => column);

  GeneratedColumn<int> get depthMm =>
      $composableBuilder(column: $table.depthMm, builder: (column) => column);

  GeneratedColumn<int> get heightMm =>
      $composableBuilder(column: $table.heightMm, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doorType =>
      $composableBuilder(column: $table.doorType, builder: (column) => column);

  GeneratedColumn<int> get doorSwingMm => $composableBuilder(
    column: $table.doorSwingMm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomFurnituresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomFurnituresTable,
          CustomFurniture,
          $$CustomFurnituresTableFilterComposer,
          $$CustomFurnituresTableOrderingComposer,
          $$CustomFurnituresTableAnnotationComposer,
          $$CustomFurnituresTableCreateCompanionBuilder,
          $$CustomFurnituresTableUpdateCompanionBuilder,
          (
            CustomFurniture,
            BaseReferences<
              _$AppDatabase,
              $CustomFurnituresTable,
              CustomFurniture
            >,
          ),
          CustomFurniture,
          PrefetchHooks Function()
        > {
  $$CustomFurnituresTableTableManager(
    _$AppDatabase db,
    $CustomFurnituresTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomFurnituresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomFurnituresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomFurnituresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> widthMm = const Value.absent(),
                Value<int> depthMm = const Value.absent(),
                Value<int?> heightMm = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<String?> doorType = const Value.absent(),
                Value<int?> doorSwingMm = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomFurnituresCompanion(
                id: id,
                name: name,
                category: category,
                widthMm: widthMm,
                depthMm: depthMm,
                heightMm: heightMm,
                colorValue: colorValue,
                doorType: doorType,
                doorSwingMm: doorSwingMm,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                required int widthMm,
                required int depthMm,
                Value<int?> heightMm = const Value.absent(),
                required int colorValue,
                Value<String?> doorType = const Value.absent(),
                Value<int?> doorSwingMm = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CustomFurnituresCompanion.insert(
                id: id,
                name: name,
                category: category,
                widthMm: widthMm,
                depthMm: depthMm,
                heightMm: heightMm,
                colorValue: colorValue,
                doorType: doorType,
                doorSwingMm: doorSwingMm,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomFurnituresTable, CustomFurniture>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CustomFurnituresTable,
                    CustomFurniture
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomFurnituresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomFurnituresTable,
      CustomFurniture,
      $$CustomFurnituresTableFilterComposer,
      $$CustomFurnituresTableOrderingComposer,
      $$CustomFurnituresTableAnnotationComposer,
      $$CustomFurnituresTableCreateCompanionBuilder,
      $$CustomFurnituresTableUpdateCompanionBuilder,
      (
        CustomFurniture,
        BaseReferences<_$AppDatabase, $CustomFurnituresTable, CustomFurniture>,
      ),
      CustomFurniture,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HomesTableTableManager get homes =>
      $$HomesTableTableManager(_db, _db.homes);
  $$LayoutsTableTableManager get layouts =>
      $$LayoutsTableTableManager(_db, _db.layouts);
  $$LayoutItemsTableTableManager get layoutItems =>
      $$LayoutItemsTableTableManager(_db, _db.layoutItems);
  $$CustomFurnituresTableTableManager get customFurnitures =>
      $$CustomFurnituresTableTableManager(_db, _db.customFurnitures);
}
