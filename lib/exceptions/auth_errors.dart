class NoAuthException implements Exception {
  String cause;
  NoAuthException(this.cause);
}

class ForbiddenException implements Exception {
  String cause;
  ForbiddenException(this.cause);
}
