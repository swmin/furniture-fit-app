import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';

/// Google Play Billing (`pro_unlock` 비소모성 1회 결제) 및 로컬 Pro 상태 관리.
class PurchaseService {
  PurchaseService({InAppPurchase? iap}) {
    _iap = iap;
  }

  InAppPurchase? _iap;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  static const _prefsKeyPro = 'furniturefit.is_pro';

  /// 저장된 Pro 구매 여부를 불러온다.
  Future<bool> loadProStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKeyPro) ?? false;
  }

  /// 로컬에 Pro 구매 여부를 저장한다.
  Future<void> saveProStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyPro, value);
  }

  /// 결제 스트림을 구독해 구매/복원 완료 시 [onProUnlocked]를 호출한다.
  Future<void> listen(ValueChanged<bool> onProUnlocked) async {
    try {
      final iap = _iap ??= InAppPurchase.instance;
      final available = await iap.isAvailable();
      if (!available) return;
      await _sub?.cancel();
      _sub = iap.purchaseStream.listen(
        (purchases) async {
          for (final p in purchases) {
            if (p.productID != AppConstants.proProductId) continue;
            if (p.status == PurchaseStatus.purchased ||
                p.status == PurchaseStatus.restored) {
              await saveProStatus(true);
              onProUnlocked(true);
            }
            if (p.pendingCompletePurchase) {
              await iap.completePurchase(p);
            }
          }
        },
        onError: (_) {},
      );
    } catch (_) {
      // 테스트 환경이나 스토어 미설치 기기에서도 앱이 정상 동작하도록 무시
    }
  }

  /// `pro_unlock` 비소모성 상품 구매 요청.
  /// 반환값: 사용자에게 안내할 결과 메시지 (성공적으로 결제창이 열리면 null).
  Future<String?> buyPro() async {
    try {
      final iap = _iap ??= InAppPurchase.instance;
      final available = await iap.isAvailable();
      if (!available) {
        return '현재 기기에서 Google Play 결제를 사용할 수 없습니다.';
      }
      final resp = await iap.queryProductDetails({AppConstants.proProductId});
      if (resp.productDetails.isEmpty) {
        return '스토어에 "${AppConstants.proProductId}" 상품이 아직 등록되지 않았습니다. '
            '(개발 중에는 설정 → [개발용] Pro 상태 강제 전환을 사용하세요)';
      }
      final product = resp.productDetails.first;
      final param = PurchaseParam(productDetails: product);
      await iap.buyNonConsumable(purchaseParam: param);
      return null;
    } catch (e) {
      return '결제 요청 중 오류가 발생했습니다: $e';
    }
  }

  /// 이전 구매 내역 복원 요청.
  Future<String> restorePurchases() async {
    try {
      final iap = _iap ??= InAppPurchase.instance;
      final available = await iap.isAvailable();
      if (!available) {
        return 'Google Play 스토어에 연결할 수 없습니다.';
      }
      await iap.restorePurchases();
      return '구매 복원을 요청했습니다. 구매 내역이 확인되면 Pro가 자동 활성화됩니다.';
    } catch (e) {
      return '구매 복원 중 오류가 발생했습니다: $e';
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
  }
}
