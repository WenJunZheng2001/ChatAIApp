// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhNlGPlIoWjFbtDmAwfNxKxSopxr9s_ZY',
    appId: '1:84361781207:android:c2abad96e062e94fbb7592',
    messagingSenderId: '84361781207',
    projectId: 'lisamobile-96257',
    databaseURL: 'https://lisamobile-96257-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'lisamobile-96257.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArHlDzePCkGAFC294g3LkXsz0VrkG_xwA',
    appId: '1:84361781207:ios:2d477fff8b191798bb7592',
    messagingSenderId: '84361781207',
    projectId: 'lisamobile-96257',
    databaseURL: 'https://lisamobile-96257-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'lisamobile-96257.appspot.com',
    androidClientId: '84361781207-7mbva6g2gitel2va1s4cmngcf14di9i3.apps.googleusercontent.com',
    iosClientId: '84361781207-h03n785auccudsljpmlc98j3lp80b4cn.apps.googleusercontent.com',
    iosBundleId: 'com.example.blocTest',
  );
}