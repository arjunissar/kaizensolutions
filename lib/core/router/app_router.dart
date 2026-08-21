import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../features/about/about_page.dart';
import '../../features/contact/contact_page.dart';
import '../../features/customisation/customisation_page.dart';
import '../../features/home/home_page.dart';
import '../../features/product/product_page.dart';
import '../../features/psychology/psychology_page.dart';
import '../../shared/widgets/page_scroll_view.dart';
import '../../shared/widgets/site_scaffold.dart';

// ---------------------------------------------------------------------------
// Fade + slight rise transition helper
// ---------------------------------------------------------------------------

CustomTransitionPage<void> _fadeRisePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.of(context).disableAnimations) return child;
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.015),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) =>
      const SiteScaffold(child: _NotFoundPage()),
  routes: [
    ShellRoute(
      builder: (context, state, child) => SiteScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _fadeRisePage(
            key: state.pageKey,
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: '/our-story',
          pageBuilder: (context, state) => _fadeRisePage(
            key: state.pageKey,
            child: const AboutPage(),
          ),
        ),
        GoRoute(
          path: '/notebook',
          pageBuilder: (context, state) => _fadeRisePage(
            key: state.pageKey,
            child: const ProductPage(),
          ),
        ),
        GoRoute(
          path: '/why-it-works',
          pageBuilder: (context, state) => _fadeRisePage(
            key: state.pageKey,
            child: const PsychologyPage(),
          ),
        ),
        GoRoute(
          path: '/customisation',
          pageBuilder: (context, state) => _fadeRisePage(
            key: state.pageKey,
            child: const CustomisationPage(),
          ),
        ),
        GoRoute(
          path: '/contact',
          pageBuilder: (context, state) => _fadeRisePage(
            key: state.pageKey,
            child: const ContactPage(),
          ),
        ),
      ],
    ),
  ],
);

// ---------------------------------------------------------------------------
// 404
// ---------------------------------------------------------------------------

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final isDesktop = screenW > 1024;

    return PageScrollView(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lost the thread?',
                  style: AppTypography.displayM.copyWith(
                    color: kaizenInk,
                    fontSize: (screenW * 0.06).clamp(32.0, 56.0),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s24),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: AppSpacing.maxReadingWidth),
                  child: Text(
                    'Even the best students occasionally take a wrong turn. '
                    'Let\'s get you back.',
                    style: AppTypography.bodyL.copyWith(color: kaizenMuted),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.s48),
                _BackHomeButton(isDesktop: isDesktop),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackHomeButton extends StatefulWidget {
  const _BackHomeButton({required this.isDesktop});
  final bool isDesktop;

  @override
  State<_BackHomeButton> createState() => _BackHomeButtonState();
}

class _BackHomeButtonState extends State<_BackHomeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Back to home',
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => context.go('/'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            constraints: const BoxConstraints(minHeight: 52, minWidth: 44),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s40,
              vertical: AppSpacing.s16,
            ),
            decoration: BoxDecoration(
              color: _hovered ? kaizenGoldDeep : kaizenGold,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: kaizenGold.withValues(alpha: _hovered ? 0.45 : 0.25),
                  blurRadius: _hovered ? 20 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              'Back to home',
              style: AppTypography.label.copyWith(
                color: kaizenInk,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
