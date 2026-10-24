import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/providers.dart';

/// 결제 유도 사유 (PRD 3-1장 Paywall 노출 시점).
enum PaywallReason {
  homeLimit('무료 버전은 집을 ${AppConstants.freeHomeLimit}개까지 만들 수 있어요.'),
  customFurnitureLimit(
    '무료 버전은 내 가구를 ${AppConstants.freeCustomFurnitureLimit}개까지 저장할 수 있어요.',
  ),
  hdExport('워터마크 없는 고화질 내보내기는 Pro 기능이에요.'),
  general('');

  const PaywallReason(this.message);
  final String message;
}

Future<void> showPaywallSheet(
  BuildContext context, {
  PaywallReason reason = PaywallReason.general,
}) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (_) => _PaywallSheet(reason: reason),
);

class _PaywallSheet extends ConsumerStatefulWidget {
  const _PaywallSheet({required this.reason});

  final PaywallReason reason;

  @override
  ConsumerState<_PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends ConsumerState<_PaywallSheet> {
  bool _busy = false;

  Future<void> _onBuyPressed() async {
    setState(() => _busy = true);
    final err = await ref.read(purchaseServiceProvider).buyPro();
    if (!mounted) return;
    setState(() => _busy = false);
    if (err != null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPro = ref.watch(proStatusProvider);
    if (isPro) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && Navigator.canPop(context)) Navigator.pop(context);
      });
    }
    const benefits = [
      (Icons.home_work_outlined, '집(도면) 무제한', '후보 집 A·B·C를 나란히 비교'),
      (Icons.block, '광고 제거', '모든 화면에서 광고 없이'),
      (Icons.high_quality_outlined, '고화질 내보내기', '워터마크 없는 이미지 · PDF'),
      (Icons.chair_outlined, '내 가구 무제한 저장', '자주 쓰는 가구를 모두 보관'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${AppConstants.appName} Pro',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          if (widget.reason.message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.reason.message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          for (final (icon, title, desc) in benefits)
            ListTile(
              leading: Icon(icon, color: theme.colorScheme.primary),
              title: Text(title),
              subtitle: Text(desc),
              dense: true,
            ),
          const SizedBox(height: 8),
          Text(
            '배치안은 무료에서도 무제한이에요.',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _onBuyPressed,
            child: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    '${AppConstants.proPriceLabel} · 한 번 결제로 평생 사용',
                  ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('나중에'),
          ),
        ],
      ),
    );
  }
}
