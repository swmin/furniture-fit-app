/// 가구 카테고리.
enum FurnitureCategory {
  bed('침대'),
  storage('수납'),
  desk('책상'),
  sofa('소파'),
  table('식탁'),
  kitchenAppliance('주방가전'),
  livingAppliance('생활가전'),
  etc('기타');

  const FurnitureCategory(this.label);
  final String label;

  static FurnitureCategory fromKey(String key) => FurnitureCategory.values
      .firstWhere((c) => c.name == key, orElse: () => FurnitureCategory.etc);
}

/// 문 열림 정보 (반경 표시용).
class DoorSpec {
  const DoorSpec({required this.type, required this.swingMm});

  /// 'single' | 'double' | 'drawer'
  final String type;
  final int swingMm;

  factory DoorSpec.fromJson(Map<String, dynamic> json) => DoorSpec(
        type: json['type'] as String,
        swingMm: json['swingMm'] as int,
      );
}

/// 기본 가구 라이브러리 프리셋 (assets/furniture_library.json).
class FurniturePreset {
  const FurniturePreset({
    required this.id,
    required this.category,
    required this.name,
    required this.widthMm,
    required this.depthMm,
    this.heightMm,
    this.door,
    required this.colorValue,
  });

  final String id;
  final FurnitureCategory category;
  final String name;
  final int widthMm;
  final int depthMm;
  final int? heightMm;
  final DoorSpec? door;
  final int colorValue;

  factory FurniturePreset.fromJson(Map<String, dynamic> json) =>
      FurniturePreset(
        id: json['id'] as String,
        category: FurnitureCategory.fromKey(json['category'] as String),
        name: json['name'] as String,
        widthMm: json['widthMm'] as int,
        depthMm: json['depthMm'] as int,
        heightMm: json['heightMm'] as int?,
        door: json['door'] == null
            ? null
            : DoorSpec.fromJson(json['door'] as Map<String, dynamic>),
        colorValue: int.parse(
          (json['color'] as String).replaceFirst('#', 'FF'),
          radix: 16,
        ),
      );
}
