// ignore: unnecessary_library_name
library routes;

import 'package:demo_firebase_flutter_getx_2/app/config/middleware/auth_middleware.dart';
import 'package:demo_firebase_flutter_getx_2/app/features/forgot/views/forgot_view_screen.dart';
import 'package:demo_firebase_flutter_getx_2/app/features/home/views/home_page_view_screen.dart';
import 'package:demo_firebase_flutter_getx_2/app/features/login/views/screens/login_view_screen.dart';
import 'package:demo_firebase_flutter_getx_2/app/features/register/views/register_view_screen.dart';
import 'package:demo_firebase_flutter_getx_2/app/features/root/views/screens/root_view.dart';
import 'package:get/get.dart';

part '../routes/app_pages.dart';

/// used to switch pages
class Routes {
  static const root = _Paths.root;
  static const accueil = _Paths.accueil;
  static const home = _Paths.home;
  static const login = _Paths.login;
  static const forgot = _Paths.forgot;
  static const register = _Paths.register;
  static const notFound = _Paths.notFound;
}

/// contains a list of route names.
// made separately to make it easier to manage route naming
class _Paths {
  // Example :
  // static const index = "/";
  // static const splash = "/splash";
  // static const product = "/product";

  static const root = "/";
  static const home = "/home";
  static const accueil = "/accueil";
  static const login = "/login";
  static const forgot = "/forgot";
  static const register = "/register";
  static const notFound = "/not-found";
}
