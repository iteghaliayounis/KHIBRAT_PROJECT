// File generated for Firebase project khibrat-fcm (FlutterFire-compatible).
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwVerhc-WHdZCyup-5hkUJ34WLloif5GE',
    appId: '1:1068960230140:android:ceeb8bef6976ade219c579',
    messagingSenderId: '1068960230140',
    projectId: 'khibrat-fcm',
    storageBucket: 'khibrat-fcm.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-6VztdAeXuzJfPWIlV0MY_msJBSxTX7Y',
    appId: '1:1068960230140:ios:013ca2acce2a5fb119c579',
    messagingSenderId: '1068960230140',
    projectId: 'khibrat-fcm',
    storageBucket: 'khibrat-fcm.firebasestorage.app',
    iosBundleId: 'com.example.khibratFlutter2',
  );
}
