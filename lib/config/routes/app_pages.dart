import 'package:get/get.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/controllers/login_controller.dart';
import '../../features/auth/controllers/register_controller.dart';
import '../../features/auth/views/account_view.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/home/views/home_view.dart';
import '../../utils/services/firebase_auth_service.dart';
import '../../utils/services/firestore_service.dart';
import '../middleware/auth_middleware.dart';
import 'app_routes.dart';

abstract class AppPages {
  // L'application démarre toujours sur la page simple avec le bouton Compte.
  static const initial = AppRoutes.account;

  // Chaque GetPage associe une route, une vue, ses dépendances et parfois
  // un middleware de protection.
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.account,
      page: () => const AccountView(),

      // Avant d'afficher AccountView, on prépare les services et controllers
      // nécessaires au popup d'authentification.
      binding: BindingsBuilder(_registerAuthDependencies),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        _registerCoreServices();

        // HomeController a besoin des deux services : Auth pour connaître
        // l'utilisateur connecté, Firestore pour lire son profil.
        if (!Get.isRegistered<HomeController>()) {
          Get.put(
            HomeController(
              authService: Get.find<FirebaseAuthService>(),
              firestoreService: Get.find<FirestoreService>(),
            ),
          );
        } else {
          // Si le controller existe déjà, on recharge les infos utilisateur
          // pour afficher les données les plus récentes.
          Get.find<HomeController>().loadUser();
        }
      }),

      // Protection principale de Home : pas d'accès sans email vérifié.
      middlewares: [AuthMiddleware()],
    ),
  ];

  static void _registerAuthDependencies() {
    _registerCoreServices();

    // AuthController reste permanent car il pilote le popup Compte
    // pendant toute la vie de l'application.
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }

    // lazyPut crée le controller seulement quand il est demandé.
    // fenix permet à GetX de le recréer si nécessaire.
    if (!Get.isRegistered<LoginController>()) {
      Get.lazyPut(
        () => LoginController(
          authService: Get.find<FirebaseAuthService>(),
          firestoreService: Get.find<FirestoreService>(),
        ),
        fenix: true,
      );
    }

    // RegisterController est séparé de LoginController pour garder
    // une responsabilité claire : un controller = un formulaire principal.
    if (!Get.isRegistered<RegisterController>()) {
      Get.lazyPut(
        () => RegisterController(
          authService: Get.find<FirebaseAuthService>(),
          firestoreService: Get.find<FirestoreService>(),
        ),
        fenix: true,
      );
    }
  }

  static void _registerCoreServices() {
    // Les services Firebase sont injectés ici pour éviter d'appeler
    // Firebase directement dans les vues.
    if (!Get.isRegistered<FirebaseAuthService>()) {
      Get.lazyPut(FirebaseAuthService.new, fenix: true);
    }

    if (!Get.isRegistered<FirestoreService>()) {
      Get.lazyPut(FirestoreService.new, fenix: true);
    }
  }
}
