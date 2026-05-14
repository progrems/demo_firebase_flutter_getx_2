part of '../views/register_view_screen.dart';

class RegisterViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterViewController());
  }
}
