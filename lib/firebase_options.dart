import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDCz3XRLmC5DEu7-ha8aVXQrvShPshIm-c',
    appId: '1:398395997799:web:45dd327ac5283022e9dec2',
    messagingSenderId: '398395997799',
    projectId: 'townerv2',
    authDomain: 'townerv2.firebaseapp.com',
    storageBucket: 'townerv2.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZPgqJMMoJxJ-le4P_C1aJd-ZW8zBsHlM',
    appId: '1:398395997799:ios:782a1ba015c74897e9dec2',
    messagingSenderId: '398395997799',
    projectId: 'townerv2',
    storageBucket: 'townerv2.appspot.com',
    iosBundleId: 'com.example.towner',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZPgqJMMoJxJ-le4P_C1aJd-ZW8zBsHlM',
    appId: '1:398395997799:ios:782a1ba015c74897e9dec2',
    messagingSenderId: '398395997799',
    projectId: 'townerv2',
    storageBucket: 'townerv2.appspot.com',
    iosBundleId: 'com.example.towner',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJEw66bHI-35JBtsc5XQINBhTKpVMc_lw',
    appId: '1:398395997799:android:8f765e0a3fbaeb77e9dec2',
    messagingSenderId: '398395997799',
    projectId: 'townerv2',
    storageBucket: 'townerv2.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDCz3XRLmC5DEu7-ha8aVXQrvShPshIm-c',
    appId: '1:398395997799:web:1f21803063021ae8e9dec2',
    messagingSenderId: '398395997799',
    projectId: 'townerv2',
    authDomain: 'townerv2.firebaseapp.com',
    storageBucket: 'townerv2.appspot.com',
  );

}