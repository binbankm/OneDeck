import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'deck_colors.dart';

/// OneDeck's master theme configurations for Light and Dark modes.
abstract final class DeckTheme {
  /// Font family fallbacks prioritizing modern clean typography.
  static const List<String> fontFallbacks = [
    '-apple-system',
    'BlinkMacSystemFont',
    'SF Pro Text',
    'Inter',
    'Segoe UI',
    'Roboto',
    'Noto Sans SC',
    'sans-serif',
  ];

  /// Monospace font family for code, terminal, and IP addresses.
  static const List<String> monoFontFallbacks = [
    'JetBrains Mono',
    'SF Mono',
    'Menlo',
    'Consolas',
    'Fira Code',
    'monospace',
  ];

  // -------------------------------------------------------------
  // DARK THEME (Titanium Obsidian)
  // -------------------------------------------------------------
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      surface: DeckColors.darkCanvas,
      primary: DeckColors.accentIndigo,
      secondary: DeckColors.accentCyan,
      error: DeckColors.statusError,
      onSurface: DeckColors.darkTextPrimary,
      onPrimary: Colors.white,
      outline: DeckColors.darkSubtleBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: DeckColors.darkCanvas,
      canvasColor: DeckColors.darkCanvas,
      cardColor: DeckColors.darkCard,
      fontFamilyFallback: fontFallbacks,
      dividerColor: DeckColors.darkSubtleBorder,
      dividerTheme: const DividerThemeData(
        color: DeckColors.darkSubtleBorder,
        thickness: 0.8,
        space: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: DeckColors.darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(
            color: DeckColors.darkSubtleBorder,
            width: 0.8,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DeckColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: const TextStyle(
          color: DeckColors.darkTextMuted,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: DeckColors.darkSubtleBorder, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: DeckColors.darkSubtleBorder, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: DeckColors.accentIndigo, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DeckColors.accentIndigo,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DeckColors.darkTextPrimary,
          side: const BorderSide(color: DeckColors.darkSubtleBorder, width: 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // LIGHT THEME (Polar Titanium)
  // -------------------------------------------------------------
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      surface: DeckColors.lightCanvas,
      primary: DeckColors.accentIndigo,
      secondary: DeckColors.accentCyan,
      error: DeckColors.statusError,
      onSurface: DeckColors.lightTextPrimary,
      onPrimary: Colors.white,
      outline: DeckColors.lightSubtleBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: DeckColors.lightCanvas,
      canvasColor: DeckColors.lightCanvas,
      cardColor: DeckColors.lightCard,
      fontFamilyFallback: fontFallbacks,
      dividerColor: DeckColors.lightSubtleBorder,
      dividerTheme: const DividerThemeData(
        color: DeckColors.lightSubtleBorder,
        thickness: 0.8,
        space: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: DeckColors.lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(
            color: DeckColors.lightSubtleBorder,
            width: 0.8,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DeckColors.lightCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: const TextStyle(
          color: DeckColors.lightTextMuted,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: DeckColors.lightSubtleBorder, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: DeckColors.lightSubtleBorder, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: DeckColors.accentIndigo, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DeckColors.accentIndigo,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DeckColors.lightTextPrimary,
          side: const BorderSide(color: DeckColors.lightSubtleBorder, width: 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
