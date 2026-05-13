import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

// Fichier généré par FlutterFire CLI.
// Il contient les clés de configuration qui relient l'app Flutter
// au projet Firebase sélectionné.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Dans ce projet, on a configuré uniquement la plateforme web.
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Firebase options are not configured yet. Run flutterfire configure.',
        );
      default:
        throw UnsupportedError(
          'Firebase options are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    // Ces valeurs identifient l'application web dans Firebase.
    apiKey: 'AIzaSyDZNWfVC8VgztslIRcg4Bugiq3kzf_Lomc',
    appId: '1:382319820205:web:a238f4faccaad4decb7524',
    messagingSenderId: '382319820205',
    projectId: 'fir-flutter-web-getx',
    authDomain: 'fir-flutter-web-getx.firebaseapp.com',
    storageBucket: 'fir-flutter-web-getx.firebasestorage.app',
    measurementId: 'G-MGYXQ3ZGS6',
  );
}
