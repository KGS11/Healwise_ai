// File: lib/core/constants/firebase_options.dart
// 
// This file is a placeholder to allow the project to compile.
// In a real-world scenario, you should configure Firebase using the FlutterFire CLI:
//   $ dart pub global activate flutterfire_cli
//   $ flutterfire configure
// 
// That will generate the actual Firebase configurations and overwrite this file.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBl6paOlhq2jWzhFV5A7NNjy6Ki08FAyVE',
    appId: '1:818309041793:web:90f10da0c2821e76fe0780',
    messagingSenderId: '818309041793',
    projectId: 'healwise-ai-cb662',
    authDomain: 'healwise-ai-cb662.firebaseapp.com',
    storageBucket: 'healwise-ai-cb662.firebasestorage.app',
    measurementId: 'G-8SQK62FT1K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSQOT3W_gBtjoQBzDlfFlTCjif_iZ9mw0',
    appId: '1:818309041793:android:bd851b9587e57387fe0780',
    messagingSenderId: '818309041793',
    projectId: 'healwise-ai-cb662',
    storageBucket: 'healwise-ai-cb662.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'placeholder-api-key-ios',
    appId: 'placeholder-app-id-ios',
    messagingSenderId: 'placeholder-sender-id',
    projectId: 'healwise-ai-placeholder',
    storageBucket: 'healwise-ai-placeholder.appspot.com',
    iosBundleId: 'com.example.healwiseAi',
  );
}