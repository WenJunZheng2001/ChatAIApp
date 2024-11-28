// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions

class GenericAuthException implements Exception {}

class UserNotLoggerInAuthException implements Exception {}

class GoogleLoginFailedException implements Exception {}

class MissingEmailAuthException implements Exception {}

class TokenNotValidAuthException implements Exception {}

class FailedSendingEmailVerificationException implements Exception {}

class FailedDeletingAccountException implements Exception {}
