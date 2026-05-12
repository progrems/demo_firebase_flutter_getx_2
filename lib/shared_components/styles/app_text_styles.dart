import 'package:flutter/material.dart';

import 'app_colors.dart';

// Styles de texte réutilisés dans le popup et dans Home.
class AppTextStyles {
  static const dialogTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const label = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(color: AppColors.textPrimary, fontSize: 16);

  static const muted = TextStyle(color: AppColors.textSecondary, fontSize: 14);
}
