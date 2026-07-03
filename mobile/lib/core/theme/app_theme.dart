import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ThemeData terpusat, dipakai MaterialApp.router.
/// Jangan bangun ThemeData ad-hoc di widget lain — tambahkan di sini.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.creamBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.creamBackground,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: AppColors.surface,
        ),
      );
}