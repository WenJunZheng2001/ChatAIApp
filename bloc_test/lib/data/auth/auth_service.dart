import 'package:firebase_auth/firebase_auth.dart';

import 'auth_provider.dart';
import 'auth_user.dart';
import 'firebase_auth_provider.dart';

class AuthService implements MyAuthProvider {
  final MyAuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> resetPassword({required String email}) =>
      provider.resetPassword(email: email);

  @override
  Future<UserCredential> googleLogin() => provider.googleLogin();

  @override
  Future<String> getIdToken() => provider.getIdToken();

  @override
  Future<void> anonymousLogin() => provider.anonymousLogin();

  @override
  Future<void> changePassword() => provider.changePassword();

  @override
  Future<void> deleteAccount() => provider.deleteAccount();
}
