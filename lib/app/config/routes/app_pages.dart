// ignore: use_string_in_part_of_directives
part of routes;

/// Contient toute la configuration des pages GetX.
class AppPages {
  AppPages._();

  /// Première route affichée au lancement.
  ///
  /// On garde RootView en premier pour conserver le flow actuel :
  /// bouton Compte -> popup Login/Register -> Home.
  static const initial = Routes.root;

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: _Paths.root,
      page: () => const RootView(),
      binding: RootBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      transitionDuration: Duration.zero,
      transition: Transition.noTransition,
      children: [
        // Login existe comme route enfant pour respecter la structure,
        // même si le flow principal l'affiche dans le popup.
        GetPage(
          name: _Paths.login,
          preventDuplicates: true,
          page: () => const LoginViewScreen(),
          binding: LoginViewBinding(),
          transitionDuration: Duration.zero,
          transition: Transition.noTransition,
        ),

        // Register existe aussi comme route enfant, mais reste utilisé
        // dans le même popup que Login.
        GetPage(
          name: _Paths.register,
          preventDuplicates: true,
          page: () => const RegisterViewScreen(),
          binding: RegisterViewBinding(),
          transitionDuration: Duration.zero,
          transition: Transition.noTransition,
        ),

        GetPage(
          name: _Paths.home,
          preventDuplicates: true,
          page: () => const HomePageViewScreen(),
          binding: HomeViewBinding(),
          transitionDuration: Duration.zero,
          transition: Transition.noTransition,
          middlewares: [AuthMiddleware()],
        ),

        GetPage(
          name: _Paths.forgot,
          preventDuplicates: true,
          page: () => const ForgotViewScreen(),
          binding: ForgotViewBinding(),
          transitionDuration: Duration.zero,
          transition: Transition.noTransition,
        ),
      ],
    ),
  ];
}
