import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/animated_reveal.dart';
import '../../shared/widgets/page_scroll_view.dart';
import '../../shared/widgets/tap_scale.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroSection(),
          _PhilosophyBand(),
          _WhatItIsSection(),
          _StatsStrip(),
          _FinalCtaSection(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared constraint helper
// ---------------------------------------------------------------------------

Widget _section({
  required Widget child,
  EdgeInsets padding = const EdgeInsets.symmetric(
    horizontal: AppSpacing.s32,
    vertical: AppSpacing.s96,
  ),
}) {
  return Padding(
    padding: padding,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: child,
      ),
    ),
  );
}

// ===========================================================================
// SECTION 1 — HERO
// ===========================================================================

class _HeroSection extends StatefulWidget {
  const _HeroSection();

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final ValueNotifier<Offset?> _mousePos = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      if (reduceMotion) {
        _ctrl.value = 1.0;
      } else {
        _ctrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _mousePos.dispose();
    super.dispose();
  }

  Widget _stagger(int index, Widget child) {
    final start = (index * 0.13).clamp(0.0, 0.65);
    final end = (start + 0.38).clamp(0.0, 1.0);
    final anim = CurvedAnimation(
      parent: _ctrl,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: anim,
      child: AnimatedBuilder(
        animation: anim,
        builder: (_, ch) => Transform.translate(
          offset: Offset(0, 16 * (1 - anim.value)),
          child: ch,
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // FUTURE: When real product photography is available, the right
    // column (currently the Lottie animation) can be replaced with a
    // single full-bleed photograph of the notebook. Recommended
    // composition: notebook open on a wooden surface, warm natural light,
    // ~3/4 angle, shallow depth of field. The pull-quote can move into a
    // separate section further down the page.
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width > Breakpoints.tablet;
    final heroHeight = math.max(size.height, 720.0);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final showGlow = isDesktop && !reduceMotion;

    return MouseRegion(
      onHover: showGlow ? (e) => _mousePos.value = e.localPosition : null,
      child: Container(
        constraints: BoxConstraints(minHeight: heroHeight),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.65, -0.75),
            radius: 1.15,
            colors: [kaizenGold.withValues(alpha: 0.20), kaizenCream],
          ),
        ),
        child: Stack(
          children: [
            // Grain overlay
            Positioned.fill(child: CustomPaint(painter: _GrainPainter())),
            // Cursor glow (desktop only, reduced-motion aware)
            if (showGlow)
              Positioned.fill(
                child: IgnorePointer(child: _GlowLayer(mousePos: _mousePos)),
              ),
            _section(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.s32,
                vertical: isDesktop ? AppSpacing.s96 : AppSpacing.s64,
              ),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 7,
                          child: _HeroLeftCol(stagger: _stagger),
                        ),
                        const SizedBox(width: AppSpacing.s64),
                        Expanded(
                          flex: 5,
                          child: _HeroLottie(animate: !reduceMotion),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _HeroLeftCol(stagger: _stagger),
                        const SizedBox(height: AppSpacing.s48),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 320),
                            child: _HeroLottie(animate: !reduceMotion),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroLottie extends StatelessWidget {
  const _HeroLottie({required this.animate});

  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // Decorative — the adjacent headline and body copy already carry
      // the hero's meaning.
      excludeSemantics: true,
      child: AspectRatio(
        // Matches animations/1.json's native composition (1080x950).
        aspectRatio: 1080 / 950,
        child: Lottie.asset(
          'assets/animations/1.json',
          animate: animate,
          repeat: true,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// Deterministic grain dots — fixed positions so paint never changes
class _GrainPainter extends CustomPainter {
  static const _pts = [
    (0.04, 0.09),
    (0.11, 0.28),
    (0.07, 0.52),
    (0.19, 0.74),
    (0.03, 0.91),
    (0.24, 0.14),
    (0.31, 0.38),
    (0.28, 0.63),
    (0.37, 0.87),
    (0.22, 0.97),
    (0.44, 0.06),
    (0.51, 0.31),
    (0.47, 0.55),
    (0.58, 0.78),
    (0.41, 0.82),
    (0.63, 0.11),
    (0.69, 0.42),
    (0.72, 0.66),
    (0.65, 0.89),
    (0.77, 0.04),
    (0.83, 0.24),
    (0.88, 0.49),
    (0.91, 0.71),
    (0.96, 0.16),
    (0.80, 0.93),
    (0.13, 0.44),
    (0.35, 0.22),
    (0.56, 0.58),
    (0.74, 0.35),
    (0.92, 0.85),
    (0.08, 0.77),
    (0.29, 0.05),
    (0.49, 0.19),
    (0.67, 0.53),
    (0.85, 0.69),
    (0.17, 0.61),
    (0.39, 0.83),
    (0.54, 0.41),
    (0.71, 0.13),
    (0.93, 0.37),
    (0.02, 0.33),
    (0.15, 0.88),
    (0.43, 0.07),
    (0.60, 0.95),
    (0.78, 0.27),
    (0.21, 0.49),
    (0.46, 0.72),
    (0.62, 0.20),
    (0.88, 0.57),
    (0.99, 0.44),
    (0.10, 0.17),
    (0.32, 0.66),
    (0.53, 0.34),
    (0.76, 0.80),
    (0.94, 0.10),
    (0.06, 0.58),
    (0.26, 0.29),
    (0.50, 0.88),
    (0.70, 0.48),
    (0.87, 0.22),
    (0.14, 0.70),
    (0.38, 0.11),
    (0.57, 0.79),
    (0.82, 0.39),
    (0.97, 0.63),
    (0.09, 0.40),
    (0.33, 0.57),
    (0.48, 0.26),
    (0.66, 0.91),
    (0.84, 0.05),
    (0.18, 0.83),
    (0.42, 0.47),
    (0.61, 0.15),
    (0.79, 0.60),
    (0.95, 0.76),
    (0.05, 0.23),
    (0.27, 0.72),
    (0.55, 0.50),
    (0.73, 0.08),
    (0.90, 0.34),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF000000).withValues(alpha: 0.035)
      ..style = PaintingStyle.fill;
    for (final (fx, fy) in _pts) {
      canvas.drawCircle(Offset(fx * size.width, fy * size.height), 1.4, paint);
    }
  }

  @override
  bool shouldRepaint(_GrainPainter old) => false;
}

// Cursor-following gold glow — desktop only, lerps 6% per frame
class _GlowLayer extends StatefulWidget {
  const _GlowLayer({required this.mousePos});
  final ValueNotifier<Offset?> mousePos;

  @override
  State<_GlowLayer> createState() => _GlowLayerState();
}

class _GlowLayerState extends State<_GlowLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  Offset _current = const Offset(600, 300);

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          )
          ..addListener(_onFrame)
          ..repeat();
  }

  void _onFrame() {
    final target = widget.mousePos.value;
    if (target == null) return;
    final next = Offset.lerp(_current, target, 0.06)!;
    if ((next.dx - _current.dx).abs() + (next.dy - _current.dy).abs() > 0.5) {
      setState(() => _current = next);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GlowPainter(_current));
  }
}

class _GlowPainter extends CustomPainter {
  const _GlowPainter(this.center);
  final Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 200.0;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color(0xFFFFC72C).withValues(alpha: 0.13),
          Color(0xFFFFC72C).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_GlowPainter old) => old.center != center;
}

// Left text column — accepts the stagger function from parent
class _HeroLeftCol extends StatelessWidget {
  const _HeroLeftCol({required this.stagger});

  final Widget Function(int, Widget) stagger;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final headlineFontSize = (screenW * 0.072).clamp(64.0, 112.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Eyebrow
        stagger(
          0,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 4, height: 4, color: kaizenGold),
              const SizedBox(width: AppSpacing.s8),
              // kaizenGold text on kaizenCream fails WCAG contrast (~1.4:1);
              // kaizenBlueDeep reads as the same premium accent at ~13:1.
              Text(
                'KAIZEN SOLUTIONS NOTEBOOKS',
                style: AppTypography.caption.copyWith(
                  color: kaizenBlueDeep,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        // Headline
        stagger(
          1,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Every page, a ',
                  style: GoogleFonts.fraunces(
                    fontSize: headlineFontSize,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    color: kaizenInk,
                  ),
                ),
                TextSpan(
                  text: 'small step forward.',
                  style: GoogleFonts.fraunces(
                    fontSize: headlineFontSize,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    fontStyle: FontStyle.italic,
                    color: kaizenBlueDeep,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s32),
        // Sub-headline
        stagger(
          2,
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxReadingWidth,
            ),
            child: Text(
              'Curriculum-aligned notebooks that merge concept clarity, '
              'visual learning, and structured note-taking — designed for CBSE schools.',
              style: GoogleFonts.interTight(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 1.6,
                color: kaizenMuted,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s40),
        // CTAs
        stagger(
          3,
          Wrap(
            spacing: AppSpacing.s16,
            runSpacing: AppSpacing.s12,
            children: [
              _HeroCta(
                label: 'Request a Proposal',
                onTap: () => context.go('/contact'),
                filled: true,
              ),
              _HeroCta(
                label: 'See the Notebook',
                onTap: () => context.go('/notebook'),
                filled: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s32),
        // Trust chips
        stagger(
          4,
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: const [
              _TrustChip('CBSE-Aligned'),
              _TrustChip('Made in India'),
              _TrustChip('25+ Years of Classroom Insight'),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroCta extends StatefulWidget {
  const _HeroCta({
    required this.label,
    required this.onTap,
    required this.filled,
  });

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  State<_HeroCta> createState() => _HeroCtaState();
}

class _HeroCtaState extends State<_HeroCta> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.filled
        ? (_hovered ? kaizenGoldDeep : kaizenGold)
        : Colors.transparent;
    final border = widget.filled
        ? BorderSide.none
        : BorderSide(
            color: _hovered ? kaizenInk : kaizenInk.withValues(alpha: 0.5),
            width: 1.5,
          );

    return TapScale(
      child: Semantics(
        label: widget.label,
        button: true,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              constraints: const BoxConstraints(minHeight: 52, minWidth: 44),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s32,
                vertical: AppSpacing.s16,
              ),
              decoration: BoxDecoration(
                color: bg,
                border: Border.fromBorderSide(border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.label,
                style: AppTypography.label.copyWith(
                  color: kaizenInk,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrustChip extends StatelessWidget {
  const _TrustChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: kaizenInk.withValues(alpha: 0.14)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(color: kaizenInk),
      ),
    );
  }
}

// ===========================================================================
// SECTION 2 — PHILOSOPHY BAND
// ===========================================================================

class _PhilosophyBand extends StatefulWidget {
  const _PhilosophyBand();

  @override
  State<_PhilosophyBand> createState() => _PhilosophyBandState();
}

class _PhilosophyBandState extends State<_PhilosophyBand> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return VisibilityDetector(
      key: const Key('philosophy-band'),
      onVisibilityChanged: (info) {
        if (!_visible && info.visibleFraction > 0.3) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        constraints: BoxConstraints(minHeight: isDesktop ? 240 : 200),
        color: kaizenBlueDeep,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s32,
              vertical: AppSpacing.s64,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '“Kaizen — the quiet discipline of becoming\na little better, every single day.”'
                      .breaks(keep: isDesktop),
                  style: GoogleFonts.fraunces(
                    fontSize: isDesktop ? 28 : 22,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                    color: kaizenGold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(
                  '— THE PRINCIPLE BEHIND EVERY NOTEBOOK',
                  style: AppTypography.caption.copyWith(
                    color: kaizenGold.withValues(alpha: 0.65),
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s24),
                // Animated underline
                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  height: 2,
                  width: _visible ? 100.0 : 0.0,
                  decoration: BoxDecoration(
                    color: kaizenGold,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// SECTION 3 — WHAT IT IS (three cards)
// ===========================================================================

class _WhatItIsSection extends StatelessWidget {
  const _WhatItIsSection();

  static const _cards = [
    (
      '01',
      'Concept Clarity',
      'Chapter overviews, mind maps, and diagrams that simplify complex CBSE topics at exactly the right grade level.',
    ),
    (
      '02',
      'Visual Learning',
      'Charts, flows, and highlighted summaries turn abstract ideas into pictures students remember.',
    ),
    (
      '03',
      'Structured Practice',
      'High-GSM paper and guided writing spaces that turn daily notes into lasting habits.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return ColoredBox(
      color: kaizenCream,
      child: _section(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedReveal(
              child: Text(
                'One notebook. Three jobs.',
                style: AppTypography.headingL.copyWith(color: kaizenInk),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AnimatedReveal(
              delay: const Duration(milliseconds: 80),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSpacing.maxReadingWidth,
                ),
                child: Text(
                  'We fused concept clarity, visual learning, and writing practice into a single tool.',
                  style: AppTypography.bodyL.copyWith(color: kaizenMuted),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s64),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _cards.length; i++) ...[
                    Expanded(
                      child: AnimatedReveal(
                        delay: Duration(milliseconds: i * 100),
                        child: _WhatItIsCard(
                          numeral: _cards[i].$1,
                          title: _cards[i].$2,
                          body: _cards[i].$3,
                        ),
                      ),
                    ),
                    if (i < _cards.length - 1)
                      const SizedBox(width: AppSpacing.s24),
                  ],
                ],
              )
            else
              Column(
                children: [
                  for (int i = 0; i < _cards.length; i++) ...[
                    AnimatedReveal(
                      delay: Duration(milliseconds: i * 80),
                      child: _WhatItIsCard(
                        numeral: _cards[i].$1,
                        title: _cards[i].$2,
                        body: _cards[i].$3,
                      ),
                    ),
                    if (i < _cards.length - 1)
                      const SizedBox(height: AppSpacing.s16),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// Keeps the hover lift/shadow (a nice tactile touch on desktop) but drops
// the arrow that used to fade in — these cards aren't links or buttons, so
// nothing here should imply they're clickable.
class _WhatItIsCard extends StatefulWidget {
  const _WhatItIsCard({
    required this.numeral,
    required this.title,
    required this.body,
  });

  final String numeral;
  final String title;
  final String body;

  @override
  State<_WhatItIsCard> createState() => _WhatItIsCardState();
}

class _WhatItIsCardState extends State<_WhatItIsCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(AppSpacing.s40),
        decoration: BoxDecoration(
          color: kaizenPaper,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kaizenInk.withValues(alpha: 0.07)),
          boxShadow: [
            BoxShadow(
              color: kaizenInk.withValues(alpha: _hovered ? 0.10 : 0.04),
              blurRadius: _hovered ? 24 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.numeral,
              style: GoogleFonts.fraunces(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: kaizenBlue,
                height: 1.0,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(
              widget.title,
              style: AppTypography.headingM.copyWith(color: kaizenInk),
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              widget.body,
              style: AppTypography.bodyM.copyWith(color: kaizenMuted),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// SECTION 4 — STATS STRIP
// ===========================================================================

class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  static const _stats = [
    ('25+', 'YEARS', 'Classroom & administrative experience'),
    ('CBSE', 'CURRICULUM', 'Aligned by grade and subject'),
    ('1', 'TOOL', 'Replaces multiple supplementary resources'),
    ('100%', 'CUSTOMISABLE', 'Per school, per class, per subject'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > Breakpoints.tablet;
    final isMobile = width < Breakpoints.mobile;

    return Container(
      color: kaizenCream,
      child: Column(
        children: [
          const Divider(height: 1, color: kaizenPaper),
          _section(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppSpacing.s24 : AppSpacing.s32,
              vertical: AppSpacing.s64,
            ),
            child: isDesktop
                ? IntrinsicHeight(
                    child: Row(
                      children: [
                        for (int i = 0; i < _stats.length; i++) ...[
                          Expanded(
                            child: AnimatedReveal(
                              delay: Duration(milliseconds: i * 80),
                              child: _Stat(
                                value: _stats[i].$1,
                                unit: _stats[i].$2,
                                description: _stats[i].$3,
                              ),
                            ),
                          ),
                          if (i < _stats.length - 1)
                            VerticalDivider(
                              width: 1,
                              color: kaizenInk.withValues(alpha: 0.10),
                            ),
                        ],
                      ],
                    ),
                  )
                : isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < _stats.length; i++) ...[
                        if (i > 0) const SizedBox(height: AppSpacing.s32),
                        _Stat(
                          value: _stats[i].$1,
                          unit: _stats[i].$2,
                          description: _stats[i].$3,
                          valueFontSize: 40,
                          horizontalPadding: 0,
                        ),
                      ],
                    ],
                  )
                : Wrap(
                    spacing: AppSpacing.s32,
                    runSpacing: AppSpacing.s32,
                    children: [
                      for (final s in _stats)
                        SizedBox(
                          width: (width - 80) / 2,
                          child: _Stat(
                            value: s.$1,
                            unit: s.$2,
                            description: s.$3,
                          ),
                        ),
                    ],
                  ),
          ),
          const Divider(height: 1, color: kaizenPaper),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.unit,
    required this.description,
    this.valueFontSize = 60,
    this.horizontalPadding = AppSpacing.s24,
  });

  final String value;
  final String unit;
  final String description;
  final double valueFontSize;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // kaizenGold text on the kaizenCream strip background fails WCAG
          // contrast (~1.4:1, even at large-text size); kaizenBlueDeep reads
          // as the same premium accent at a safe ratio.
          Text(
            value,
            style: GoogleFonts.fraunces(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w700,
              height: 1.0,
              color: kaizenBlueDeep,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            unit,
            style: AppTypography.caption.copyWith(
              color: kaizenMuted,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            description,
            style: AppTypography.bodyS.copyWith(color: kaizenMuted),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// SECTION 5 — FINAL CTA
// ===========================================================================

class _FinalCtaSection extends StatelessWidget {
  const _FinalCtaSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return Container(
      constraints: const BoxConstraints(minHeight: 360),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kaizenCream, kaizenPaper],
        ),
      ),
      child: Center(
        child: _section(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedReveal(
                child: Text(
                  'Ready to see what your\nstudents could hold\nin their hands?'
                      .breaks(keep: isDesktop),
                  style: AppTypography.displayM.copyWith(color: kaizenInk),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              AnimatedReveal(
                delay: const Duration(milliseconds: 120),
                child: _FinalCtaButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinalCtaButton extends StatefulWidget {
  @override
  State<_FinalCtaButton> createState() => _FinalCtaButtonState();
}

class _FinalCtaButtonState extends State<_FinalCtaButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: Semantics(
        label: 'Request a Proposal',
        button: true,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () => context.go('/contact'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              constraints: const BoxConstraints(minHeight: 56, minWidth: 44),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s48,
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
                'Request a Proposal',
                style: AppTypography.label.copyWith(
                  color: kaizenInk,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
