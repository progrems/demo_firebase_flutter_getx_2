import 'package:get/get.dart';

import '../controllers/not_found_view_controller.dart';

class NotFoundViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotFoundViewController>(NotFoundViewController.new);
  }
}
