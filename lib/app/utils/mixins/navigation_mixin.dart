import 'package:get/get.dart';

import '../../config/routes/app_routes.dart';

mixin NavigationMixin {
  void goToRoot() => Get.offAllNamed(Routes.root);

  void goToHome() => Get.offAllNamed(Routes.home);
}
