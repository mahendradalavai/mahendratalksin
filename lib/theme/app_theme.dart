import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ─────────────────────────────────────────────
///  APP THEME  —  Mahendra Talks
///  Dark (#0F0F0F) + Yellow/Amber (#FFC107)
/// ─────────────────────────────────────────────
class AppTheme {
  // ── Colours ──────────────────────────────────
  static const Color background    = Color(0xFF0F0F0F);
  static const Color surface       = Color(0xFF1A1A1A);
  static const Color card          = Color(0xFF222222);
  static const Color accent        = Color(0xFFFFC107);
  static const Color accentDark    = Color(0xFFFF8F00);
  static const Color accentLight   = Color(0xFFFFECB3);
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color border        = Color(0xFF2E2E2E);
  static const Color glass         = Color(0x1AFFFFFF); // 10% white

  // ── Gradients ────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F0F0F), Color(0xFF1C1500), Color(0xFF0F0F0F)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFFFFC107), Color(0xFFFF8F00)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
  );

  // ── Glow ─────────────────────────────────────
  static List<BoxShadow> yellowGlow = [
    BoxShadow(
      color: accent.withValues(alpha: 0.4),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> softGlow = [
    BoxShadow(
      color: accent.withValues(alpha: 0.15),
      blurRadius: 30,
      spreadRadius: 5,
    ),
  ];

  // ── Text Styles ───────────────────────────────
  static TextStyle displayLarge({Color color = textPrimary, double size = 48}) =>
      GoogleFonts.bebasNeue(
        fontSize: size,
        color: color,
        letterSpacing: 2,
        height: 1.0,
      );

  static TextStyle headingMedium({Color color = textPrimary, double size = 24}) =>
      GoogleFonts.bebasNeue(
        fontSize: size,
        color: color,
        letterSpacing: 1.5,
      );

  static TextStyle bodyLarge({Color color = textPrimary, double size = 16}) =>
      GoogleFonts.poppins(
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle bodyMedium({Color color = textSecondary, double size = 14}) =>
      GoogleFonts.poppins(
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle labelBold({Color color = textPrimary, double size = 13}) =>
      GoogleFonts.poppins(
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      );

  static TextStyle tagline({Color color = textSecondary}) =>
      GoogleFonts.poppins(
        fontSize: 13,
        color: color,
        fontWeight: FontWeight.w300,
        letterSpacing: 2,
      );

  // ── ThemeData ─────────────────────────────────
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.dark(
          primary: accent,
          secondary: accentDark,
          surface: surface,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          titleTextStyle: headingMedium(size: 20),
          iconTheme: const IconThemeData(color: accent),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surface,
          indicatorColor: accent.withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.all(
            labelBold(color: textSecondary, size: 11),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: accent, size: 24);
            }
            return const IconThemeData(color: Colors.grey, size: 22);
          }),
        ),
        useMaterial3: true,
      );

  // ── Decorations ───────────────────────────────
  static BoxDecoration glassCard({double radius = 16}) => BoxDecoration(
        color: glass,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border, width: 1),
        gradient: cardGradient,
      );

  static BoxDecoration accentBorder({double radius = 16}) => BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: accent.withValues(alpha: 0.4), width: 1.2),
        color: surface,
      );
}
