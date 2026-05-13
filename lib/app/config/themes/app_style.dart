import 'package:flutter/material.dart';

class AppStyle {
  static const primary = Color(0xFF1565C0);
  static const accent = Color(0xFF006D77);
  static const background = Color(0xFFF7F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const fieldBackground = Color(0xFFFBFBFD);
  static const border = Color(0xFFD7D7E2);
  static const textPrimary = Color(0xFF1E1E2D);
  static const textSecondary = Color(0xFF656575);
  static const success = Color(0xFF1F8A5B);
  static const warning = Color(0xFFB35C00);
  static const error = Color(0xFFBA1A1A);

  static const dialogTitle = TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const body = TextStyle(color: textPrimary, fontSize: 16);

  static const muted = TextStyle(color: textSecondary, fontSize: 14);
}
