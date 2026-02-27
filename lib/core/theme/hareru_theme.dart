import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';

class HareruThemeColors {
  HareruThemeColors._(this._isDark);

  final bool _isDark;

  // Backgrounds
  Color get background => _isDark ? HareruColors.darkBg : HareruColors.lightBg;
  Color get card => _isDark ? HareruColors.darkCard : HareruColors.lightCard;
  Color get headerCard => _isDark ? HareruColors.darkCard : HareruColors.headerCardLight;

  // Text
  Color get textPrimary =>
      _isDark ? HareruColors.darkTextPrimary : HareruColors.lightTextPrimary;
  Color get textSecondary =>
      _isDark ? HareruColors.darkTextSecondary : HareruColors.lightTextSecondary;
  Color get textTertiary =>
      _isDark ? HareruColors.darkTextTertiary : HareruColors.lightTextTertiary;

  // Divider
  Color get divider => _isDark ? HareruColors.darkDivider : HareruColors.lightDivider;

  // Nav
  Color get navInactive =>
      _isDark ? HareruColors.navInactiveDark : HareruColors.navInactiveLight;
}

extension HareruThemeContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  HareruThemeColors get colors => HareruThemeColors._(isDark);
}
