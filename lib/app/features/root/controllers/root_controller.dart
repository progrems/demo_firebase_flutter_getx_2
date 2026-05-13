import 'package:get/get.dart';

import '../views/screens/auth_dialog.dart';

class RootController extends GetxController {
  final RxBool isLoginMode = true.obs;

  void openAuthDialog() {
    if (Get.isDialogOpen ?? false) {
      return;
    }

    showLoginForm();
    Get.dialog(const AuthDialog(), barrierDismissible: true);
  }

  void showLoginForm() {
    isLoginMode.value = true;
  }

  void showRegisterForm() {
    isLoginMode.value = false;
  }

  void closeAuthDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back<void>();
    }
  }
}
