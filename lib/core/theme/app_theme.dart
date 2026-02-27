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
        scaffoldBackgroundColor: HareruColors.lightBg,
        cardColor: AppColors.white,
        dividerColor: HareruColors.lightDivider,
        appBarTheme: const AppBarTheme(
          backgroundColor: HareruColors.lightBg,
          foregroundColor: HareruColors.lightTextPrimary,
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
        scaffoldBackgroundColor: HareruColors.darkBg,
        cardColor: HareruColors.darkCard,
        dividerColor: HareruColors.darkDivider,
        appBarTheme: const AppBarTheme(
          backgroundColor: HareruColors.darkBg,
          foregroundColor: HareruColors.darkTextPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      );
}
