import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/animated_reveal.dart';
import '../../shared/widgets/page_scroll_view.dart';
import 'widgets/pedagogy_glyphs.dart';

class PsychologyPage extends StatelessWidget {
  const PsychologyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroSection(),
          _PrincipleCardsSection(),
          _ProcessDiagramSection(),
          _GroundingBand(),
          _ClosingCtaSection(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Layout helpers
// ---------------------------------------------------------------------------

Widget _padded({required Widget child, double v = AppSpacing.s96}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.s32, vertical: v),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: child,
      ),
    ),
  );
}

// ===========================================================================
// HERO
// ===========================================================================

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final headlineSize = (screenW * 0.075).clamp(36.0, 88.0);

    return ColoredBox(
      color: kaizenCream,
      child: _padded(
        v: screenW > Breakpoints.tablet ? AppSpacing.s96 : AppSpacing.s64,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedReveal(
                // kaizenGold text on kaizenCream fails WCAG contrast
                // (~1.4:1); kaizenBlueDeep is the same premium accent, safe.
                child: Text(
                  'The Pedagogy',
                  style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                    color: kaizenBlueDeep,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              AnimatedReveal(
                delay: const Duration(milliseconds: 80),
                child: Text(
                  'Designed the way\nstudents actually learn.'
                      .breaks(keep: screenW > Breakpoints.tablet),
                  style: GoogleFonts.fraunces(
                    fontSize: headlineSize,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    color: kaizenInk,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              AnimatedReveal(
                delay: const Duration(milliseconds: 160),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSpacing.maxReadingWidth,
                  ),
                  child: Text(
                    'Kaizen Notebooks are built on five established principles of learning '
                    'science — each translated into a specific design choice on the page.',
                    style: AppTypography.bodyL.copyWith(color: kaizenMuted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// PRINCIPLE CARDS — zigzag on desktop, straight stack on mobile
// ===========================================================================

class _PrincipleCardsSection extends StatelessWidget {
  const _PrincipleCardsSection();

  static const _principles = [
    _Principle(
      numeral: '01',
      name: 'Constructivist Learning',
      research:
          'Students build knowledge by connecting new ideas to what they already '
          'know, rather than receiving information passively.',
      application:
          'Every chapter opens with a short summary that activates prior understanding '
          'before introducing new concepts, and prompts encourage students to relate '
          'new material to what they\'ve already learned.',
    ),
    _Principle(
      numeral: '02',
      name: 'Dual Coding (Visual + Verbal)',
      research:
          'Memory and comprehension strengthen when information is encoded both '
          'visually and verbally.',
      application:
          'Diagrams, mind maps, flow illustrations and highlighted summaries sit beside '
          'text explanations — not buried in a separate book — so the visual and verbal '
          'channels reinforce each other on the same page.',
    ),
    _Principle(
      numeral: '03',
      name: 'Cognitive Load & Scaffolding',
      research:
          'Learners cope with complex material only when it\'s broken into appropriately '
          'sized pieces for their cognitive level.',
      application:
          'Content is layered age-wise. Younger grades get simpler language and shorter '
          'blocks; older grades get more structured explanations. Nothing arrives '
          'unscaffolded.',
    ),
    _Principle(
      numeral: '04',
      name: 'Retrieval Practice & Spacing',
      research:
          'Students remember more when they regularly retrieve and revisit information, '
          'not just re-read it.',
      application:
          'Quick-reference summaries and "Food for Thought" prompts invite students back '
          'into prior chapters, turning a notebook into a revision tool by design.',
    ),
    _Principle(
      numeral: '05',
      name: 'Metacognition & Transparent Goals',
      research:
          'Learners perform better when they understand what they are expected to learn, '
          'not just what they\'re told to do.',
      application:
          'Age-wise attainment targets are embedded directly into the notebook, so '
          'students, teachers and parents can all see the learning destination — not '
          'just the next exercise.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return ColoredBox(
      color: kaizenPaper,
      child: _padded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < _principles.length; i++) ...[
              AnimatedReveal(
                delay: Duration(milliseconds: 40 * (i % 3)),
                child: isDesktop
                    ? Padding(
                        padding: EdgeInsets.only(
                          left: i.isOdd ? 80.0 : 0,
                          right: i.isOdd ? 0 : 80.0,
                        ),
                        child: _PrincipleCard(
                          principle: _principles[i],
                          index: i,
                        ),
                      )
                    : _PrincipleCard(principle: _principles[i], index: i),
              ),
              if (i < _principles.length - 1)
                const SizedBox(height: AppSpacing.s32),
            ],
          ],
        ),
      ),
    );
  }
}

class _Principle {
  const _Principle({
    required this.numeral,
    required this.name,
    required this.research,
    required this.application,
  });

  final String numeral;
  final String name;
  final String research;
  final String application;
}

class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard({required this.principle, required this.index});

  final _Principle principle;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s48),
      decoration: BoxDecoration(
        color: kaizenCream,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kaizenInk.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: kaizenInk.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Numeral — kaizenGold on kaizenCream fails WCAG contrast even
              // at this large size; kaizenBlueDeep is the same premium
              // accent, safe.
              Text(
                principle.numeral,
                style: GoogleFonts.fraunces(
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  color: kaizenBlueDeep,
                  height: 1.0,
                ),
              ),
              const Spacer(),
              PedagogyBadge(index: index),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          // Principle name
          Text(
            principle.name,
            style: AppTypography.headingL.copyWith(color: kaizenInk),
          ),
          const SizedBox(height: AppSpacing.s32),
          const Divider(height: 1, color: kaizenPaper),
          const SizedBox(height: AppSpacing.s32),
          // Research block
          _SectionLabel('WHAT THE RESEARCH SAYS'),
          const SizedBox(height: AppSpacing.s12),
          Text(
            principle.research,
            style: AppTypography.bodyM.copyWith(color: kaizenMuted),
          ),
          const SizedBox(height: AppSpacing.s32),
          // Application block
          _SectionLabel('HOW WE DESIGNED FOR IT'),
          const SizedBox(height: AppSpacing.s12),
          Text(
            principle.application,
            style: AppTypography.bodyM.copyWith(
              color: kaizenInk,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          const Divider(height: 1, color: kaizenPaper),
          const SizedBox(height: AppSpacing.s16),
          // Footer
          Text(
            'APPLIED ON EVERY PAGE',
            style: AppTypography.caption.copyWith(
              color: kaizenBlueDeep,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.interTight(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.0,
        color: kaizenBlue,
        height: 1.2,
      ),
    );
  }
}

// ===========================================================================
// PROCESS DIAGRAM — animated sequential line fill on scroll entry
// ===========================================================================

class _ProcessDiagramSection extends StatelessWidget {
  const _ProcessDiagramSection();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kaizenCream,
      child: _padded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedReveal(
              child: Text(
                'Small steps, every page.',
                style: AppTypography.headingL.copyWith(color: kaizenInk),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            AnimatedReveal(
              delay: const Duration(milliseconds: 60),
              child: Text(
                'Each page moves students through a deliberate learning sequence.',
                style: AppTypography.bodyL.copyWith(color: kaizenMuted),
              ),
            ),
            const SizedBox(height: AppSpacing.s64),
            const _ProcessDiagram(),
          ],
        ),
      ),
    );
  }
}

class _ProcessDiagram extends StatefulWidget {
  const _ProcessDiagram();

  @override
  State<_ProcessDiagram> createState() => _ProcessDiagramState();
}

class _ProcessDiagramState extends State<_ProcessDiagram>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _triggered = false;

  static const _steps = [
    ('Prior\nKnowledge', Icons.history_edu),
    ('Clear\nConcept', Icons.auto_stories),
    ('Visual\nAnchor', Icons.image_outlined),
    ('Guided\nPractice', Icons.edit_outlined),
    ('Reflection', Icons.lightbulb_outline),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onVisible(VisibilityInfo info) {
    if (!_triggered && info.visibleFraction > 0.25) {
      _triggered = true;
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      if (reduceMotion) {
        _ctrl.value = 1.0;
      } else {
        _ctrl.forward();
      }
    }
  }

  Animation<double> _lineAnim(int i) {
    final start = i * 0.22;
    return CurvedAnimation(
      parent: _ctrl,
      curve: Interval(start, start + 0.32, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.mobile;

    return VisibilityDetector(
      key: const Key('process-diagram'),
      onVisibilityChanged: _onVisible,
      child: isDesktop ? _buildHorizontal() : _buildVertical(),
    );
  }

  Widget _buildHorizontal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                _StepCircle(
                  label: _steps[i].$1,
                  icon: _steps[i].$2,
                  number: i + 1,
                ),
              ],
            ),
          ),
          if (i < _steps.length - 1)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 36),
                child: AnimatedBuilder(
                  animation: _lineAnim(i),
                  builder: (_, __) => ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: _lineAnim(i).value,
                      child: Container(height: 2, color: kaizenBlue),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildVertical() {
    return Column(
      children: [
        for (int i = 0; i < _steps.length; i++) ...[
          Row(
            children: [
              _StepCircle(
                label: _steps[i].$1,
                icon: _steps[i].$2,
                number: i + 1,
                vertical: true,
              ),
            ],
          ),
          if (i < _steps.length - 1)
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: AnimatedBuilder(
                animation: _lineAnim(i),
                builder: (_, __) => ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: _lineAnim(i).value,
                    child: Container(width: 2, height: 40, color: kaizenBlue),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.label,
    required this.icon,
    required this.number,
    this.vertical = false,
  });

  final String label;
  final IconData icon;
  final int number;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: kaizenGold,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: kaizenInk, semanticLabel: null),
          Text(
            '$number',
            style: GoogleFonts.fraunces(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kaizenInk,
              height: 1.2,
            ),
          ),
        ],
      ),
    );

    if (vertical) {
      return Row(
        children: [
          circle,
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Text(
              label.replaceAll('\n', ' '),
              style: AppTypography.label.copyWith(color: kaizenInk),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        circle,
        const SizedBox(height: AppSpacing.s12),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: kaizenInk,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ===========================================================================
// GROUNDING BAND
// ===========================================================================

class _GroundingBand extends StatelessWidget {
  const _GroundingBand();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kaizenCream,
      child: Column(
        children: [
          const Divider(height: 1, color: kaizenPaper),
          _padded(
            v: AppSpacing.s64,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSpacing.maxReadingWidth,
                ),
                child: AnimatedReveal(
                  child: Text(
                    'Every design decision in the Kaizen Notebook traces back to an '
                    'established principle of learning science. We don\'t invent pedagogy '
                    '— we translate it into the tools students use every day.',
                    style: AppTypography.bodyL.copyWith(color: kaizenMuted),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: kaizenPaper),
        ],
      ),
    );
  }
}

// ===========================================================================
// CLOSING CTA
// ===========================================================================

class _ClosingCtaSection extends StatelessWidget {
  const _ClosingCtaSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return Container(
      color: kaizenBlueDeep,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s32,
        vertical: AppSpacing.s96,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedReveal(
                child: Text(
                  '"The best learning tool is one students barely notice — '
                  'because it simply fits how they think."',
                  style: GoogleFonts.fraunces(
                    fontSize: isDesktop ? 32 : 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: kaizenGold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.s48),
              AnimatedReveal(
                delay: const Duration(milliseconds: 100),
                child: const _CtaButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaButton extends StatefulWidget {
  const _CtaButton();

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Request a Proposal — navigate to Contact',
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => context.go('/contact'),
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
              'Request a Proposal',
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
