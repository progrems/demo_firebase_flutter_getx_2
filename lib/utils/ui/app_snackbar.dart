import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared_components/styles/app_colors.dart';

// Centralise les messages affichés à l'utilisateur.
// Comme ça, tous les snackbars ont le même style.
class AppSnackbar {
  static void success(String title, String message) {
    _show(title, message, AppColors.success);
  }

  static void error(String title, String message) {
    _show(title, message, AppColors.error);
  }

  static void warning(String title, String message) {
    _show(title, message, AppColors.warning);
  }

  static void info(String title, String message) {
    _show(title, message, AppColors.primary);
  }

  static void _show(String title, String message, Color color) {
    // Get.snackbar permet d'afficher un message sans avoir besoin du context Flutter.
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
