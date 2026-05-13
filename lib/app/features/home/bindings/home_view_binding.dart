import 'package:get/get.dart';

import '../../../utils/services/src/auth_service.dart';
import '../../../utils/services/src/firestore_service.dart';
import '../controllers/home_view_controller.dart';

class HomeViewBinding extends Bindings {
  @override
  void dependencies() {
    // Ce binding rend HomeViewController disponible pour HomePageViewScreen.
    _registerCoreServices();

    if (!Get.isRegistered<HomeViewController>()) {
      Get.put(
        HomeViewController(
          authService: Get.find<AuthService>(),
          firestoreService: Get.find<FirestoreService>(),
        ),
      );
    } else {
      Get.find<HomeViewController>().loadUser();
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
