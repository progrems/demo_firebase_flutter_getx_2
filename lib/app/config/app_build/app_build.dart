import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import '../../features/not_found/views/screens/not_found_view_screen.dart';
import '../../features/splash/controllers/splash_service.dart';
import '../../features/splash/views/splash_view.dart';
import '../lang/translation.dart';
import '../routes/app_routes.dart';
import '../themes/app_theme.dart';

class AppBuild {
  AppBuild._();

  static Widget app() {
    return GetMaterialApp(
      title: 'Firebase Auth GetX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: initialBinding(),
      translations: Translation(),
      locale: const Locale('fr', 'FR'),
      fallbackLocale: const Locale('fr', 'FR'),
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      scrollBehavior: CustomScrollBehaviour(),
      builder: (context, child) => AppBuild.builder(child),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      unknownRoute: notFoundRoute(),
    );
  }

  static BindingsBuilder<dynamic> initialBinding() {
    return BindingsBuilder(() {
      Get.put(SplashService());
    });
  }

  static FutureBuilder<void> builder(Widget? child) {
    return FutureBuilder<void>(
      key: const ValueKey('initFuture'),
      future: Get.find<SplashService>().init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return child ?? const SizedBox.shrink();
        }

        return const SplashView();
      },
    );
  }

  static List<Locale> get supportedLocales {
    return const [Locale('fr', 'CA'), Locale('fr', 'FR')];
  }

  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates {
    return const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }

  static GetDelegate routerDelegate() {
    return GetDelegate(
      notFoundRoute: notFoundRoute(),
      backButtonPopMode: PopMode.History,
      preventDuplicateHandlingMode: PreventDuplicateHandlingMode.ReorderRoutes,
    );
  }

  static GetPage<dynamic> notFoundRoute() {
    return GetPage(
      name: Routes.notFound,
      page: () => const NotFoundViewScreen(),
      binding: NotFoundViewBinding(),
      transitionDuration: Duration.zero,
      transition: Transition.noTransition,
    );
  }
}

class CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  };
}
