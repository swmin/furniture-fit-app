import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/units.dart';
import '../../../domain/models/furniture_preset.dart';
import '../../widgets/ad_banner_bar.dart';

/// 기본 가구·가전 라이브러리 둘러보기.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  FurnitureCategory? _category;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final presets = ref.watch(furniturePresetsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('가구 라이브러리')),
      bottomNavigationBar: const AdBannerBar(),
      body: presets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('라이브러리 로드 실패: $e')),
        data: (all) {
          final items = all.where((p) {
            if (_category != null && p.category != _category) return false;
            return _query.isEmpty || p.name.contains(_query);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: '가구 검색 (예: 퀸, 냉장고)',
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _query = v.trim()),
                ),
              ),
              SizedBox(
                height: 56,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  children: [
                    _chip(null, '전체'),
                    for (final c in FurnitureCategory.values) _chip(c, c.label),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) => _PresetTile(preset: items[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _chip(FurnitureCategory? c, String label) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: ChoiceChip(
      label: Text(label),
      selected: _category == c,
      onSelected: (_) => setState(() => _category = c),
    ),
  );
}

class _PresetTile extends StatelessWidget {
  const _PresetTile({required this.preset});

  final FurniturePreset preset;

  @override
  Widget build(BuildContext context) {
    final p = preset;
    // 평면 비율 썸네일 (가로:세로).
    final ratio = p.widthMm / p.depthMm;
    const box = 40.0;
    final w = ratio >= 1 ? box : box * ratio;
    final h = ratio >= 1 ? box / ratio : box;

    return ListTile(
      leading: SizedBox(
        width: box,
        height: box,
        child: Center(
          child: Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              color: Color(p.colorValue),
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
      title: Text(p.name),
      subtitle: Text(
        [
          formatSize(p.widthMm, p.depthMm),
          if (p.heightMm != null) '높이 ${formatLength(p.heightMm!)}',
          if (p.door != null) '문 반경 ${formatLength(p.door!.swingMm)}',
        ].join(' · '),
      ),
      trailing: Text(
        p.category.label,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
