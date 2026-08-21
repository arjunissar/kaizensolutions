import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

class KaizenApp extends StatefulWidget {
  const KaizenApp({super.key});

  @override
  State<KaizenApp> createState() => _KaizenAppState();
}

class _KaizenAppState extends State<KaizenApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kaizen Solutions Notebooks',
      theme: lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      // The splash overlays whatever route was requested — routing still
      // resolves normally underneath, so a direct link lands correctly the
      // moment the splash fades out.
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            if (_showSplash)
              SplashScreen(
                onFinished: () => setState(() => _showSplash = false),
              ),
          ],
        );
      },
    );
  }
}
