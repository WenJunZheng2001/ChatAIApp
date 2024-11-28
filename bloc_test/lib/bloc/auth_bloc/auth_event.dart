sealed class AuthEvent {}

class AuthRequestLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthRequestLoginEvent({required this.email, required this.password});
}

class AuthRequestRegistrationEvent extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;

  AuthRequestRegistrationEvent({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class AuthSendEmailVerificationEvent extends AuthEvent {}

class AuthResetPasswordEvent extends AuthEvent {
  final String email;

  AuthResetPasswordEvent({required this.email});
}

class AuthGoogleLoginEvent extends AuthEvent {}

class AuthSignOutEvent extends AuthEvent {}

class AuthAnonymousLoginEvent extends AuthEvent {}

class AuthChangePasswordEvent extends AuthEvent {}

class AuthDeleteAccountEvent extends AuthEvent {}
