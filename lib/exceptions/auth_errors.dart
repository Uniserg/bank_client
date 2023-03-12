class AuthTimeoutException implements Exception {
  String cause;
  AuthTimeoutException(this.cause);
}