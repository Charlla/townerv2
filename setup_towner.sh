#!/bin/bash

# Create project structure
mkdir -p lib/{app,services,models,providers,screens/{auth,marketplace,community,insights},widgets,utils}

# Create necessary files
touch lib/app/{app.dart,routes.dart}
touch lib/services/{auth_service.dart,firestore_service.dart,storage_service.dart}
touch lib/models/user_model.dart
touch lib/providers/auth_provider.dart
touch lib/screens/auth/{login_screen.dart,register_screen.dart}
touch lib/screens/{home_screen.dart,marketplace/marketplace_screen.dart,community/community_screen.dart,insights/insights_screen.dart}
touch lib/widgets/{chat_interface.dart,custom_app_bar.dart}
touch lib/utils/{constants.dart,theme.dart}

# Update pubspec.yaml
cat << EOF > pubspec.yaml
name: towner
description: A hyper-local community superapp powered by AI.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.5
  firebase_core: ^2.13.0
  firebase_auth: ^4.6.2
  cloud_firestore: ^4.7.1
  firebase_storage: ^11.2.1
  google_generative_ai: ^0.2.0
  provider: ^6.0.5
  flutter_svg: ^2.0.5
  google_fonts: ^4.0.4
  intl: ^0.18.1
  geolocator: ^9.0.2
  image_picker: ^0.8.7+5
  flutter_tts: ^3.7.0
  speech_to_text: ^6.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.1

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
EOF

# Install dependencies
flutter pub get

# Create a placeholder for Firebase configuration
cat << EOF > lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_AUTH_DOMAIN',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    measurementId: 'YOUR_MEASUREMENT_ID',
  );
}
EOF

echo "Project structure created and dependencies installed."
echo "Please replace the placeholder values in lib/firebase_options.dart with your actual Firebase configuration."
echo "To set up Firebase, follow these steps:"
echo "1. Install the Firebase CLI: npm install -g firebase-tools"
echo "2. Login to Firebase: firebase login"
echo "3. Initialize Firebase in your project: firebase init"
echo "4. Configure Firebase for Flutter: flutterfire configure"
EOF

chmod +x setup_towner.sh