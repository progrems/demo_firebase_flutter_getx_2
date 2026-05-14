part of '../views/screens/not_found_view_screen.dart';

class NotFoundViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotFoundViewController());
  }
}
