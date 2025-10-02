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
    apiKey: 'AIzaSyDN0cesAmia-gDjGdK6SDiAY7pTMtcYZDM',
    appId: '1:535819918117:web:6a415c6d88c7543e4058cc',
    messagingSenderId: '535819918117',
    projectId: 'tastyhub-3f86e',
    authDomain: 'tastyhub-3f86e.firebaseapp.com',
    storageBucket: 'tastyhub-3f86e.firebasestorage.app',
    measurementId: 'G-EJVEC6W1LQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsRpz1lEeT94-DEfchwFNcXz76K6PD6wE',
    appId: '1:535819918117:android:ec27ee320bd289dc4058cc',
    messagingSenderId: '535819918117',
    projectId: 'tastyhub-3f86e',
    storageBucket: 'tastyhub-3f86e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDokrhC8UW6bmIcLHAD77_p1gFuk_8lL3c',
    appId: '1:535819918117:ios:e557a6a7f71980a34058cc',
    messagingSenderId: '535819918117',
    projectId: 'tastyhub-3f86e',
    storageBucket: 'tastyhub-3f86e.firebasestorage.app',
    iosBundleId: 'com.example.flutterTastyhub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDokrhC8UW6bmIcLHAD77_p1gFuk_8lL3c',
    appId: '1:535819918117:ios:e557a6a7f71980a34058cc',
    messagingSenderId: '535819918117',
    projectId: 'tastyhub-3f86e',
    storageBucket: 'tastyhub-3f86e.firebasestorage.app',
    iosBundleId: 'com.example.flutterTastyhub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDN0cesAmia-gDjGdK6SDiAY7pTMtcYZDM',
    appId: '1:535819918117:web:d4c5abdae783f1b84058cc',
    messagingSenderId: '535819918117',
    projectId: 'tastyhub-3f86e',
    authDomain: 'tastyhub-3f86e.firebaseapp.com',
    storageBucket: 'tastyhub-3f86e.firebasestorage.app',
    measurementId: 'G-4PRED1LRH0',
  );
}
