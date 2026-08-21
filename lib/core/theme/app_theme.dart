import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: kaizenCream,
  colorScheme: const ColorScheme.light(
    primary: kaizenGold,
    onPrimary: kaizenInk,
    secondary: kaizenBlue,
    onSecondary: kaizenCream,
    surface: kaizenCream,
    onSurface: kaizenInk,
    error: Color(0xFFB00020),
  ),
  textTheme: GoogleFonts.interTightTextTheme().copyWith(
    displayLarge: GoogleFonts.fraunces(
      fontSize: 72,
      fontWeight: FontWeight.w700,
      height: 1.05,
      color: kaizenInk,
    ),
    displayMedium: GoogleFonts.fraunces(
      fontSize: 56,
      fontWeight: FontWeight.w700,
      height: 1.05,
      color: kaizenInk,
    ),
    displaySmall: GoogleFonts.fraunces(
      fontSize: 40,
      fontWeight: FontWeight.w600,
      height: 1.05,
      color: kaizenInk,
    ),
    headlineLarge: GoogleFonts.fraunces(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.15,
      color: kaizenInk,
    ),
    headlineMedium: GoogleFonts.fraunces(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.15,
      color: kaizenInk,
    ),
    headlineSmall: GoogleFonts.fraunces(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.15,
      color: kaizenInk,
    ),
    bodyLarge: GoogleFonts.interTight(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: kaizenInk,
    ),
    bodyMedium: GoogleFonts.interTight(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: kaizenInk,
    ),
    bodySmall: GoogleFonts.interTight(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: kaizenMuted,
    ),
    labelLarge: GoogleFonts.interTight(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.15,
      color: kaizenInk,
    ),
    labelSmall: GoogleFonts.interTight(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: kaizenMuted,
    ),
  ),
  focusColor: kaizenGold,
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: kaizenGold, width: 2),
      foregroundColor: kaizenInk,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      minimumSize: const Size(44, 44),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kaizenGold,
      foregroundColor: kaizenInk,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      minimumSize: const Size(44, 44),
    ),
  ),
);
