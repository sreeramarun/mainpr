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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBnS913s-oOVQTNEHqlDixS9S-BZaY47VI',
    appId: '1:71811968117:web:b5dadb466fbb008402dc3c',
    messagingSenderId: '71811968117',
    projectId: 'vtu-event-management-system',
    authDomain: 'vtu-event-management-system.firebaseapp.com',
    storageBucket: 'vtu-event-management-system.appspot.com',
    measurementId: 'G-PD1679YHJG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqL2zvsbm9Dc19wLT0Zh_vml41ynWe6oU',
    appId: '1:71811968117:android:441c12bf0c494c7d02dc3c',
    messagingSenderId: '71811968117',
    projectId: 'vtu-event-management-system',
    storageBucket: 'vtu-event-management-system.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxuRbhLDLI6mlBUqa5DltOFuK9MOpBTvw',
    appId: '1:71811968117:ios:0f1a88481f95e45802dc3c',
    messagingSenderId: '71811968117',
    projectId: 'vtu-event-management-system',
    storageBucket: 'vtu-event-management-system.appspot.com',
    iosBundleId: 'com.example.event',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAxuRbhLDLI6mlBUqa5DltOFuK9MOpBTvw',
    appId: '1:71811968117:ios:0f1a88481f95e45802dc3c',
    messagingSenderId: '71811968117',
    projectId: 'vtu-event-management-system',
    storageBucket: 'vtu-event-management-system.appspot.com',
    iosBundleId: 'com.example.event',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBnS913s-oOVQTNEHqlDixS9S-BZaY47VI',
    appId: '1:71811968117:web:c312b5b3bd05f4f402dc3c',
    messagingSenderId: '71811968117',
    projectId: 'vtu-event-management-system',
    authDomain: 'vtu-event-management-system.firebaseapp.com',
    storageBucket: 'vtu-event-management-system.appspot.com',
    measurementId: 'G-M3ZPXHY1J3',
  );
}
