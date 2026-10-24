import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/providers.dart';
import '../../../core/units.dart';
import '../../../data/repositories/layout_repository.dart';
import '../../../domain/models/furniture_preset.dart';
import '../pro/paywall_sheet.dart';
import 'furniture_form.dart';

/// 가구 추가 바텀시트. 선택한 가구 사양을 반환한다.
Future<FurnitureSpec?> showAddFurnitureSheet(BuildContext context) =>
    showModalBottomSheet<FurnitureSpec>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.8,
        child: const AddFurnitureSheet(),
      ),
    );

class AddFurnitureSheet extends ConsumerStatefulWidget {
  const AddFurnitureSheet({super.key});

  @override
  ConsumerState<AddFurnitureSheet> createState() => _AddFurnitureSheetState();
}

class _AddFurnitureSheetState extends ConsumerState<AddFurnitureSheet> {
  FurnitureCategory? _category;
  String _query = '';

  FurnitureSpec _fromPreset(FurniturePreset p) => FurnitureSpec(
    furnitureId: p.id,
    name: p.name,
    widthMm: p.widthMm,
    depthMm: p.depthMm,
    heightMm: p.heightMm,
    colorValue: p.colorValue,
    doorType: p.door?.type,
    doorSwingMm: p.door?.swingMm,
  );

  Future<void> _customInput() async {
    final result = await showFurnitureForm(context);
    if (result == null || !mounted) return;
    var spec = result.spec;
    if (result.saveToMine) {
      final repo = ref.read(layoutRepositoryProvider);
      final isPro = ref.read(proStatusProvider);
      final count = await repo.countCustomFurnitures();
      if (!mounted) return;
      if (!isPro && count >= AppConstants.freeCustomFurnitureLimit) {
        await showPaywallSheet(
          context,
          reason: PaywallReason.customFurnitureLimit,
        );
        if (!mounted) return;
        // 저장은 못 해도 이번 배치에는 추가한다.
      } else {
        final id = await repo.saveCustomFurniture(spec);
        spec = FurnitureSpec(
          furnitureId: id,
          name: spec.name,
          widthMm: spec.widthMm,
          depthMm: spec.depthMm,
          heightMm: spec.heightMm,
          colorValue: spec.colorValue,
          doorType: spec.doorType,
          doorSwingMm: spec.doorSwingMm,
        );
      }
    }
    if (mounted) Navigator.pop(context, spec);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Row(
              children: [
                Text('가구 추가', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                FilledButton.tonalIcon(
                  onPressed: _customInput,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('직접 입력'),
                ),
              ],
            ),
          ),
          const TabBar(
            tabs: [
              Tab(text: '라이브러리'),
              Tab(text: '내 가구'),
            ],
          ),
          Expanded(child: TabBarView(children: [_library(), _mine()])),
        ],
      ),
    );
  }

  Widget _library() {
    final presets = ref.watch(furniturePresetsProvider);
    return presets.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (all) {
        final items = all.where((p) {
          if (_category != null && p.category != _category) return false;
          return _query.isEmpty || p.name.contains(_query);
        }).toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: '검색 (예: 퀸, 냉장고, 장롱)',
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
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
                itemBuilder: (context, i) {
                  final p = items[i];
                  return _SpecTile(
                    spec: _fromPreset(p),
                    trailing: Text(
                      p.category.label,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    onTap: () => Navigator.pop(context, _fromPreset(p)),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _mine() {
    final mine = ref.watch(customFurnituresProvider);
    final isPro = ref.watch(proStatusProvider);
    return mine.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) => list.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  '저장된 가구가 없어요.\n"직접 입력"에서 "내 가구에 저장"을 체크해 보세요.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    isPro
                        ? '${list.length}개 저장됨'
                        : '${list.length} / ${AppConstants.freeCustomFurnitureLimit}개 저장됨 (무료)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final c = list[i];
                      final spec = FurnitureSpec(
                        furnitureId: c.id,
                        name: c.name,
                        widthMm: c.widthMm,
                        depthMm: c.depthMm,
                        heightMm: c.heightMm,
                        colorValue: c.colorValue,
                        doorType: c.doorType,
                        doorSwingMm: c.doorSwingMm,
                      );
                      return _SpecTile(
                        spec: spec,
                        onTap: () => Navigator.pop(context, spec),
                        trailing: IconButton(
                          tooltip: '삭제',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => ref
                              .read(layoutRepositoryProvider)
                              .deleteCustomFurniture(c.id),
                        ),
                      );
                    },
                  ),
                ),
              ],
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

class _SpecTile extends StatelessWidget {
  const _SpecTile({required this.spec, required this.onTap, this.trailing});

  final FurnitureSpec spec;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ratio = spec.widthMm / spec.depthMm;
    const box = 40.0;
    final w = ratio >= 1 ? box : box * ratio;
    final h = ratio >= 1 ? box / ratio : box;
    return ListTile(
      onTap: onTap,
      leading: SizedBox.square(
        dimension: box,
        child: Center(
          child: Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              color: Color(spec.colorValue),
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
      title: Text(spec.name),
      subtitle: Text(
        [
          formatSize(spec.widthMm, spec.depthMm),
          if (spec.heightMm != null) '높이 ${formatLength(spec.heightMm!)}',
          if (spec.doorType != null) doorTypeLabels[spec.doorType]!,
        ].join(' · '),
      ),
      trailing: trailing,
    );
  }
}
