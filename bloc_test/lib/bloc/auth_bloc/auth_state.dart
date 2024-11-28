abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoginSuccessState extends AuthState {}

class AuthRegistrationSuccessState extends AuthState {}

class AuthSentPasswordResetSuccessState extends AuthState {}

class AuthLogoutSuccessState extends AuthState {}

class AuthGenericFailState extends AuthState {
  final String error;
  AuthGenericFailState(this.error);
}

class AuthFailedSendResetPasswordState extends AuthState {
  final String error;
  AuthFailedSendResetPasswordState(this.error);
}

class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState(this.error);
}

class AuthLoadingState extends AuthState {}

class AuthEmailInvalidState extends AuthState {}

class AuthSuccessDeletedAccountState extends AuthState {}
