import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/providers.dart';
import '../pro/paywall_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(proStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: Text(isPro ? 'Pro 사용 중' : 'Pro 업그레이드'),
            subtitle: Text(
              isPro
                  ? '모든 기능이 해제되었습니다.'
                  : '${AppConstants.proPriceLabel} · 집 무제한 · 광고 제거 · 고화질 내보내기',
            ),
            onTap: isPro ? null : () => showPaywallSheet(context),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('구매 복원'),
            // TODO(step5): in_app_purchase restorePurchases()
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('결제 기능은 출시 전 연동 예정입니다.')),
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.straighten),
            title: Text('길이 단위'),
            subtitle: Text('mm (기본값)'),
          ),
          if (kDebugMode) ...[
            const Divider(),
            SwitchListTile(
              secondary: const Icon(Icons.bug_report_outlined),
              title: const Text('[개발용] Pro 상태 강제 전환'),
              value: isPro,
              onChanged: (v) =>
                  ref.read(proStatusProvider.notifier).debugSet(v),
            ),
          ],
          const Divider(),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: AppConstants.appName,
            applicationVersion: '0.1.0 (MVP 개발 중)',
          ),
        ],
      ),
    );
  }
}
