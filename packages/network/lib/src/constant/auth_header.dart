class AuthHeader {
  static const String requiredAuth = 'required-auth';
  static const String apikey = 'apikey';
  static const String authorization = 'authorization';
  static const String authApikey = 'auth-apikey';

  static const Map<String, String> requiredApikey = {requiredAuth: apikey};
  static const Map<String, String> requiredAuthorization = {requiredAuth: authorization};
  static const Map<String, String> requiredAuthApikey = {requiredAuth: authApikey};
}