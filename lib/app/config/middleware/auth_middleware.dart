import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || !user.emailVerified) {
        return const RouteSettings(name: Routes.root);
      }

      return null;
    } catch (_) {
      return const RouteSettings(name: Routes.root);
    }
  }
}
