import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  // Display — Fraunces, lineHeight 1.05
  static final TextStyle displayXL = GoogleFonts.fraunces(
    fontSize: 72,
    fontWeight: FontWeight.w700,
    height: 1.05,
  );

  static final TextStyle displayL = GoogleFonts.fraunces(
    fontSize: 56,
    fontWeight: FontWeight.w700,
    height: 1.05,
  );

  static final TextStyle displayM = GoogleFonts.fraunces(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    height: 1.05,
  );

  // Headings — Fraunces, lineHeight 1.15
  static final TextStyle headingL = GoogleFonts.fraunces(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.15,
  );

  static final TextStyle headingM = GoogleFonts.fraunces(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.15,
  );

  static final TextStyle headingS = GoogleFonts.fraunces(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.15,
  );

  // Body / UI — Inter Tight, lineHeight 1.6
  static final TextStyle bodyL = GoogleFonts.interTight(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static final TextStyle bodyM = GoogleFonts.interTight(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static final TextStyle bodyS = GoogleFonts.interTight(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static final TextStyle label = GoogleFonts.interTight(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.15,
  );

  static final TextStyle caption = GoogleFonts.interTight(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
}
