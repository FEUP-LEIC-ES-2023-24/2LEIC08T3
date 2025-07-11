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
    apiKey: 'AIzaSyCrvzBIpJn3KwH1lezDeUZpX3VvaFjIGIo',
    appId: '1:520988089739:web:9ffe51c17a806a9dfbe38e',
    messagingSenderId: '520988089739',
    projectId: 'greenscan-leic',
    authDomain: 'greenscan-leic.firebaseapp.com',
    storageBucket: 'greenscan-leic.appspot.com',
    measurementId: 'G-6N2ZLHWNHH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLXQdNEfUuGLv92dXsbWGAYDgFiRx4cEM',
    appId: '1:520988089739:android:56552ce969622d61fbe38e',
    messagingSenderId: '520988089739',
    projectId: 'greenscan-leic',
    storageBucket: 'greenscan-leic.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGg7-b2r0h5G3rxYjYbdvl7WMInSrUAlI',
    appId: '1:520988089739:ios:98bf61c15d46d835fbe38e',
    messagingSenderId: '520988089739',
    projectId: 'greenscan-leic',
    storageBucket: 'greenscan-leic.appspot.com',
    iosBundleId: 'com.example.greenscan',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCrvzBIpJn3KwH1lezDeUZpX3VvaFjIGIo',
    appId: '1:520988089739:web:b27ee65d2388ebbafbe38e',
    messagingSenderId: '520988089739',
    projectId: 'greenscan-leic',
    authDomain: 'greenscan-leic.firebaseapp.com',
    storageBucket: 'greenscan-leic.appspot.com',
    measurementId: 'G-8L1KTWD17X',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGg7-b2r0h5G3rxYjYbdvl7WMInSrUAlI',
    appId: '1:520988089739:ios:98bf61c15d46d835fbe38e',
    messagingSenderId: '520988089739',
    projectId: 'greenscan-leic',
    storageBucket: 'greenscan-leic.appspot.com',
    iosBundleId: 'com.example.greenscan',
  );

}