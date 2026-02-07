import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color skyBlueLight;
  final Color nightLight;
  final Color incomeGreen;
  final Color expenseRed;
  final Color transferGray;

  const CustomColors({
    required this.skyBlueLight,
    required this.nightLight,
    required this.incomeGreen,
    required this.expenseRed,
    required this.transferGray,
  });

  static const light = CustomColors(
    skyBlueLight: Color(0xFFE8F2FC),
    nightLight: Color(0xFF888888),
    incomeGreen: Color(0xFF4CAF50),
    expenseRed: Color(0xFFE57373),
    transferGray: Color(0xFFB0BEC5),
  );

  static const dark = CustomColors(
    skyBlueLight: Color(0xFF1A3A5C),
    nightLight: Color(0xFF888888),
    incomeGreen: Color(0xFF81C784),
    expenseRed: Color(0xFFEF9A9A),
    transferGray: Color(0xFF78909C),
  );

  @override
  CustomColors copyWith({
    Color? skyBlueLight,
    Color? nightLight,
    Color? incomeGreen,
    Color? expenseRed,
    Color? transferGray,
  }) {
    return CustomColors(
      skyBlueLight: skyBlueLight ?? this.skyBlueLight,
      nightLight: nightLight ?? this.nightLight,
      incomeGreen: incomeGreen ?? this.incomeGreen,
      expenseRed: expenseRed ?? this.expenseRed,
      transferGray: transferGray ?? this.transferGray,
    );
  }

  @override
  CustomColors lerp(CustomColors? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      skyBlueLight: Color.lerp(skyBlueLight, other.skyBlueLight, t)!,
      nightLight: Color.lerp(nightLight, other.nightLight, t)!,
      incomeGreen: Color.lerp(incomeGreen, other.incomeGreen, t)!,
      expenseRed: Color.lerp(expenseRed, other.expenseRed, t)!,
      transferGray: Color.lerp(transferGray, other.transferGray, t)!,
    );
  }
}
