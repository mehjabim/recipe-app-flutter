import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDDG-L2lQwZRlKPMpZ4AyQA_HNvO5orOlw',
    appId: '1:782727628864:web:f1c0156ffbc93f59bb37a5',
    messagingSenderId: '782727628864',
    projectId: 'flutter-recipe-f86a9',
    authDomain: 'flutter-recipe-f86a9.firebaseapp.com',
    databaseURL: 'https://flutter-recipe-f86a9-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-recipe-f86a9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8Vi_ES5K5bg-M9RAOzgRCVkn_rGTotMY',
    appId: '1:782727628864:android:a98867c1caa0360dbb37a5',
    messagingSenderId: '782727628864',
    projectId: 'flutter-recipe-f86a9',
    databaseURL: 'https://flutter-recipe-f86a9-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-recipe-f86a9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxpR6TY9qeY-JGZfIlCUE2EaB8M_HkE4s',
    appId: '1:782727628864:ios:933690d23a2c5400bb37a5',
    messagingSenderId: '782727628864',
    projectId: 'flutter-recipe-f86a9',
    databaseURL: 'https://flutter-recipe-f86a9-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-recipe-f86a9.appspot.com',
    iosBundleId: 'com.example.recipe_app3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDxpR6TY9qeY-JGZfIlCUE2EaB8M_HkE4s',
    appId: '1:782727628864:ios:933690d23a2c5400bb37a5',
    messagingSenderId: '782727628864',
    projectId: 'flutter-recipe-f86a9',
    databaseURL: 'https://flutter-recipe-f86a9-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-recipe-f86a9.appspot.com',
    iosBundleId: 'com.example.recipe_app3',
  );
}
