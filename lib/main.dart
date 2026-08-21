import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: to fully cache fonts for offline/offline-first use, download the
  // Fraunces and Inter Tight font files, declare them in pubspec.yaml under
  // fonts:, and set GoogleFonts.config.allowRuntimeFetching = false;
  // For now, the Google Fonts CDN serves fonts with long-lived cache headers.
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(const KaizenApp());
}
