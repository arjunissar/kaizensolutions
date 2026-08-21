import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_colors.dart';

const _kSplashHold = Duration(milliseconds: 3000);

/// Full-screen overlay shown once on cold start, on top of whatever route
/// was requested — the router still resolves normally underneath, so a
/// direct link (e.g. /contact) lands correctly once this fades out. Loops
/// assets/animations/2.json for [_kSplashHold], then calls [onFinished].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _fadingOut = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    final reduceMotion = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .reduceMotion;
    if (reduceMotion) {
      // Don't force a looping animation on someone who's asked for reduced
      // motion — skip straight to the site.
      WidgetsBinding.instance.addPostFrameCallback((_) => _finish());
    } else {
      // Fixed hold, independent of the Lottie file loading/looping — this
      // is the only trigger, so a failed load can't strand the visitor here.
      Future.delayed(_kSplashHold, _finish);
    }
  }

  void _finish() {
    if (_fadingOut || !mounted) return;
    setState(() => _fadingOut = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _fadingOut ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      child: ColoredBox(
        color: kaizenCream,
        child: Center(
          child: SizedBox(
            width: 260,
            height: 260,
            child: Lottie.asset(
              'assets/animations/2.json',
              controller: _controller,
              repeat: true,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..repeat();
              },
            ),
          ),
        ),
      ),
    );
  }
}
