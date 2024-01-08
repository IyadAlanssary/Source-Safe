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
      fontFamily: 'Bebas Neue',
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
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
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
          fontFamily: "Bebas Neue",
          letterSpacing: 4,
        fontSize: 18,
          height: 24 / 22,
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
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 57,
        height: 64 / 57,
      ),
      displayMedium: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 45,
        height: 52 / 45,
      ),
      displaySmall: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 36,
        height: 44 / 36,
      ),
      headlineLarge: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 32,
        height: 40 / 32,
      ),
      headlineMedium: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 28,
        height: 36 / 28,
      ),
      headlineSmall: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 24,
        height: 32 / 24,
      ),
      titleLarge: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
        fontSize: 22,
        height: 28 / 22,
      ),
      titleMedium: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
        fontSize: 16,
        height: 24 / 22,
      ),
      titleSmall: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
        fontSize: 14,
        height: 20 / 14,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 16,
        height: 24 / 16,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 14,
        height: 20 / 14,
      ),
      bodySmall: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
        fontSize: 12,
        height: 16 / 12,
      ),
      labelLarge: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 14,
        height: 20 / 14,
      ),
      labelMedium: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 12,
        height: 16 / 12,
      ),
      labelSmall: TextStyle(
        fontFamily: "Bebas Neue",
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        fontSize: 11,
        height: 16 / 11,
      ),
    );
  }
}
