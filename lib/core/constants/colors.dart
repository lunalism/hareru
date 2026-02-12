import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF4A90D9);

  // Accent
  static const Color accent = Color(0xFFFFD54F);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey900 = Color(0xFF212121);
}

class HareruColors {
  HareruColors._();

  // Primary gradient
  static const Color primaryStart = Color(0xFF4A90D9);
  static const Color primaryEnd = Color(0xFF6BA3E0);

  // Light mode backgrounds
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightNavBar = Color(0xFFFFFFFF);

  // Dark mode backgrounds
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkNavBar = Color(0xFF1E293B);

  // Text colors — light
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextTertiary = Color(0xFF94A3B8);

  // Text colors — dark
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);

  // Divider
  static const Color lightDivider = Color(0xFFE2E8F0);
  static const Color darkDivider = Color(0xFF334155);

  // Transaction types
  static const Color income = Color(0xFF10B981);
  static const Color expense = Color(0xFFEF4444);
  static const Color transferOrange = Color(0xFFF59E0B);

  // Budget progress
  static const Color budgetTrackLight = Color(0xFFE2E8F0);
  static const Color budgetTrackDark = Color(0xFF334155);

  // Inactive nav
  static const Color navInactiveLight = Color(0xFFCBD5E1);
  static const Color navInactiveDark = Color(0xFF475569);
}
