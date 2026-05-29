import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum EidThemeType { fitr, adha }

class AppTheme {
  static const Color primaryNavy = Color(0xFF0A1929);
  static const Color fitrGreen = Color(0xFF00FF88);
  static const Color adhaGold = Color(0xFFFFD700);
  static const Color textWhite = Color(0xFFFFFFFF);

  static ThemeData getTheme(EidThemeType type) {
    final isFitr = type == EidThemeType.fitr;
    final accentColor = isFitr ? fitrGreen : adhaGold;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: primaryNavy,
      primaryColor: primaryNavy,
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: primaryNavy,
        background: primaryNavy,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.amiri(color: textWhite, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.amiri(color: textWhite, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.poppins(color: textWhite, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.poppins(color: textWhite),
        bodyMedium: GoogleFonts.poppins(color: textWhite),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: primaryNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
