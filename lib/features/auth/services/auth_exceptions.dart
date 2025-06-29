class AuthFailedToRegister implements Exception {
  final String description;

  AuthFailedToRegister(this.description);

  @override
  String toString() => description;
}

class AuthInvalidCredentialsException implements Exception {
  final String description;

  AuthInvalidCredentialsException(this.description);

  @override
  String toString() => description;
}

class AuthInvalidEmailFormatException implements Exception {
  final String description;

  AuthInvalidEmailFormatException(this.description);

  @override
  String toString() => description;
}

// generic
class AuthFailedToLoginException implements Exception {
  final String description;

  AuthFailedToLoginException(this.description);

  @override
  String toString() => description;
}
