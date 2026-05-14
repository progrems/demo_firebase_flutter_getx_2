part of '../views/screens/login_view_screen.dart';

class LoginViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginViewController());
  }
}
