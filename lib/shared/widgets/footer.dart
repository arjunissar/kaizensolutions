import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/responsive/breakpoints.dart';
import 'logo_mark.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  static const _navLinks = [
    ('Home', '/'),
    ('Our Story', '/our-story'),
    ('The Notebook', '/notebook'),
    ('Why It Works', '/why-it-works'),
    ('Customisation', '/customisation'),
    ('Contact', '/contact'),
  ];

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kaizenCream, kaizenPaper],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 1, color: kaizenPaper),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s32,
              vertical: AppSpacing.s64,
            ),
            child: isDesktop
                ? _DesktopColumns(
                    navLinks: _navLinks,
                    onLaunch: _launch,
                  )
                : _MobileColumns(
                    navLinks: _navLinks,
                    onLaunch: _launch,
                  ),
          ),
          const Divider(height: 1, color: kaizenPaper),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s32,
              vertical: AppSpacing.s24,
            ),
            child: isDesktop
                ? Row(
                    children: [
                      Text(
                        '© ${DateTime.now().year} Kaizen Solutions. All rights reserved.',
                        style:
                            AppTypography.caption.copyWith(color: kaizenMuted),
                      ),
                      const Spacer(),
                      Text(
                        'CBSE-aligned · Made in India',
                        style:
                            AppTypography.caption.copyWith(color: kaizenMuted),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '© ${DateTime.now().year} Kaizen Solutions. All rights reserved.',
                        style:
                            AppTypography.caption.copyWith(color: kaizenMuted),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        'CBSE-aligned · Made in India',
                        style:
                            AppTypography.caption.copyWith(color: kaizenMuted),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop 4-column row
// ---------------------------------------------------------------------------

class _DesktopColumns extends StatelessWidget {
  const _DesktopColumns({
    required this.navLinks,
    required this.onLaunch,
  });

  final List<(String, String)> navLinks;
  final Future<void> Function(String) onLaunch;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Col A: brand
        Expanded(
          flex: 3,
          child: _ColBrand(),
        ),
        const SizedBox(width: AppSpacing.s48),
        // Col B: navigate
        Expanded(
          flex: 2,
          child: _ColNavigate(links: navLinks),
        ),
        const SizedBox(width: AppSpacing.s48),
        // Col C: contact
        Expanded(
          flex: 2,
          child: _ColContact(onLaunch: onLaunch),
        ),
        const SizedBox(width: AppSpacing.s48),
        // Col D: CTA
        Expanded(
          flex: 2,
          child: _ColCta(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Mobile stacked columns
// ---------------------------------------------------------------------------

class _MobileColumns extends StatelessWidget {
  const _MobileColumns({
    required this.navLinks,
    required this.onLaunch,
  });

  final List<(String, String)> navLinks;
  final Future<void> Function(String) onLaunch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ColBrand(),
        const SizedBox(height: AppSpacing.s48),
        _ColNavigate(links: navLinks),
        const SizedBox(height: AppSpacing.s48),
        _ColContact(onLaunch: onLaunch),
        const SizedBox(height: AppSpacing.s48),
        _ColCta(),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Col A — Brand + tagline + mission
// ---------------------------------------------------------------------------

class _ColBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LogoMark(height: 36),
        const SizedBox(height: AppSpacing.s16),
        Text(
          'Capture Learning. Create Progress.',
          style: AppTypography.bodyM.copyWith(
            color: kaizenInk,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          'Purpose-built for CBSE schools. One notebook per class and subject — curriculum-aligned, pedagogically grounded, and crafted for the Indian classroom.',
          style: AppTypography.bodyS.copyWith(color: kaizenMuted),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Col B — Navigate links
// ---------------------------------------------------------------------------

class _ColNavigate extends StatelessWidget {
  const _ColNavigate({required this.links});

  final List<(String, String)> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Navigate',
          style: AppTypography.label.copyWith(color: kaizenInk),
        ),
        const SizedBox(height: AppSpacing.s16),
        for (final (label, path) in links)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: _FooterLink(label: label, path: path),
          ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({required this.label, required this.path});

  final String label;
  final String path;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => context.go(widget.path),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: AppTypography.bodyS.copyWith(
                  color: _hovered ? kaizenBlue : kaizenMuted,
                ),
                child: Text(widget.label),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Col C — Contact info (url_launcher)
// ---------------------------------------------------------------------------

class _ColContact extends StatelessWidget {
  const _ColContact({required this.onLaunch});

  final Future<void> Function(String) onLaunch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: AppTypography.label.copyWith(color: kaizenInk),
        ),
        const SizedBox(height: AppSpacing.s16),
        Text(
          'KPHB Colony, Hyderabad\nIndia – 500072',
          style: AppTypography.bodyS.copyWith(color: kaizenMuted),
        ),
        const SizedBox(height: AppSpacing.s16),
        _TapLink(
          label: 'thekaizensolutions.hyd@gmail.com',
          url: 'mailto:thekaizensolutions.hyd@gmail.com',
          onLaunch: onLaunch,
        ),
        const SizedBox(height: AppSpacing.s12),
        _TapLink(
          label: '+91 99898 28388',
          url: 'tel:+919989828388',
          onLaunch: onLaunch,
        ),
        const SizedBox(height: AppSpacing.s8),
        _TapLink(
          label: '+91 86869 60105',
          url: 'tel:+918686960105',
          onLaunch: onLaunch,
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          'Mon–Sat · 10:00 AM – 6:00 PM IST',
          style: AppTypography.caption.copyWith(color: kaizenMuted),
        ),
      ],
    );
  }
}

class _TapLink extends StatefulWidget {
  const _TapLink({
    required this.label,
    required this.url,
    required this.onLaunch,
  });

  final String label;
  final String url;
  final Future<void> Function(String) onLaunch;

  @override
  State<_TapLink> createState() => _TapLinkState();
}

class _TapLinkState extends State<_TapLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      link: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => widget.onLaunch(widget.url),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: AppTypography.bodyS.copyWith(
                  color: _hovered ? kaizenBlue : kaizenInk,
                  decoration:
                      _hovered ? TextDecoration.underline : TextDecoration.none,
                  decorationColor: kaizenBlue,
                ),
                child: Text(widget.label),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Col D — Tagline + CTA button
// ---------------------------------------------------------------------------

class _ColCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Built for schools that\nvalue learning.',
          style: AppTypography.headingS.copyWith(color: kaizenInk),
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          'Tell us about your school and we\'ll put together a tailored proposal — at no obligation.',
          style: AppTypography.bodyS.copyWith(color: kaizenMuted),
        ),
        const SizedBox(height: AppSpacing.s24),
        Semantics(
          label: 'Talk to us — navigate to Contact page',
          button: true,
          child: GestureDetector(
            onTap: () => context.go('/contact'),
            child: Container(
              constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s24,
                vertical: AppSpacing.s12,
              ),
              decoration: BoxDecoration(
                color: kaizenGold,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Talk to us',
                style: AppTypography.label.copyWith(color: kaizenInk),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
