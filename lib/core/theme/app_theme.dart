import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: AppTypography.fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.skyBlue,
          primary: AppColors.skyBlue,
          secondary: AppColors.sunlight,
          surface: AppColors.cardWhite,
        ),
        scaffoldBackgroundColor: AppColors.cloud,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cloud,
          foregroundColor: AppColors.night,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      );
}
