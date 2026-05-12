import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'config/routes/app_pages.dart';
import 'config/themes/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Obligatoire avant Firebase : Flutter doit initialiser ses bindings
  // avant d'utiliser des plugins comme firebase_core.
  WidgetsFlutterBinding.ensureInitialized();

  // Connecte l'application au projet Firebase configuré par FlutterFire.
  // Sans cette ligne, FirebaseAuth et Firestore ne peuvent pas fonctionner.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp donne accès aux routes GetX, aux bindings,
    // aux dialogs Get.dialog et aux snackbars Get.snackbar.
    return GetMaterialApp(
      title: 'Firebase Auth GetX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // La première route visible est /account : la page avec le bouton Compte.
      initialRoute: AppPages.initial,

      // Toutes les pages et leurs controllers sont déclarés dans AppPages.
      getPages: AppPages.pages,
    );
  }
}
