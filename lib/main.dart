import 'package:demo_firebase_flutter_getx_2/app/config/app_build/app_build.dart';
import 'package:demo_firebase_flutter_getx_2/app/config/firebase_connexion/firebase_options.dart';
import 'package:demo_firebase_flutter_getx_2/app/config/lang/translation.dart';
import 'package:demo_firebase_flutter_getx_2/app/config/routes/app_routes.dart';
import 'package:demo_firebase_flutter_getx_2/app/config/themes/app_theme.dart';
import 'package:demo_firebase_flutter_getx_2/app/constans/app_constans.dart';
import 'package:demo_firebase_flutter_getx_2/app/utils/services/app_service.dart';
import 'package:demo_firebase_flutter_getx_2/app/utils/services/scaffold_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    debugPrint('Erreur lors de l’initialisation Firebase: $error');
  }

  setPathUrlStrategy();

  runApp(const DemoFirebaseFlutterGetx());
}

class DemoFirebaseFlutterGetx extends StatelessWidget {
  const DemoFirebaseFlutterGetx({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: AppTheme.getThemeMode(),
      getPages: AppPages.routes,
      initialBinding: AppBuild.initialBinding(),
      builder: (context, child) => AppBuild.builder(child),
      scrollBehavior: CustomScrollBehaviour(),
      locale: AppService.getLocale(),
      translations: Translation(),
      localizationsDelegates: AppBuild.localizationsDelegates,
      supportedLocales: AppBuild.supportedLocales,
      routerDelegate: AppBuild.routerDelegate(),
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: ScaffoldService.scaffoldMessengerKey,
    );
  }
}
