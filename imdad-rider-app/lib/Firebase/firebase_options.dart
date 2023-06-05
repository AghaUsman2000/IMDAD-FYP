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
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD204zwt-pbZ5trvv28UqaMpXwmuPiLhgM',
    appId: '1:863523651566:web:d5baadb2ab2eef716d58ff',
    messagingSenderId: '863523651566',
    projectId: 'rizqbachao-b19fa',
    authDomain: 'rizqbachao-b19fa.firebaseapp.com',
    databaseURL: 'https://rizqbachao-b19fa-default-rtdb.firebaseio.com',
    storageBucket: 'rizqbachao-b19fa.appspot.com',
    measurementId: 'G-H5XK066K36',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_xaIA5YnFYiyZl_qECUuyDJVE7Ah5l1s',
    appId: '1:863523651566:android:c75b8a4fe39c5d326d58ff',
    messagingSenderId: '863523651566',
    projectId: 'rizqbachao-b19fa',
    databaseURL: 'https://rizqbachao-b19fa-default-rtdb.firebaseio.com',
    storageBucket: 'rizqbachao-b19fa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJti0hJUw-Sq1BzesbSmZpfN-5lXZChiY',
    appId: '1:863523651566:ios:e2dd325f33836f616d58ff',
    messagingSenderId: '863523651566',
    projectId: 'rizqbachao-b19fa',
    databaseURL: 'https://rizqbachao-b19fa-default-rtdb.firebaseio.com',
    storageBucket: 'rizqbachao-b19fa.appspot.com',
    iosClientId: '863523651566-n9pavcgp512m3hf9jpnp5431hncvo3ak.apps.googleusercontent.com',
    iosBundleId: 'com.example.riderApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAJti0hJUw-Sq1BzesbSmZpfN-5lXZChiY',
    appId: '1:863523651566:ios:e2dd325f33836f616d58ff',
    messagingSenderId: '863523651566',
    projectId: 'rizqbachao-b19fa',
    databaseURL: 'https://rizqbachao-b19fa-default-rtdb.firebaseio.com',
    storageBucket: 'rizqbachao-b19fa.appspot.com',
    iosClientId: '863523651566-n9pavcgp512m3hf9jpnp5431hncvo3ak.apps.googleusercontent.com',
    iosBundleId: 'com.example.riderApp',
  );
}