// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBksDphnlNWSXPRTrpdx4EjiUzykVV1fB8',
    appId: '1:32929408261:android:8b9adcdff83167aa77c36c',
    messagingSenderId: '32929408261',
    projectId: 'test-flutter-mynotes-e9f1c',
    storageBucket: 'test-flutter-mynotes-e9f1c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCN1oSivg1KM3eZJN50jF2AE3yw84L0uVs',
    appId: '1:32929408261:ios:6c7aff71f915519177c36c',
    messagingSenderId: '32929408261',
    projectId: 'test-flutter-mynotes-e9f1c',
    storageBucket: 'test-flutter-mynotes-e9f1c.firebasestorage.app',
    iosBundleId: 'nl.bitfactory.testFlutterMyNotes',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCupDIpIEHDbwI-vZX62uaIO5o7yldVxaE',
    appId: '1:32929408261:web:d396aad9e7076dd277c36c',
    messagingSenderId: '32929408261',
    projectId: 'test-flutter-mynotes-e9f1c',
    authDomain: 'test-flutter-mynotes-e9f1c.firebaseapp.com',
    storageBucket: 'test-flutter-mynotes-e9f1c.firebasestorage.app',
    measurementId: 'G-906PQE0RJ1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCN1oSivg1KM3eZJN50jF2AE3yw84L0uVs',
    appId: '1:32929408261:ios:6c7aff71f915519177c36c',
    messagingSenderId: '32929408261',
    projectId: 'test-flutter-mynotes-e9f1c',
    storageBucket: 'test-flutter-mynotes-e9f1c.firebasestorage.app',
    iosBundleId: 'nl.bitfactory.testFlutterMyNotes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCupDIpIEHDbwI-vZX62uaIO5o7yldVxaE',
    appId: '1:32929408261:web:0a189a11047c2be377c36c',
    messagingSenderId: '32929408261',
    projectId: 'test-flutter-mynotes-e9f1c',
    authDomain: 'test-flutter-mynotes-e9f1c.firebaseapp.com',
    storageBucket: 'test-flutter-mynotes-e9f1c.firebasestorage.app',
    measurementId: 'G-B3HGB81E87',
  );
}
