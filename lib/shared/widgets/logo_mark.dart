import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class LogoMark extends StatelessWidget {
  const LogoMark({
    super.key,
    this.height = 40,
    this.compact = false,
  });

  final double height;

  /// When true, only the logo image is shown — wordmark is hidden.
  /// Use on mobile screens or inside compact nav contexts.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/kaizen_logo.png',
          height: height,
          semanticLabel: 'Kaizen Solutions Notebooks logo',
        ),
        if (!compact) ...[
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kaizen',
                style: GoogleFonts.fraunces(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: kaizenInk,
                  height: 1.1,
                ),
              ),
              Text(
                'SOLUTIONS NOTEBOOKS',
                style: GoogleFonts.interTight(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500,
                  color: kaizenMuted,
                  letterSpacing: 2.0,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
