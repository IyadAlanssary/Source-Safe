import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return _theme(Brightness.light, lightColorScheme);
  }

  static ThemeData get darkTheme {
    return _theme(Brightness.dark, darkColorScheme);
  }

  static ThemeData _theme(Brightness brightness1, ColorScheme colors) {
    return ThemeData(
      fontFamily: 'Teko',
      brightness: brightness1,
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.background,
      textTheme: _textTheme().apply(displayColor: colors.onBackground),
      appBarTheme: _appBarTheme(colors),
      elevatedButtonTheme: _elevatedButtonThemeData(colors),
      inputDecorationTheme: _inputDecorationTheme(),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 8,
        shadowColor: colors.shadow,
        surfaceTintColor: colors.surface,
      ),
    );
  }

  static AppBarTheme _appBarTheme(ColorScheme colors) {
    return AppBarTheme(
      centerTitle: true,
      backgroundColor: colors.primary,
      titleTextStyle: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
        fontSize: 24,
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
          fontFamily: "Teko",
          letterSpacing: 4,
        fontSize: 22,
        ),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  static TextTheme _textTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 60,
        height: 64 / 57,
      ),
      displayMedium: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 48,
        height: 52 / 45,
      ),
      displaySmall: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 40,
        height: 44 / 36,
      ),
      headlineLarge: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 35,
        height: 40 / 32,
      ),
      headlineMedium: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 32,
        height: 36 / 28,
      ),
      headlineSmall: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 28,
        height: 32 / 24,
      ),
      titleLarge: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
        fontSize: 26,
        height: 28 / 22,
      ),
      titleMedium: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
        fontSize: 20,
        height: 24 / 22,
      ),
      titleSmall: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
        fontSize: 18,
        height: 20 / 14,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 20,
        height: 24 / 16,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 18,
        height: 20 / 14,
      ),
      bodySmall: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 16,
        height: 16 / 12,
      ),
      labelLarge: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 18,
        height: 20 / 14,
      ),
      labelMedium: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 16,
        height: 16 / 12,
      ),
      labelSmall: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 15,
        height: 16 / 11,
      ),
    );
  }
}
