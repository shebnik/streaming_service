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
      return web;
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC6x8dxVw2tEXP7TPQ5uiguyRR0D3bqZoo',
    appId: '1:640023781180:web:547be15e9b810d245c0839',
    messagingSenderId: '640023781180',
    projectId: 'spotidemo-d2731',
    authDomain: 'spotidemo-d2731.firebaseapp.com',
    storageBucket: 'spotidemo-d2731.appspot.com',
    measurementId: 'G-3BDG045GHJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrz3bALutH7Z9uqyR84ya9aVVGNYL9Khc',
    appId: '1:640023781180:android:23632756333b3e2d5c0839',
    messagingSenderId: '640023781180',
    projectId: 'spotidemo-d2731',
    storageBucket: 'spotidemo-d2731.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC9xeQOOptAgUWXz7AkggcgY0LjxTFbCdA',
    appId: '1:640023781180:ios:1941c053956d37b05c0839',
    messagingSenderId: '640023781180',
    projectId: 'spotidemo-d2731',
    storageBucket: 'spotidemo-d2731.appspot.com',
    iosClientId: '640023781180-h2hkbfj0d372alrjdmrsq4c7ju7m0asl.apps.googleusercontent.com',
    iosBundleId: 'com.shebalin.spotidemo',
  );
}