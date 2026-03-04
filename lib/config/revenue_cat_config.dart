class RevenueCatConfig {
  RevenueCatConfig._();

  // TODO: Apple Developer 등록 후 iOS 앱 추가하면 발급되는 키로 교체
  static const String appleApiKey = 'test_KnnDlqlYSSWrSvbexoUHPYdHink';
  // TODO: Google Play Console 연결 후 발급되는 키로 교체
  static const String googleApiKey = 'goog_PLACEHOLDER_KEY';

  // Entitlement IDs
  static const String clearEntitlement = 'hareru_clear';
  static const String clearProEntitlement = 'hareru_clearpro';

  // Product IDs (App Store Connect / Google Play Console에서 생성 후 매칭)
  static const String clearMonthly = 'hareru_clear_monthly';
  static const String clearYearly = 'hareru_clear_yearly';
  static const String clearProMonthly = 'hareru_clearpro_monthly';
  static const String clearProYearly = 'hareru_clearpro_yearly';
}
