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
    apiKey: 'AIzaSyC0Eh2Ig8PeGxO-Z5PYRws0FBGES9XTl4w',
    appId: '1:786099462074:web:73320a136b99f68d444783',
    messagingSenderId: '786099462074',
    projectId: 'catatan-ed683',
    authDomain: 'catatan-ed683.firebaseapp.com',
    storageBucket: 'catatan-ed683.appspot.com',
    measurementId: 'G-20CEH9VTR9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5iD1pYtHWb-GpGFiuc8_Cx26f3PwBYzU',
    appId: '1:786099462074:android:9928ee04e9c18d1c444783',
    messagingSenderId: '786099462074',
    projectId: 'catatan-ed683',
    storageBucket: 'catatan-ed683.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAbSQEmp3u73rMkB_Y3kjtcf2L-tNgViek',
    appId: '1:786099462074:ios:2e9669794322fb13444783',
    messagingSenderId: '786099462074',
    projectId: 'catatan-ed683',
    storageBucket: 'catatan-ed683.appspot.com',
    iosClientId: '786099462074-o3acl4js5dhjbsc61quo18itci2a6t3l.apps.googleusercontent.com',
    iosBundleId: 'com.example.catatan',
  );
}
