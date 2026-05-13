import 'package:get/get.dart';

import '../../../utils/services/src/auth_service.dart';
import '../../../utils/services/src/firestore_service.dart';
import '../controllers/login_view_controller.dart';

class LoginViewBinding extends Bindings {
  @override
  void dependencies() {
    // Ce binding rend LoginViewController disponible pour LoginViewScreen.
    _registerCoreServices();

    if (!Get.isRegistered<LoginViewController>()) {
      Get.lazyPut(
        () => LoginViewController(
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
