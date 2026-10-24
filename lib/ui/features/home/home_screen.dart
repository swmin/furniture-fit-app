import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants.dart';
import '../../../core/providers.dart';
import '../../../core/units.dart';
import '../../../data/repositories/home_repository.dart';
import '../pro/paywall_sheet.dart';
import 'create_home_sheet.dart';

/// 홈: 내 집 목록.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaries = ref.watch(homeSummariesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: '가구 라이브러리',
            icon: const Icon(Icons.chair_outlined),
            onPressed: () => context.push('/library'),
          ),
          IconButton(
            tooltip: '설정',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: summaries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('불러오기 실패: $e')),
        data: (items) => items.isEmpty
            ? const _EmptyState()
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) => _HomeCard(summary: items[i]),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onCreatePressed(context, ref),
        icon: const Icon(Icons.add_home_outlined),
        label: const Text('새 집 만들기'),
      ),
      // TODO(step5): 무료 사용자 하단 배너 광고 영역
    );
  }

  Future<void> _onCreatePressed(BuildContext context, WidgetRef ref) async {
    final isPro = ref.read(proStatusProvider);
    final count = await ref.read(homeRepositoryProvider).countHomes();
    if (!context.mounted) return;

    if (!isPro && count >= AppConstants.freeHomeLimit) {
      await showPaywallSheet(context, reason: PaywallReason.homeLimit);
      return;
    }
    final result = await showCreateHomeSheet(context);
    if (result != null && context.mounted) {
      context.push('/homes/${result.homeId}');
      if (result.needsCalibration) {
        context.push('/homes/${result.homeId}/calibrate');
      }
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.weekend_outlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              '이 가구, 우리 집에 들어갈까?',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '도면 사진이나 방 크기로 집을 만들고\n가구를 mm 단위로 미리 배치해 보세요.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends ConsumerWidget {
  const _HomeCard({required this.summary});

  final HomeSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = summary.home;
    final theme = Theme.of(context);
    final hasRoom = home.roomWidthMm != null && home.roomDepthMm != null;
    final subtitle = [
      if (hasRoom) formatSize(home.roomWidthMm!, home.roomDepthMm!),
      if (hasRoom) formatArea(home.roomWidthMm!, home.roomDepthMm!),
      if (home.floorPlanPath != null) '도면',
      '배치안 ${summary.layoutCount}개',
    ].join(' · ');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/homes/${home.id}'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  home.floorPlanPath != null
                      ? Icons.map_outlined
                      : Icons.crop_square,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      home.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                    Text(
                      '수정 ${DateFormat('yyyy.MM.dd HH:mm').format(home.updatedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_HomeAction>(
                onSelected: (a) => _onAction(context, ref, a),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: _HomeAction.rename,
                    child: Text('이름 변경'),
                  ),
                  PopupMenuItem(value: _HomeAction.delete, child: Text('삭제')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onAction(
    BuildContext context,
    WidgetRef ref,
    _HomeAction action,
  ) async {
    final repo = ref.read(homeRepositoryProvider);
    final home = summary.home;
    switch (action) {
      case _HomeAction.rename:
        final name = await _askName(context, home.name);
        if (name != null) await repo.renameHome(home.id, name);
      case _HomeAction.delete:
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('집 삭제'),
            content: Text('"${home.name}"과(와) 모든 배치안이 삭제됩니다.'),
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
        if (ok == true) await repo.deleteHome(home.id);
    }
  }

  Future<String?> _askName(BuildContext context, String initial) {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('이름 변경'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 60,
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
}

enum _HomeAction { rename, delete }
