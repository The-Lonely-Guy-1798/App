// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- NEW: A reusable gradient for the entire app ---
  static const appBackgroundGradient = LinearGradient(
    colors: [Color(0xFF2C3E50), Color(0xFF000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // --- MODIFIED: The light theme is kept clean and simple ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    fontFamily: GoogleFonts.exo2().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
      titleTextStyle: GoogleFonts.orbitron(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF009688), // Teal
      secondary: Color(0xFFf50057), // Pink accent
      surface: Color(0xFFFFFFFF),
      onSurface: Colors.black87,
    ),
  );

  // --- MODIFIED: The dark theme now embodies the "gaming" aesthetic ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // This is the key: make the default scaffold background transparent
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: GoogleFonts.exo2().fontFamily,
    appBarTheme: AppBarTheme(
      // App bars are also transparent to let the gradient show through
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.orbitron(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardColor: Colors.white.withAlpha(15), // Very subtle, translucent cards
    colorScheme: const ColorScheme.dark(
      primary: Colors.cyanAccent,
      secondary: Color(0xFFf50057), // Pink accent
      surface: Color(0xFF1A222C), // Dark surface for dialogs, etc.
      onSurface: Colors.white,
    ),
  );
}
