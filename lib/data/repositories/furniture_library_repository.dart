import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/furniture_preset.dart';

/// 앱에 내장된 한국형 가구·가전 규격 라이브러리를 읽는다.
class FurnitureLibraryRepository {
  FurnitureLibraryRepository({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/furniture_library.json';

  final AssetBundle _bundle;
  List<FurniturePreset>? _cache;

  Future<List<FurniturePreset>> loadPresets() async {
    if (_cache != null) return _cache!;
    final raw = await _bundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _cache = (json['items'] as List<dynamic>)
        .map((e) => FurniturePreset.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _cache!;
  }
}
