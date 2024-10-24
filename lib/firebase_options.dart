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
    apiKey: 'AIzaSyBYxxGafxBFhrta3QRNvefsHZ5XRGY0bBQ',
    appId: '1:254035016391:web:127780d9ad3f456380dce2',
    messagingSenderId: '254035016391',
    projectId: 'docy-f5275',
    authDomain: 'docy-f5275.firebaseapp.com',
    storageBucket: 'docy-f5275.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxgd6k-xjvePog_NvpHSdSGFirbmBoUIk',
    appId: '1:254035016391:android:69f9440d0e2a949280dce2',
    messagingSenderId: '254035016391',
    projectId: 'docy-f5275',
    storageBucket: 'docy-f5275.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkjmc4d0ozDVaR6tu1UJYV5fJpcbidrXw',
    appId: '1:254035016391:ios:f60372db7fd2678980dce2',
    messagingSenderId: '254035016391',
    projectId: 'docy-f5275',
    storageBucket: 'docy-f5275.appspot.com',
    iosBundleId: 'com.example.docy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBkjmc4d0ozDVaR6tu1UJYV5fJpcbidrXw',
    appId: '1:254035016391:ios:f60372db7fd2678980dce2',
    messagingSenderId: '254035016391',
    projectId: 'docy-f5275',
    storageBucket: 'docy-f5275.appspot.com',
    iosBundleId: 'com.example.docy',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBYxxGafxBFhrta3QRNvefsHZ5XRGY0bBQ',
    appId: '1:254035016391:web:24b969358871a44980dce2',
    messagingSenderId: '254035016391',
    projectId: 'docy-f5275',
    authDomain: 'docy-f5275.firebaseapp.com',
    storageBucket: 'docy-f5275.appspot.com',
  );
}
