import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFD32F2F);
  static const Color text = Color(0xFF111827);
  static const Color border = Color(0xFFD1D5DB);
  static const Color hint = Color(0xFF9CA3AF);
  static const Color darkBackground = Color(0xFF2B2B2B);
}

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary)
        .copyWith(primary: AppColors.primary),
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      hintStyle: const TextStyle(color: AppColors.hint),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

ThemeData buildDarkTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: AppColors.darkBackground,
        onSurface: Colors.white,
      );

  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.darkBackground,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4B5563)),
      ),
      hintStyle: const TextStyle(color: AppColors.hint),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
