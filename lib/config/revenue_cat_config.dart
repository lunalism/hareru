class RevenueCatConfig {
  RevenueCatConfig._();

  static const String appleApiKey = String.fromEnvironment(
    'REVENUE_CAT_APPLE_API_KEY',
    defaultValue: '',
  );
  static const String googleApiKey = String.fromEnvironment(
    'REVENUE_CAT_GOOGLE_API_KEY',
    defaultValue: '',
  );

  // Entitlement IDs
  static const String clearEntitlement = 'hareru_clear';
  static const String clearProEntitlement = 'hareru_clearpro';

  // Product IDs (App Store Connect / Google Play Console에서 생성 후 매칭)
  static const String clearMonthly = 'hareru_clear_monthly';
  static const String clearYearly = 'hareru_clear_yearly';
  static const String clearProMonthly = 'hareru_clearpro_monthly';
  static const String clearProYearly = 'hareru_clearpro_yearly';
}
