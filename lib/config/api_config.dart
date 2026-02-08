class ApiConfig {
  ApiConfig._();

  static const String functionsBaseUrl =
      'https://asia-northeast1-hareru-c7a74.cloudfunctions.net';

  static const String parseReceiptUrl = '$functionsBaseUrl/parseReceipt';
  static const String generateInsightsUrl = '$functionsBaseUrl/generateInsights';
  static const String aiCoachUrl = '$functionsBaseUrl/aiCoach';
}
