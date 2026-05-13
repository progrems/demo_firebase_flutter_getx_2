import 'package:get/get.dart';

import '../controllers/forgot_view_controller.dart';

class ForgotViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotViewController>(ForgotViewController.new);
  }
}
