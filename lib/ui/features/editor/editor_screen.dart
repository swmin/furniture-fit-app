import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers.dart';
import '../../../core/units.dart';
import '../../../data/local/app_database.dart';
import '../../../data/repositories/home_repository.dart';
import '../../../data/repositories/layout_repository.dart';
import '../../../domain/geometry/placement.dart';
import '../../services/layout_image_exporter.dart';
import '../../widgets/ad_banner_bar.dart';
import '../pro/paywall_sheet.dart';
import 'add_furniture_sheet.dart';
import 'editor_canvas.dart';
import 'furniture_form.dart';

/// 배치 편집 화면.
class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key, required this.homeId});

  final String homeId;

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  final _canvasKey = GlobalKey<EditorCanvasState>();
  String? _selectedLayoutId;
  String? _selectedItemId;
  bool _showDoors = false;
  bool _exporting = false;

  /// 배치안별 실행취소 / 다시실행 스택 (메모리 보관, 최대 40단계).
  final Map<String, List<List<LayoutItem>>> _undoStacks = {};
  final Map<String, List<List<LayoutItem>>> _redoStacks = {};
  static const _maxHistory = 40;

  LayoutRepository get _repo => ref.read(layoutRepositoryProvider);
  HomeRepository get _homeRepo => ref.read(homeRepositoryProvider);

  bool _canUndo(String? layoutId) =>
      layoutId != null && (_undoStacks[layoutId]?.isNotEmpty ?? false);

  bool _canRedo(String? layoutId) =>
      layoutId != null && (_redoStacks[layoutId]?.isNotEmpty ?? false);

  void _recordSnapshot(String layoutId, List<LayoutItem> before) {
    final stack = _undoStacks.putIfAbsent(layoutId, () => []);
    stack.add(List<LayoutItem>.unmodifiable(before));
    if (stack.length > _maxHistory) stack.removeAt(0);
    _redoStacks[layoutId]?.clear();
  }

  Future<void> _undo(String layoutId, List<LayoutItem> current) async {
    final stack = _undoStacks[layoutId];
    if (stack == null || stack.isEmpty) return;
    final prev = stack.removeLast();
    _redoStacks.putIfAbsent(layoutId, () => []).add(
      List<LayoutItem>.unmodifiable(current),
    );
    await _repo.replaceItems(layoutId, prev);
    if (_selectedItemId != null && !prev.any((i) => i.id == _selectedItemId)) {
      setState(() => _selectedItemId = null);
    } else {
      setState(() {});
    }
  }

  Future<void> _redo(String layoutId, List<LayoutItem> current) async {
    final stack = _redoStacks[layoutId];
    if (stack == null || stack.isEmpty) return;
    final next = stack.removeLast();
    _undoStacks.putIfAbsent(layoutId, () => []).add(
      List<LayoutItem>.unmodifiable(current),
    );
    await _repo.replaceItems(layoutId, next);
    if (_selectedItemId != null && !next.any((i) => i.id == _selectedItemId)) {
      setState(() => _selectedItemId = null);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = ref.watch(homeProvider(widget.homeId));
    final layouts = ref.watch(layoutsProvider(widget.homeId));

    return home.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (h) {
        if (h == null) {
          return const Scaffold(body: Center(child: Text('삭제된 집입니다.')));
        }
        final layoutList = layouts.value ?? const <Layout>[];
        final layout = layoutList.isEmpty
            ? null
            : layoutList.firstWhere(
                (l) => l.id == _selectedLayoutId,
                orElse: () => layoutList.first,
              );
        final items = layout == null
            ? const <LayoutItem>[]
            : (ref.watch(layoutItemsProvider(layout.id)).value ??
                  const <LayoutItem>[]);
        final selected = items
            .where((i) => i.id == _selectedItemId)
            .firstOrNull;
        final world = _world(h);

        return Scaffold(
          appBar: AppBar(
            title: Text(h.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              IconButton(
                tooltip: '실행취소',
                icon: const Icon(Icons.undo),
                onPressed: _canUndo(layout?.id)
                    ? () => _undo(layout!.id, items)
                    : null,
              ),
              IconButton(
                tooltip: '다시실행',
                icon: const Icon(Icons.redo),
                onPressed: _canRedo(layout?.id)
                    ? () => _redo(layout!.id, items)
                    : null,
              ),
              IconButton(
                tooltip: _showDoors ? '문 열림 반경 숨기기' : '문 열림 반경 모두 보기',
                isSelected: _showDoors,
                icon: const Icon(Icons.door_front_door_outlined),
                selectedIcon: const Icon(Icons.door_front_door),
                onPressed: () => setState(() => _showDoors = !_showDoors),
              ),
              if (h.floorPlanPath != null)
                IconButton(
                  tooltip: '축척 다시 맞추기',
                  icon: const Icon(Icons.straighten),
                  onPressed: () => context.push('/homes/${h.id}/calibrate'),
                ),
              IconButton(
                tooltip: '이미지로 내보내기',
                icon: _exporting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.ios_share_outlined),
                onPressed: (!_exporting && layout != null && world != null)
                    ? () => _onExportPressed(h, layout, world, items)
                    : null,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: _LayoutBar(
                layouts: layoutList,
                selectedId: layout?.id,
                onSelect: (id) => setState(() {
                  _selectedLayoutId = id;
                  _selectedItemId = null;
                }),
                onMenu: (l) => _showLayoutOptions(l, layoutList),
                onAdd: () => _addLayout(layoutList.length + 1),
              ),
            ),
          ),
          body: _body(h, layout, items),
          bottomNavigationBar: SafeArea(
            child: selected != null
                ? _SelectionBar(
                    item: selected,
                    onRotate: () => _commitWithUndo(
                      items,
                      selected.copyWith(
                        rotationDeg: snapAngle(selected.rotationDeg + 90),
                      ),
                    ),
                    onEdit: () => _edit(selected, items),
                    onDuplicate: () async {
                      _recordSnapshot(selected.layoutId, items);
                      final id = await _repo.duplicateItem(selected);
                      setState(() => _selectedItemId = id);
                    },
                    onDelete: () {
                      _recordSnapshot(selected.layoutId, items);
                      _repo.deleteItem(selected);
                      setState(() => _selectedItemId = null);
                    },
                    onClose: () => setState(() => _selectedItemId = null),
                    onAdd: layout == null
                        ? null
                        : () => _addFurniture(layout.id, items),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: FilledButton.icon(
                      onPressed: layout != null && world != null
                          ? () => _addFurniture(layout.id, items)
                          : null,
                      icon: const Icon(Icons.add),
                      label: const Text('가구 추가'),
                    ),
                  ),
          ),
        );
      },
    );
  }

  /// 배경 전체 영역 (mm). 도면 축척이 없으면 null.
  Rect? _world(Home h) {
    if (h.roomWidthMm != null && h.roomDepthMm != null) {
      return Rect.fromLTWH(
        0,
        0,
        h.roomWidthMm!.toDouble(),
        h.roomDepthMm!.toDouble(),
      );
    }
    final mpp = h.mmPerPixel;
    if (h.floorPlanPath != null &&
        mpp != null &&
        h.floorPlanWidthPx != null &&
        h.floorPlanHeightPx != null) {
      return Rect.fromLTWH(
        0,
        0,
        h.floorPlanWidthPx! * mpp,
        h.floorPlanHeightPx! * mpp,
      );
    }
    return null;
  }

  Widget _body(Home h, Layout? layout, List<LayoutItem> items) {
    final world = _world(h);
    if (world == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.straighten, size: 56),
              const SizedBox(height: 16),
              const Text(
                '가구를 정확한 크기로 배치하려면\n먼저 도면 축척을 맞춰 주세요.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.push('/homes/${h.id}/calibrate'),
                child: const Text('축척 맞추기'),
              ),
            ],
          ),
        ),
      );
    }
    final isRoom = h.roomWidthMm != null;
    final file = h.floorPlanPath == null
        ? null
        : ref.watch(floorPlanFileProvider(h.floorPlanPath!)).value;
    final report = analyzePlacement(items, room: isRoom ? world : null);

    return Column(
      children: [
        if (report.hasIssues) _IssueStrip(report: report),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: EditorCanvas(
                  key: _canvasKey,
                  world: world,
                  isRoom: isRoom,
                  imageFile: file,
                  items: items,
                  selectedId: _selectedItemId,
                  showDoors: _showDoors,
                  onSelect: (id) => setState(() => _selectedItemId = id),
                  onCommit: (updated) => _commitWithUndo(items, updated),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Column(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () => _canvasKey.currentState?.zoomBy(1.5),
                      icon: const Icon(Icons.zoom_in),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => _canvasKey.currentState?.zoomBy(1 / 1.5),
                      icon: const Icon(Icons.zoom_out),
                    ),
                    IconButton.filledTonal(
                      tooltip: '화면에 맞추기',
                      onPressed: () => _canvasKey.currentState?.fitToScreen(),
                      icon: const Icon(Icons.fit_screen_outlined),
                    ),
                  ],
                ),
              ),
              if (items.isEmpty)
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 12,
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Text('아래 "가구 추가"로 가구를 놓아 보세요'),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _commitWithUndo(
    List<LayoutItem> before,
    LayoutItem updated,
  ) async {
    final prev = before.where((i) => i.id == updated.id).firstOrNull;
    if (prev != null &&
        prev.xMm == updated.xMm &&
        prev.yMm == updated.yMm &&
        prev.rotationDeg == updated.rotationDeg &&
        prev.widthMm == updated.widthMm &&
        prev.depthMm == updated.depthMm &&
        prev.name == updated.name &&
        prev.colorValue == updated.colorValue &&
        prev.doorType == updated.doorType &&
        prev.doorSwingMm == updated.doorSwingMm) {
      return;
    }
    _recordSnapshot(updated.layoutId, before);
    await _repo.updateItem(updated);
    if (mounted) setState(() {});
  }

  Future<void> _addLayout(int nextNumber) async {
    final id = await _homeRepo.createLayout(widget.homeId, '배치안 $nextNumber');
    setState(() {
      _selectedLayoutId = id;
      _selectedItemId = null;
    });
  }

  Future<void> _showLayoutOptions(
    Layout layout,
    List<Layout> allLayouts,
  ) async {
    final canDelete = allLayouts.length > 1;
    final action = await showModalBottomSheet<_LayoutMenuAction>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                layout.name,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              subtitle: const Text('배치안 관리'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.copy_all_outlined),
              title: const Text('이 배치안 복제'),
              subtitle: const Text('현재 가구 배치를 그대로 복사해 새 배치안 생성'),
              onTap: () => Navigator.pop(ctx, _LayoutMenuAction.duplicate),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('이름 변경'),
              onTap: () => Navigator.pop(ctx, _LayoutMenuAction.rename),
            ),
            if (canDelete)
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(ctx).colorScheme.error,
                ),
                title: Text(
                  '삭제',
                  style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                ),
                onTap: () => Navigator.pop(ctx, _LayoutMenuAction.delete),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;

    switch (action) {
      case _LayoutMenuAction.duplicate:
        final newId = await _homeRepo.duplicateLayout(
          layout.id,
          '${layout.name} 사본',
        );
        if (!mounted) return;
        setState(() {
          _selectedLayoutId = newId;
          _selectedItemId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${layout.name} 사본" 배치안이 생성되었습니다.')),
        );
      case _LayoutMenuAction.rename:
        final name = await _askLayoutName(layout.name);
        if (name != null) await _homeRepo.renameLayout(layout.id, name);
      case _LayoutMenuAction.delete:
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('배치안 삭제'),
            content: Text('"${layout.name}" 배치안과 그 안의 가구가 삭제됩니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('취소'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('삭제'),
              ),
            ],
          ),
        );
        if (ok == true) {
          _undoStacks.remove(layout.id);
          _redoStacks.remove(layout.id);
          await _homeRepo.deleteLayout(layout.id);
          if (!mounted) return;
          setState(() {
            if (_selectedLayoutId == layout.id) _selectedLayoutId = null;
            _selectedItemId = null;
          });
        }
    }
  }

  Future<String?> _askLayoutName(String initial) {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('배치안 이름 변경'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 40,
          decoration: const InputDecoration(hintText: '예: 침대 창가안'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              final v = controller.text.trim();
              Navigator.pop(ctx, v.isEmpty ? null : v);
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  Future<void> _addFurniture(
    String layoutId,
    List<LayoutItem> currentItems,
  ) async {
    final spec = await showAddFurnitureSheet(context);
    if (spec == null || !mounted) return;
    _recordSnapshot(layoutId, currentItems);
    final c = _canvasKey.currentState?.viewportCenterWorld() ?? Offset.zero;
    final id = await _repo.addItem(
      layoutId: layoutId,
      spec: spec,
      xMm: c.dx.roundToDouble(),
      yMm: c.dy.roundToDouble(),
    );
    setState(() => _selectedItemId = id);
  }

  Future<void> _edit(LayoutItem item, List<LayoutItem> currentItems) async {
    final result = await showFurnitureForm(
      context,
      title: '가구 수정',
      allowSaveToMine: false,
      initial: FurnitureSpec(
        furnitureId: item.furnitureId,
        name: item.name,
        widthMm: item.widthMm,
        depthMm: item.depthMm,
        heightMm: item.heightMm,
        colorValue: item.colorValue,
        doorType: item.doorType,
        doorSwingMm: item.doorSwingMm,
      ),
    );
    if (result == null) return;
    final s = result.spec;
    _recordSnapshot(item.layoutId, currentItems);
    await _repo.updateItem(
      item.copyWith(
        name: s.name,
        widthMm: s.widthMm,
        depthMm: s.depthMm,
        heightMm: Value(s.heightMm),
        colorValue: s.colorValue,
        doorType: Value(s.doorType),
        doorSwingMm: Value(s.doorSwingMm),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _onExportPressed(
    Home home,
    Layout layout,
    Rect world,
    List<LayoutItem> items,
  ) async {
    final isPro = ref.read(proStatusProvider);
    var hd = isPro;
    var watermark = !isPro;

    if (!isPro) {
      final choice = await showModalBottomSheet<_ExportChoice>(
        context: context,
        showDragHandle: true,
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '이미지로 내보내기',
                  style: Theme.of(ctx).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: const Text('표준 이미지 공유 (무료)'),
                  subtitle: const Text('기본 해상도 · 우측 하단 워터마크 포함'),
                  onTap: () => Navigator.pop(ctx, _ExportChoice.standard),
                ),
                ListTile(
                  leading: const Icon(Icons.play_circle_outline),
                  title: const Text('광고 보고 1회 고화질 저장 (워터마크 없음)'),
                  subtitle: const Text('보상형 광고 시청 후 2400px 고화질 내보내기'),
                  onTap: () => Navigator.pop(ctx, _ExportChoice.rewardedAd),
                ),
                ListTile(
                  leading: Icon(
                    Icons.workspace_premium_outlined,
                    color: Theme.of(ctx).colorScheme.primary,
                  ),
                  title: const Text('Pro 업그레이드 (항상 고화질 · 광고 제거)'),
                  subtitle: const Text('한 번 결제로 워터마크·광고 영구 제거'),
                  onTap: () => Navigator.pop(ctx, _ExportChoice.proPaywall),
                ),
              ],
            ),
          ),
        ),
      );
      if (choice == null || !mounted) return;
      if (choice == _ExportChoice.rewardedAd) {
        final rewarded = await AdMobService.showRewardedForHdExport(context);
        if (!mounted) return;
        if (!rewarded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('광고를 불러오지 못했거나 시청이 완료되지 않았습니다.'),
            ),
          );
          return;
        }
        hd = true;
        watermark = false;
      } else if (choice == _ExportChoice.proPaywall) {
        await showPaywallSheet(context, reason: PaywallReason.hdExport);
        if (!mounted || !ref.read(proStatusProvider)) return;
        hd = true;
        watermark = false;
      }
    }

    setState(() => _exporting = true);
    try {
      File? floorPlanFile;
      if (home.floorPlanPath != null) {
        floorPlanFile = await ref.read(
          floorPlanFileProvider(home.floorPlanPath!).future,
        );
      }
      if (!mounted) return;
      final scheme = Theme.of(context).colorScheme;
      final title = '${home.name} · ${layout.name}';
      final pngFile = await LayoutImageExporter.exportPng(
        title: title,
        world: world,
        isRoom: home.roomWidthMm != null,
        floorPlanFile: floorPlanFile,
        items: items,
        scheme: scheme,
        hd: hd,
        watermark: watermark,
      );
      if (!mounted) return;
      await _showExportPreviewDialog(pngFile, title, hd: hd);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _showExportPreviewDialog(
    File pngFile,
    String title, {
    required bool hd,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(hd ? '고화질 배치도 준비 완료' : '배치도 이미지 준비 완료'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: Image.file(pngFile, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(ctx).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('닫기'),
          ),
          FilledButton.icon(
            onPressed: () async {
              Navigator.pop(ctx);
              await SharePlus.instance.share(
                ShareParams(
                  files: [XFile(pngFile.path, mimeType: 'image/png')],
                  text: title,
                ),
              );
            },
            icon: const Icon(Icons.share),
            label: const Text('공유하기'),
          ),
        ],
      ),
    );
  }
}

enum _LayoutMenuAction { duplicate, rename, delete }

enum _ExportChoice { standard, rewardedAd, proPaywall }

class _IssueStrip extends StatelessWidget {
  const _IssueStrip({required this.report});

  final PlacementReport report;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final parts = [
      if (report.overlapping.isNotEmpty) '겹침 ${report.overlapping.length}개',
      if (report.doorBlocked.isNotEmpty)
        '문·서랍 열림 방해 ${report.doorBlocked.length}개',
      if (report.outOfRoom.isNotEmpty) '방 밖으로 나감 ${report.outOfRoom.length}개',
    ];
    return Material(
      color: scheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: scheme.onErrorContainer,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                parts.join(' · '),
                style: TextStyle(color: scheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionBar extends StatelessWidget {
  const _SelectionBar({
    required this.item,
    required this.onRotate,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.onClose,
    required this.onAdd,
  });

  final LayoutItem item;
  final VoidCallback onRotate;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback onClose;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget action(IconData icon, String label, VoidCallback onTap) => Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              const SizedBox(height: 2),
              Text(label, style: theme.textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );

    return Material(
      elevation: 8,
      color: theme.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Color(item.colorValue),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${item.name}  ·  ${formatSize(item.widthMm, item.depthMm)}  ·  ${item.rotationDeg.round()}°',
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  tooltip: '선택 해제',
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Row(
              children: [
                action(Icons.rotate_90_degrees_cw_outlined, '90° 회전', onRotate),
                action(Icons.straighten, '크기 수정', onEdit),
                action(Icons.copy_outlined, '복제', onDuplicate),
                action(Icons.delete_outline, '삭제', onDelete),
                if (onAdd != null)
                  action(Icons.add_box_outlined, '가구 추가', onAdd!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LayoutBar extends StatelessWidget {
  const _LayoutBar({
    required this.layouts,
    required this.selectedId,
    required this.onSelect,
    required this.onMenu,
    required this.onAdd,
  });

  final List<Layout> layouts;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final ValueChanged<Layout> onMenu;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          for (final l in layouts)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onLongPress: () => onMenu(l),
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l.name),
                      if (l.id == selectedId) ...[
                        const SizedBox(width: 2),
                        const Icon(Icons.expand_more, size: 16),
                      ],
                    ],
                  ),
                  selected: l.id == selectedId,
                  onSelected: (_) {
                    if (l.id == selectedId) {
                      onMenu(l);
                    } else {
                      onSelect(l.id);
                    }
                  },
                ),
              ),
            ),
          ActionChip(
            avatar: const Icon(Icons.add, size: 18),
            label: const Text('배치안'),
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}
