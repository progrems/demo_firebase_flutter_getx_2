import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../lang/translation.dart';
import '../routes/app_pages.dart';
import '../routes/app_routes.dart';
import '../themes/app_theme.dart';

class AppBuild extends StatelessWidget {
  const AppBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Firebase Auth GetX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      translations: Translation(),
      locale: const Locale('fr', 'FR'),
      fallbackLocale: const Locale('fr', 'FR'),
      initialRoute: Routes.root,
      getPages: AppPages.pages,
      unknownRoute: AppPages.unknownRoute,
    );
  }
}
