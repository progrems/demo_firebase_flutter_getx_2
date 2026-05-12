import 'package:get/get.dart';

import '../views/auth_dialog.dart';

class AuthController extends GetxController {
  // true = formulaire Connexion, false = formulaire Inscription.
  // .obs rend la valeur réactive pour que Obx mette le popup à jour.
  final RxBool isLoginMode = true.obs;

  void openAuthDialog() {
    // Evite d'ouvrir plusieurs dialogs si l'utilisateur clique rapidement.
    if (Get.isDialogOpen ?? false) {
      return;
    }

    // Le popup doit toujours s'ouvrir par défaut en mode Connexion.
    showLoginForm();

    // Get.dialog affiche AuthDialog au-dessus de la page actuelle.
    Get.dialog(const AuthDialog(), barrierDismissible: true);
  }

  void showLoginForm() {
    // Change seulement le contenu du popup, sans changer de page.
    isLoginMode.value = true;
  }

  void showRegisterForm() {
    // Même popup, mais on affiche le formulaire Inscription.
    isLoginMode.value = false;
  }

  void closeDialog() {
    // Après une connexion réussie, on ferme le popup avant d'aller à Home.
    if (Get.isDialogOpen ?? false) {
      Get.back<void>();
    }
  }
}
