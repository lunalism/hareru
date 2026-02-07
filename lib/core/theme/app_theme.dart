import 'package:flutter/material.dart';
import 'custom_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: 'PretendardJP',
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4A90D9),
          onPrimary: Colors.white,
          secondary: Color(0xFFFFD54F),
          surface: Colors.white,
          onSurface: Color(0xFF333333),
          outline: Color(0xFFEEEEEE),
          error: Color(0xFFE57373),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAFAFA),
          foregroundColor: Color(0xFF333333),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF4A90D9),
          unselectedItemColor: Color(0xFF888888),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFEEEEEE),
          thickness: 0.5,
        ),
        extensions: const [CustomColors.light],
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        fontFamily: 'PretendardJP',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6AB0FF),
          onPrimary: Color(0xFF121212),
          secondary: Color(0xFFFFD54F),
          surface: Color(0xFF1E1E1E),
          onSurface: Color(0xFFE0E0E0),
          outline: Color(0xFF333333),
          error: Color(0xFFEF9A9A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Color(0xFFE0E0E0),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Color(0xFF6AB0FF),
          unselectedItemColor: Color(0xFF888888),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF333333),
          thickness: 0.5,
        ),
        extensions: const [CustomColors.dark],
      );
}
