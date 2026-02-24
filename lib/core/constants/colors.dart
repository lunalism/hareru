import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFFE8453C);

  // Accent
  static const Color accent = Color(0xFFFFD54F);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF5F0EB);
  static const Color grey300 = Color(0xFFE5E0DB);
  static const Color grey600 = Color(0xFF8A8A8A);
  static const Color grey900 = Color(0xFF1A1A1A);
}

class HareruColors {
  HareruColors._();

  // Primary (solid, no gradient)
  static const Color primaryStart = Color(0xFFE8453C);
  static const Color primaryEnd = Color(0xFFD63C34);

  // Light mode backgrounds
  static const Color lightBg = Color(0xFFF5F0EB);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightNavBar = Color(0xFFF5F0EB);

  // Dark mode backgrounds
  static const Color darkBg = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2A2A2A);
  static const Color darkNavBar = Color(0xFF1A1A1A);

  // Text colors — light
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF8A8A8A);
  static const Color lightTextTertiary = Color(0xFFBFBFBF);

  // Text colors — dark
  static const Color darkTextPrimary = Color(0xFFF0ECE7);
  static const Color darkTextSecondary = Color(0xFF8A8A8A);
  static const Color darkTextTertiary = Color(0xFF5A5A5A);

  // Divider
  static const Color lightDivider = Color(0xFFE5E0DB);
  static const Color darkDivider = Color(0xFF3A3A3A);

  // Transaction types
  static const Color income = Color(0xFF10B981);
  static const Color expense = Color(0xFFEF4444);
  static const Color transferOrange = Color(0xFFF59E0B);

  // Budget progress
  static const Color budgetTrackLight = Color(0xFFE5E0DB);
  static const Color budgetTrackDark = Color(0xFF3A3A3A);

  // Inactive nav
  static const Color navInactiveLight = Color(0xFF8A8A8A);
  static const Color navInactiveDark = Color(0xFF5A5A5A);

  // Warm minimal extras
  static const Color headerCardLight = Color(0xFFEDE8E3);
  static const Color guideIconBg = Color(0xFFFFF0EF);
}
