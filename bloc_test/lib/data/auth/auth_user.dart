import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String uid;
  final String? username;
  final String? photoUrl;
  final String? email;

  const AuthUser(
      {required this.isEmailVerified,
      required this.uid,
      this.username,
      this.photoUrl,
      this.email});

  factory AuthUser.fromFirebase(User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        uid: user.uid,
        username: user.displayName,
        photoUrl: user.photoURL,
        email: user.email,
      );
}
