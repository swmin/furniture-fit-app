/// 앱 전역 상수.
abstract final class AppConstants {
  static const appName = '가구들어갈까';

  /// 무료 사용자 제한 (PRD 3-1장).
  static const freeHomeLimit = 1;
  static const freeCustomFurnitureLimit = 10;

  /// Pro 인앱 상품 (비소모성).
  static const proProductId = 'pro_unlock';
  static const proPriceLabel = '₩3,900';

  /// AdMob 광고 단위 ID (기본값: Google 공식 Android 테스트 광고 단위 ID).
  static const androidTestBannerUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const androidTestRewardedUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  /// 빈 방 직접 만들기 입력 범위 (mm).
  static const minRoomMm = 500;
  static const maxRoomMm = 30000;
}
