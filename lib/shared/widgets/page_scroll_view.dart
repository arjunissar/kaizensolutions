import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import 'footer.dart';

class PageScrollView extends StatelessWidget {
  const PageScrollView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.navBarHeight),
          child,
          const Footer(),
        ],
      ),
    );
  }
}
