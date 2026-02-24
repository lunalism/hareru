import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/constants/typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.white,
        ),
        fontFamily: AppTypography.fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF5F0EB),
        cardColor: AppColors.white,
        dividerColor: const Color(0xFFE5E0DB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F0EB),
          foregroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        fontFamily: AppTypography.fontFamily,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        cardColor: const Color(0xFF2A2A2A),
        dividerColor: const Color(0xFF3A3A3A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Color(0xFFF0ECE7),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      );
}
