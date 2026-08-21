import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'logo_mark.dart';
import 'tap_scale.dart';

// ---------------------------------------------------------------------------
// Module-level constants
// ---------------------------------------------------------------------------

const double _kDesktopBarHeight = 88.0;
const double _kMobileBarHeight = 72.0;
const double _kLinkGap = 32.0;

const List<(String, String)> _kNavLinks = [
  ('Home', '/'),
  ('Our Story', '/our-story'),
  ('The Notebook', '/notebook'),
  ('Why It Works', '/why-it-works'),
  ('Customisation', '/customisation'),
  ('Contact', '/contact'),
];

bool _isActive(String location, String path) {
  if (path == '/') return location == '/';
  return location.startsWith(path);
}

// ---------------------------------------------------------------------------
// NavBar — public, holds only the bar (no overlay)
// ---------------------------------------------------------------------------

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.scrollOpacity,
    required this.menuOpen,
    required this.onMenuToggle,
  });

  final double scrollOpacity;
  final bool menuOpen;
  final VoidCallback onMenuToggle;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= Breakpoints.tablet;
    final barHeight = isDesktop ? _kDesktopBarHeight : _kMobileBarHeight;

    return SizedBox(
      height: barHeight,
      child: Stack(
        children: [
          // Frosted background — fades in as user scrolls
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: scrollOpacity,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xE0FAFAF7), // kaizenCream @ 88 %
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0x140B0B0F), // kaizenInk @ 8 %
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Content layer
          if (isDesktop)
            const _DesktopBar()
          else
            _MobileBar(menuOpen: menuOpen, onMenuToggle: onMenuToggle),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop bar
// ---------------------------------------------------------------------------

class _DesktopBar extends StatelessWidget {
  const _DesktopBar();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Left — logo
              const Align(
                alignment: Alignment.centerLeft,
                child: _NavLogoSection(),
              ),
              // Centre — link cluster (truly centred in the bar)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < _kNavLinks.length; i++) ...[
                    if (i > 0) const SizedBox(width: _kLinkGap),
                    _NavLink(
                      label: _kNavLinks[i].$1,
                      path: _kNavLinks[i].$2,
                      isActive: _isActive(location, _kNavLinks[i].$2),
                    ),
                  ],
                ],
              ),
              // Right — CTA pill
              const Align(
                alignment: Alignment.centerRight,
                child: _CtaPill(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Logo section (desktop only — custom sizing per spec)
// ---------------------------------------------------------------------------

class _NavLogoSection extends StatelessWidget {
  const _NavLogoSection();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Kaizen Solutions Notebooks — home',
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.go('/'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/kaizen_logo.png',
                height: 36,
                semanticLabel: 'Kaizen Solutions Notebooks logo',
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kaizen',
                    style: GoogleFonts.fraunces(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: kaizenInk,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    'SOLUTIONS NOTEBOOKS',
                    style: GoogleFonts.interTight(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: kaizenMuted,
                      letterSpacing: 2.0,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Nav link
// ---------------------------------------------------------------------------

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.path,
    required this.isActive,
  });

  final String label;
  final String path;
  final bool isActive;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink>
    with SingleTickerProviderStateMixin {
  late final AnimationController _underline;
  late final Animation<double> _curved;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _underline = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.isActive ? 1.0 : 0.0,
    );
    _curved = CurvedAnimation(parent: _underline, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(_NavLink old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !_hovered) {
      _underline.forward();
    } else if (!widget.isActive && !_hovered) {
      _underline.reverse();
    }
  }

  @override
  void dispose() {
    _underline.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _hovered = true);
          _underline.forward();
        },
        onExit: (_) {
          setState(() => _hovered = false);
          if (!widget.isActive) _underline.reverse();
        },
        child: GestureDetector(
          onTap: () => context.go(widget.path),
          child: Padding(
            // 11 px each side → 44 px minimum tap target
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    style: GoogleFonts.interTight(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: _hovered
                          ? kaizenBlue
                          : kaizenInk.withValues(alpha: 0.85),
                      height: 1.0,
                    ),
                    child: Text(
                      widget.label,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Gold underline — Transform.scale avoids IntrinsicWidth NaN
                  AnimatedBuilder(
                    animation: _curved,
                    builder: (_, __) => Transform.scale(
                      scaleX: _curved.value,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: kaizenGold,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CTA pill (desktop)
// ---------------------------------------------------------------------------

class _CtaPill extends StatefulWidget {
  const _CtaPill();

  @override
  State<_CtaPill> createState() => _CtaPillState();
}

class _CtaPillState extends State<_CtaPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Request a Proposal',
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: _hovered ? -1.0 : 0.0),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          builder: (_, dy, child) =>
              Transform.translate(offset: Offset(0, dy), child: child),
          child: TapScale(
            child: GestureDetector(
              onTap: () => context.go('/contact'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                height: 44,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color: _hovered ? kaizenBlue : kaizenInk,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: kaizenInk.withValues(
                          alpha: _hovered ? 0.28 : 0.20),
                      blurRadius: _hovered ? 18 : 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Request a Proposal',
                      style: GoogleFonts.interTight(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kaizenGold,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mobile bar
// ---------------------------------------------------------------------------

class _MobileBar extends StatefulWidget {
  const _MobileBar({
    required this.menuOpen,
    required this.onMenuToggle,
  });

  final bool menuOpen;
  final VoidCallback onMenuToggle;

  @override
  State<_MobileBar> createState() => _MobileBarState();
}

class _MobileBarState extends State<_MobileBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _icon;

  @override
  void initState() {
    super.initState();
    _icon = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.menuOpen ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(_MobileBar old) {
    super.didUpdateWidget(old);
    if (widget.menuOpen != old.menuOpen) {
      widget.menuOpen ? _icon.forward() : _icon.reverse();
    }
  }

  @override
  void dispose() {
    _icon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 480;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/'),
            child: LogoMark(height: 32, compact: !isWide),
          ),
          const Spacer(),
          Semantics(
            label: widget.menuOpen
                ? 'Close navigation menu'
                : 'Open navigation menu',
            button: true,
            child: GestureDetector(
              onTap: widget.onMenuToggle,
              child: SizedBox(
                width: 44,
                height: 44,
                child: Center(
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _icon,
                    color: kaizenInk,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MobileMenuOverlay — public, rendered full-screen from SiteScaffold
// ---------------------------------------------------------------------------

class MobileMenuOverlay extends StatefulWidget {
  const MobileMenuOverlay({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<MobileMenuOverlay> createState() => _MobileMenuOverlayState();
}

class _MobileMenuOverlayState extends State<MobileMenuOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    final reduceMotion = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.reduceMotion;
    if (reduceMotion) {
      _controller.value = 1.0;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 60 ms stagger per item on a 500 ms controller
  Animation<double> _stagger(int index) {
    const total = 500.0;
    const stagger = 60.0;
    const dur = 280.0;
    final start = (index * stagger / total).clamp(0.0, 1.0);
    final end = ((index * stagger + dur) / total).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  void _navigate(String path) {
    widget.onClose();
    context.go(path);
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kaizenCream,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header row ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s24,
                vertical: AppSpacing.s16,
              ),
              child: Row(
                children: [
                  const LogoMark(height: 32),
                  const Spacer(),
                  Semantics(
                    label: 'Close navigation menu',
                    button: true,
                    child: GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        child: const Icon(Icons.close,
                            size: 24, color: kaizenInk),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Contact info ─────────────────────────────────────────────────
            FadeTransition(
              opacity: _stagger(0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s32, 0, AppSpacing.s32, AppSpacing.s12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _launch(
                          'mailto:thekaizensolutions.hyd@gmail.com'),
                      child: Text(
                        'thekaizensolutions.hyd@gmail.com',
                        style: GoogleFonts.interTight(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: kaizenMuted,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: 12,
                      children: [
                        GestureDetector(
                          onTap: () => _launch('tel:+919989828388'),
                          child: Text(
                            '+91 99898 28388',
                            style: GoogleFonts.interTight(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: kaizenMuted,
                              height: 1.6,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _launch('tel:+918686960105'),
                          child: Text(
                            '+91 86869 60105',
                            style: GoogleFonts.interTight(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: kaizenMuted,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
                height: 1,
                color: kaizenInk.withValues(alpha: 0.10)),
            // ── Nav links ────────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < _kNavLinks.length; i++)
                      _buildLink(i),
                  ],
                ),
              ),
            ),
            // ── CTA ──────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s32,
                AppSpacing.s16,
                AppSpacing.s32,
                AppSpacing.s32,
              ),
              child: FadeTransition(
                opacity: _stagger(_kNavLinks.length + 1),
                child: GestureDetector(
                  onTap: () => _navigate('/contact'),
                  child: Container(
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kaizenInk,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Request a Proposal',
                      style: GoogleFonts.interTight(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: kaizenGold,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLink(int index) {
    final (label, path) = _kNavLinks[index];
    final anim = _stagger(index + 1); // +1: index 0 is contact info

    return FadeTransition(
      opacity: anim,
      child: AnimatedBuilder(
        animation: anim,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, (1.0 - anim.value) * 12.0),
          child: child,
        ),
        child: Semantics(
          label: label,
          button: true,
          child: GestureDetector(
            onTap: () => _navigate(path),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                label,
                style: GoogleFonts.fraunces(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: kaizenInk,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
