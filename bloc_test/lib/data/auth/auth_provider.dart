import 'package:firebase_auth/firebase_auth.dart';

import 'auth_user.dart';

abstract class MyAuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> resetPassword({required String email});

  Future<UserCredential> googleLogin();
  Future<String> getIdToken();

  Future<void> anonymousLogin();

  Future<void> changePassword();

  Future<void> deleteAccount();
}
