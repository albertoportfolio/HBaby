import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/settings/settings_provider.dart';

/// Color set used to build a [ThemeData] for each [AppThemeTone].
class _Palette {
  final Brightness brightness;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color background;
  final Color surface;
  final Color onBackground;
  final Color subtle;
  final Color outline;
  final Color divider;

  const _Palette({
    this.brightness = Brightness.light,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.background,
    required this.surface,
    this.onBackground = const Color(0xFF3D3D3D),
    this.subtle = const Color(0xFF9E9E9E),
    this.outline = const Color(0xFFE0E0E0),
    this.divider = const Color(0xFFEEEEEE),
  });
}

class AppTheme {
  // Pastel accents shared across palettes
  static const Color pink = Color(0xFFFF8FAB);
  static const Color blue = Color(0xFF89CFF0);
  static const Color green = Color(0xFFA8E6CF);

  // Kept for backwards compatibility with code referencing the old palette.
  static const Color primary = pink;
  static const Color secondary = blue;
  static const Color tertiary = green;
  static const Color background = Color(0xFFFFF5F7);
  static const Color surface = Colors.white;
  static const Color onBackground = Color(0xFF3D3D3D);
  static const Color subtle = Color(0xFF9E9E9E);

  static const _palettes = <AppThemeTone, _Palette>{
    AppThemeTone.pink: _Palette(
      primary: pink,
      secondary: blue,
      tertiary: green,
      background: Color(0xFFFFF5F7),
      surface: Colors.white,
    ),
    AppThemeTone.blue: _Palette(
      primary: Color(0xFF6FBDE8),
      secondary: pink,
      tertiary: green,
      background: Color(0xFFF2F8FD),
      surface: Colors.white,
    ),
    AppThemeTone.green: _Palette(
      primary: Color(0xFF6FCF97),
      secondary: blue,
      tertiary: pink,
      background: Color(0xFFF2FAF5),
      surface: Colors.white,
    ),
    AppThemeTone.dark: _Palette(
      brightness: Brightness.dark,
      primary: pink,
      secondary: blue,
      tertiary: green,
      background: Color(0xFF16161E),
      surface: Color(0xFF23232E),
      onBackground: Color(0xFFECECF1),
      subtle: Color(0xFF9A9AAD),
      outline: Color(0xFF3A3A4A),
      divider: Color(0xFF2E2E3C),
    ),
  };

  static ThemeData get lightTheme => themeFor(AppThemeTone.pink);

  static ThemeData themeFor(AppThemeTone tone) => _build(_palettes[tone]!);

  static ThemeData _build(_Palette p) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: p.primary,
        brightness: p.brightness,
        primary: p.primary,
        secondary: p.secondary,
        tertiary: p.tertiary,
        surface: p.surface,
        onSurface: p.onBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: p.background,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: p.onBackground,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: p.onBackground,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: p.onBackground,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: p.onBackground,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 15,
          color: p.onBackground,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 13,
          color: p.onBackground,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 11,
          color: p.subtle,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: p.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: p.onBackground,
        ),
        iconTheme: IconThemeData(color: p.onBackground),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: p.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        indicatorColor: p.primary.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: p.primary, size: 24);
          }
          return IconThemeData(color: p.subtle, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: p.primary,
            );
          }
          return GoogleFonts.poppins(fontSize: 12, color: p.subtle);
        }),
        elevation: 8,
        shadowColor: Colors.black12,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: GoogleFonts.poppins(color: p.subtle),
        hintStyle: GoogleFonts.poppins(color: p.subtle, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size(double.infinity, 52),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.primary,
          side: BorderSide(color: p.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size(double.infinity, 52),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.background,
        selectedColor: p.primary.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.poppins(fontSize: 13, color: p.onBackground),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: p.outline),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      dividerTheme: DividerThemeData(
        color: p.divider,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.onBackground,
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 13,
          color: p.background,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
