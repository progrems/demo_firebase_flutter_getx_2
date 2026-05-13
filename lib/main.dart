import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/config/app_build/app_build.dart';
import 'app/config/firebase_connexion/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    debugPrint('Erreur lors de l’initialisation Firebase: $error');
  }

  runApp(const AppBuild());
}
