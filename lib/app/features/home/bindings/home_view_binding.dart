part of '../views/home_page_view_screen.dart';

class HomeViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeViewController());
  }
}
