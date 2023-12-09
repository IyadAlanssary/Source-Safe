import 'package:flutter/material.dart';
import 'package:network_applications/constant/color.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return _theme(Brightness.light, AppColors.lightColorScheme);
  }

  static ThemeData get darkTheme {
    return _theme(Brightness.light, AppColors.darkColorScheme);
  }

  static ThemeData _theme(Brightness brightness1, ColorScheme colors) {
    return ThemeData(
      brightness: brightness1,
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.background,
      textTheme: _textTheme().apply(displayColor: colors.onBackground),
      appBarTheme: _appBarTheme(colors),
      elevatedButtonTheme: _elevatedButtonThemeData(colors),
      inputDecorationTheme: _inputDecorationTheme(),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        shadowColor: colors.shadow,
        surfaceTintColor: colors.surface,
      ),
    );
  }

  static AppBarTheme _appBarTheme(ColorScheme colors) {
    return AppBarTheme(
      centerTitle: true,
      backgroundColor: colors.onPrimaryContainer,
      titleTextStyle: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.bold,
        fontSize: 20,
        height: 28 / 20,
        color: colors.onPrimary,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonThemeData(ColorScheme colors) {
    return ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        textStyle: const TextStyle(
          fontFamily: "DMSans",
          fontWeight: FontWeight.bold,
          fontSize: 16,
          height: 24 / 22,
        ),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  static TextTheme _textTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w400,
        fontSize: 57,
        height: 64 / 57,
      ),
      displayMedium: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w400,
        fontSize: 45,
        height: 52 / 45,
      ),
      displaySmall: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w400,
        fontSize: 36,
        height: 44 / 36,
      ),
      headlineLarge: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w500,
        fontSize: 32,
        height: 40 / 32,
      ),
      headlineMedium: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w500,
        fontSize: 28,
        height: 36 / 28,
      ),
      headlineSmall: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w500,
        fontSize: 24,
        height: 32 / 24,
      ),
      titleLarge: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.bold,
        fontSize: 22,
        height: 28 / 22,
      ),
      titleMedium: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.bold,
        fontSize: 16,
        height: 24 / 22,
      ),
      titleSmall: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.bold,
        fontSize: 14,
        height: 20 / 14,
      ),
      bodyLarge: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 24 / 16,
      ),
      bodyMedium: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 20 / 14,
      ),
      bodySmall: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 16 / 12,
      ),
      labelLarge: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 20 / 14,
      ),
      labelMedium: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 16 / 12,
      ),
      labelSmall: TextStyle(
        fontFamily: "DMSans",
        fontWeight: FontWeight.w500,
        fontSize: 11,
        height: 16 / 11,
      ),
    );
  }
}
