import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/themes/app_style.dart';

class ScaffoldService {
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void success(String title, String message) {
    _show(title, message, AppStyle.success);
  }

  static void error(String title, String message) {
    _show(title, message, AppStyle.error);
  }

  static void warning(String title, String message) {
    _show(title, message, AppStyle.warning);
  }

  static void info(String title, String message) {
    _show(title, message, AppStyle.primary);
  }

  static void _show(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 4),
    );
  }
}
