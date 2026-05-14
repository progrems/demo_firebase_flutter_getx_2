import 'package:get/get.dart';

import '../../login/views/screens/login_view_screen.dart';
import '../../register/views/register_view_screen.dart';
import '../views/screens/auth_dialog.dart';

class RootController extends GetxController {
  final RxBool isLoginMode = true.obs;

  void openAuthDialog() {
    if (Get.isDialogOpen ?? false) {
      return;
    }

    _prepareAuthDialogControllers();
    showLoginForm();
    Get.dialog(const AuthDialog(), barrierDismissible: true);
  }

  void _prepareAuthDialogControllers() {
    if (!Get.isRegistered<LoginViewController>()) {
      Get.lazyPut(() => LoginViewController(), fenix: true);
    }

    if (!Get.isRegistered<RegisterViewController>()) {
      Get.lazyPut(() => RegisterViewController(), fenix: true);
    }
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
