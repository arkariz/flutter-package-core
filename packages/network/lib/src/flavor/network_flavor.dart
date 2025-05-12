abstract class NetworkFlavor {
  String get baseUrl;
  String get apikey;
  String? get accessToken;
  Duration get connectTimeout;
  Duration get receiveTimeout;
  String get appVersion;

  Future<void> setAccessToken(String token);
  Future<void> onTokenExpired();
}