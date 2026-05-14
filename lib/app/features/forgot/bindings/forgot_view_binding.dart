part of '../views/forgot_view_screen.dart';

class ForgotViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotViewController());
  }
}
