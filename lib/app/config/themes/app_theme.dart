import 'package:flutter/material.dart';

import 'app_style.dart';

class AppTheme {
  static ThemeData get light => lightTheme;

  static ThemeData get lightTheme {
    // Le thème part de AppStyle.primary. Pour changer la couleur globale,
    // on modifie surtout AppStyle.
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppStyle.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppStyle.primary,
          secondary: AppStyle.accent,
          surface: AppStyle.surface,
          error: AppStyle.error,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppStyle.background,

      // Style commun des champs utilisés dans le popup.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppStyle.fieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppStyle.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppStyle.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppStyle.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppStyle.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),

      // Style commun des boutons AsyncButton, car AsyncButton utilise
      // ElevatedButton en interne.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppStyle.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppStyle.primary,
          secondary: AppStyle.accent,
          error: AppStyle.error,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF121212),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  static ThemeMode getThemeMode() {
    return ThemeMode.light;
  }
}
