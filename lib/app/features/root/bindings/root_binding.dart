import 'package:get/get.dart';

import '../../../utils/services/src/auth_service.dart';
import '../../../utils/services/src/firestore_service.dart';
import '../../login/controllers/login_view_controller.dart';
import '../../register/controllers/register_view_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    // Le binding prépare les services et controllers avant l'affichage de RootView.
    _registerCoreServices();

    // RootController gère le bouton Compte et l'ouverture du popup.
    if (!Get.isRegistered<RootController>()) {
      Get.lazyPut<RootController>(RootController.new, fenix: true);
    }

    // Le popup affiche le formulaire Login, donc son controller doit déjà exister.
    if (!Get.isRegistered<LoginViewController>()) {
      Get.lazyPut(
        () => LoginViewController(
          authService: Get.find<AuthService>(),
          firestoreService: Get.find<FirestoreService>(),
        ),
        fenix: true,
      );
    }

    // Le même popup peut passer en mode Register, donc on prépare aussi ce controller.
    if (!Get.isRegistered<RegisterViewController>()) {
      Get.lazyPut(
        () => RegisterViewController(
          authService: Get.find<AuthService>(),
          firestoreService: Get.find<FirestoreService>(),
        ),
        fenix: true,
      );
    }
  }

  void _registerCoreServices() {
    if (!Get.isRegistered<AuthService>()) {
      Get.lazyPut(AuthService.new, fenix: true);
    }

    if (!Get.isRegistered<FirestoreService>()) {
      Get.lazyPut(FirestoreService.new, fenix: true);
    }
  }
}
