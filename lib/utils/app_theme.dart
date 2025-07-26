import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../bindings/app_bindings.dart';

class AppTheme {
  // Colors
  static const Color primarySaffron = Color(0xFFFF9933);
  static const Color secondarySaffron = Color(0xFFFFB366);
  static const Color spiritualBlue = Color(0xFF1A237E);
  static const Color deepBlue = Color(0xFF0D47A1);
  static const Color sacredGold = Color(0xFFFFD700);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color lightCream = Color(0xFFFFF8E1);
  static const Color darkBrown = Color(0xFF3E2723);
  static const Color lightBrown = Color(0xFF8D6E63);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color textColor = Color(0xFF3E2723); // Same as darkBrown for consistency

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primarySaffron, secondarySaffron],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient spiritualGradient = LinearGradient(
    colors: [spiritualBlue, deepBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sacredGradient = LinearGradient(
    colors: [sacredGold, primarySaffron],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Theme Data
  static ThemeData get theme {
    return ThemeData(
      primaryColor: primarySaffron,
      scaffoldBackgroundColor: lightCream,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primarySaffron,
        secondary: spiritualBlue,
        surface: pureWhite,
        background: lightCream,
        error: errorRed,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkBrown,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: darkBrown,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkBrown,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkBrown,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkBrown,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkBrown,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: darkBrown,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: darkBrown,
        ),
      ),
      cardTheme: CardThemeData(
        color: pureWhite,
        elevation: 8,
        shadowColor: darkBrown.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySaffron,
          foregroundColor: pureWhite,
          elevation: 4,
          shadowColor: primarySaffron.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primarySaffron,
        foregroundColor: pureWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: pureWhite,
        ),
        iconTheme: const IconThemeData(color: pureWhite),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: spiritualBlue,
        foregroundColor: pureWhite,
        elevation: 8,
      ),
    );
  }

  static Color get primaryColor => primarySaffron;

  // Text Styles
  static TextStyle get chapterTitleStyle => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: darkBrown,
  );

  static TextStyle get slokTextStyle => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: darkBrown,
    height: 1.5,
  );

  static TextStyle get sanskritTextStyle => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: spiritualBlue,
    fontStyle: FontStyle.italic,
  );

  static TextStyle get meaningTextStyle => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: lightBrown,
    height: 1.4,
  );

  // Decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: pureWhite,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: darkBrown.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get chapterCardDecoration => BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: primarySaffron.withOpacity(0.3),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get slokCardDecoration => BoxDecoration(
    color: pureWhite,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: primarySaffron.withOpacity(0.2), width: 1),
    boxShadow: [
      BoxShadow(
        color: darkBrown.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
