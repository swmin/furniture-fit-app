import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants.dart';
import '../../core/providers.dart';

/// AdMob 초기화 및 보상형 광고 도우미.
abstract final class AdMobService {
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    if (!Platform.isAndroid && !Platform.isIOS) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
    } catch (_) {
      // 단위 테스트 환경 등에서 플랫폼 채널 미지원 시 무시
    }
  }

  /// 보상형 광고를 로드해 재생하고, 끝까지 시청하면 `true`를 반환한다.
  static Future<bool> showRewardedForHdExport(BuildContext context) async {
    if (!Platform.isAndroid && !Platform.isIOS) return false;
    await ensureInitialized();
    final completer = Completer<bool>();
    var rewarded = false;

    await RewardedAd.load(
      adUnitId: AppConstants.androidTestRewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete(rewarded);
            },
            onAdFailedToShowFullScreenContent: (ad, _) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete(false);
            },
          );
          ad.show(
            onUserEarnedReward: (_, _) {
              rewarded = true;
            },
          );
        },
        onAdFailedToLoad: (_) {
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );
    return completer.future;
  }
}

/// 무료 사용자에게만 홈/라이브러리 하단에 노출되는 배너 광고 바.
///
/// PRD 원칙:
/// - Pro 사용자는 완전히 숨김.
/// - 배치 편집 화면(`EditorScreen`)에는 절대 배치하지 않음.
class AdBannerBar extends ConsumerStatefulWidget {
  const AdBannerBar({super.key});

  @override
  ConsumerState<AdBannerBar> createState() => _AdBannerBarState();
}

class _AdBannerBarState extends ConsumerState<AdBannerBar> {
  BannerAd? _banner;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadIfNeeded();
  }

  Future<void> _loadIfNeeded() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    await AdMobService.ensureInitialized();
    if (!mounted || ref.read(proStatusProvider)) return;
    final ad = BannerAd(
      size: AdSize.banner,
      adUnitId: AppConstants.androidTestBannerUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _banner = null;
              _loaded = false;
            });
          }
        },
      ),
    );
    _banner = ad;
    await ad.load();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(proStatusProvider);
    if (isPro) return const SizedBox.shrink();
    final ad = _banner;
    if (!_loaded || ad == null) return const SizedBox.shrink();
    return SafeArea(
      top: false,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: SizedBox(
          width: double.infinity,
          height: ad.size.height.toDouble(),
          child: Center(
            child: SizedBox(
              width: ad.size.width.toDouble(),
              height: ad.size.height.toDouble(),
              child: AdWidget(ad: ad),
            ),
          ),
        ),
      ),
    );
  }
}
