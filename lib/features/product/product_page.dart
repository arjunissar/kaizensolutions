import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/animated_reveal.dart';
import '../../shared/widgets/page_scroll_view.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroSection(),
          _InsideSection(),
          _ReplacesSection(),
          _CbseSection(),
          _BifurcationsSection(),
          _ClosingCtaSection(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Layout helpers
// ---------------------------------------------------------------------------

Widget _constrained({required Widget child, double max = AppSpacing.maxContentWidth}) {
  return Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: max),
      child: child,
    ),
  );
}

Widget _padded({
  required Widget child,
  double h = AppSpacing.s32,
  double v = AppSpacing.s96,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
    child: _constrained(child: child),
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
    final isDesktop = screenW > Breakpoints.tablet;
    final headlineSize = (screenW * 0.08).clamp(36.0, 88.0);

    return ColoredBox(
      color: kaizenCream,
      child: _padded(
        v: isDesktop ? AppSpacing.s96 : AppSpacing.s64,
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: _HeroText(headlineSize: headlineSize),
                  ),
                  const SizedBox(width: AppSpacing.s64),
                  Expanded(
                    flex: 5,
                    child: Center(child: _NotebookIllustration()),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeroText(headlineSize: headlineSize),
                  const SizedBox(height: AppSpacing.s48),
                  Center(child: _NotebookIllustration()),
                ],
              ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.headlineSize});
  final double headlineSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedReveal(
          child: Text(
            'The Notebook',
            style: GoogleFonts.fraunces(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.15,
              color: kaizenGold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        AnimatedReveal(
          delay: const Duration(milliseconds: 80),
          child: Text(
            'Not a textbook.\nNot a blank book.\nBoth.',
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
            constraints: const BoxConstraints(maxWidth: AppSpacing.maxReadingWidth),
            child: Text(
              'Each Kaizen Notebook combines curriculum-aligned concept pages '
              'with high-quality ruled pages — class-specific, subject-specific, '
              'and CBSE-aligned.',
              style: AppTypography.bodyL.copyWith(color: kaizenMuted),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Notebook illustration — pure Flutter
// ---------------------------------------------------------------------------

class _NotebookIllustration extends StatefulWidget {
  @override
  State<_NotebookIllustration> createState() => _NotebookIllustrationState();
}

class _NotebookIllustrationState extends State<_NotebookIllustration> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;
    final pageW = isDesktop ? 220.0 : 160.0;
    final pageH = pageW * 1.40;

    return Semantics(
      label: 'Illustration of a Kaizen notebook open to its concept and notes pages',
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedRotation(
          duration: const Duration(milliseconds: 350),
          turns: _hovered ? 2.0 / 360.0 : 0.0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: kaizenInk.withValues(alpha: _hovered ? 0.18 : 0.10),
                  blurRadius: _hovered ? 40 : 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ConceptPage(width: pageW, height: pageH),
                  Container(
                    width: 3,
                    height: pageH,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          kaizenInk.withValues(alpha: 0.12),
                          kaizenInk.withValues(alpha: 0.04),
                          kaizenInk.withValues(alpha: 0.12),
                        ],
                      ),
                    ),
                  ),
                  _NotesPage(width: pageW, height: pageH),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConceptPage extends StatelessWidget {
  const _ConceptPage({required this.width, required this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final p = width * 0.07;
    final lineH = height * 0.013;
    final gap = height * 0.022;

    return Container(
      width: width,
      height: height,
      color: const Color(0xFFFFFDF8),
      padding: EdgeInsets.all(p),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top accent + chapter title
          Container(height: 3, width: width * 0.35, color: kaizenBlue),
          SizedBox(height: gap * 0.6),
          _MockLine(width: width * 0.55, height: lineH * 1.3, color: kaizenInk.withValues(alpha: 0.2)),
          SizedBox(height: gap * 0.4),
          _MockLine(width: width * 0.38, height: lineH, color: kaizenInk.withValues(alpha: 0.12)),
          SizedBox(height: gap),
          // Key Idea badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: p * 0.55, vertical: p * 0.22),
            decoration: BoxDecoration(
              color: kaizenGold,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              'Key Idea',
              style: GoogleFonts.interTight(
                fontSize: width * 0.044,
                fontWeight: FontWeight.w600,
                color: kaizenInk,
                height: 1.0,
              ),
            ),
          ),
          SizedBox(height: gap * 0.8),
          // Summary text lines
          _MockLine(width: width * 0.82, height: lineH, color: kaizenInk.withValues(alpha: 0.13)),
          SizedBox(height: gap * 0.5),
          _MockLine(width: width * 0.68, height: lineH, color: kaizenInk.withValues(alpha: 0.13)),
          SizedBox(height: gap * 0.5),
          _MockLine(width: width * 0.75, height: lineH, color: kaizenInk.withValues(alpha: 0.13)),
          SizedBox(height: gap),
          // Mini diagram — 3-box hierarchy
          _MiniDiagram(width: width - p * 2),
          SizedBox(height: gap),
          // Bullet points
          _MockBullet(width: width - p * 2, textFraction: 0.72),
          SizedBox(height: gap * 0.55),
          _MockBullet(width: width - p * 2, textFraction: 0.58),
          SizedBox(height: gap * 0.55),
          _MockBullet(width: width - p * 2, textFraction: 0.65),
        ],
      ),
    );
  }
}

class _MockLine extends StatelessWidget {
  const _MockLine({required this.width, required this.height, required this.color});
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
    );
  }
}

class _MockBullet extends StatelessWidget {
  const _MockBullet({required this.width, required this.textFraction});
  final double width;
  final double textFraction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: kaizenGold),
        ),
        SizedBox(width: width * 0.05),
        _MockLine(
          width: width * textFraction,
          height: width * 0.032,
          color: kaizenInk.withValues(alpha: 0.12),
        ),
      ],
    );
  }
}

class _MiniDiagram extends StatelessWidget {
  const _MiniDiagram({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    final boxH = width * 0.10;
    final nodeW = width * 0.29;
    final nodeH = boxH * 0.75;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Root box
        Center(
          child: Container(
            width: nodeW * 1.1,
            height: boxH,
            decoration: BoxDecoration(
              color: kaizenBlue,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        SizedBox(height: width * 0.025),
        // Branch nodes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: nodeW,
              height: nodeH,
              decoration: BoxDecoration(
                color: kaizenGold.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Container(
              width: nodeW,
              height: nodeH,
              decoration: BoxDecoration(
                color: kaizenPaper,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: kaizenInk.withValues(alpha: 0.12)),
              ),
            ),
            Container(
              width: nodeW,
              height: nodeH,
              decoration: BoxDecoration(
                color: kaizenGold.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NotesPage extends StatelessWidget {
  const _NotesPage({required this.width, required this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: CustomPaint(
        painter: _RuledLinePainter(pageWidth: width, pageHeight: height),
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.18,
            top: height * 0.08,
            right: width * 0.07,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mock handwritten lines
              for (int i = 0; i < 6; i++) ...[
                SizedBox(height: height * 0.048),
                Container(
                  height: height * 0.013,
                  width: width * (0.5 + (i % 3) * 0.12),
                  decoration: BoxDecoration(
                    color: kaizenBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RuledLinePainter extends CustomPainter {
  const _RuledLinePainter({required this.pageWidth, required this.pageHeight});
  final double pageWidth;
  final double pageHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF1A3AE0).withValues(alpha: 0.08)
      ..strokeWidth = 0.8;
    final marginPaint = Paint()
      ..color = const Color(0xFFE8A0A0).withValues(alpha: 0.55)
      ..strokeWidth = 0.8;

    final lineSpacing = pageHeight * 0.062;
    final marginX = pageWidth * 0.14;

    // Horizontal ruled lines
    double y = lineSpacing * 1.2;
    while (y < pageHeight) {
      canvas.drawLine(Offset(0, y), Offset(pageWidth, y), linePaint);
      y += lineSpacing;
    }

    // Left margin line
    canvas.drawLine(
      Offset(marginX, 0),
      Offset(marginX, pageHeight),
      marginPaint,
    );
  }

  @override
  bool shouldRepaint(_RuledLinePainter old) => false;
}

// ===========================================================================
// SECTION — INSIDE EACH NOTEBOOK
// ===========================================================================

class _InsideSection extends StatelessWidget {
  const _InsideSection();

  static const _features = [
    (
      Icons.menu_book,
      'Chapter Overviews',
      'A crisp, grade-appropriate summary at the start of every chapter, so students know the terrain before they walk it.',
    ),
    (
      Icons.bubble_chart,
      'Mind Maps & Diagrams',
      'Visual structures that turn abstract concepts into images students can recall under pressure.',
    ),
    (
      Icons.flag,
      'Attainment Targets',
      'Clear, age-wise learning goals embedded into the notebook — so progress is visible to students, teachers and parents.',
    ),
    (
      Icons.lightbulb,
      'Food-for-Thought Prompts',
      'Questions that ask students to think, not just answer — building the habit of independent enquiry.',
    ),
    (
      Icons.border_color,
      'Ruled Writing Pages',
      'High-GSM, no-bleed paper engineered for daily classwork, homework and revision.',
    ),
    (
      Icons.layers,
      'Class- & Subject-Specific',
      'Each notebook is made for a single class and a single subject. Nothing generic. Nothing wasted.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return ColoredBox(
      color: kaizenPaper,
      child: _padded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedReveal(
              child: Text(
                'What\'s inside each notebook.',
                style: AppTypography.headingL.copyWith(color: kaizenInk),
              ),
            ),
            const SizedBox(height: AppSpacing.s64),
            for (int i = 0; i < _features.length; i++) ...[
              AnimatedReveal(
                delay: Duration(milliseconds: 60 * (i % 2)),
                child: _FeatureRow(
                  icon: _features[i].$1,
                  title: _features[i].$2,
                  body: _features[i].$3,
                  isReversed: isDesktop && i.isOdd,
                ),
              ),
              if (i < _features.length - 1) ...[
                const SizedBox(height: AppSpacing.s8),
                const Divider(height: 1, color: kaizenCream),
                const SizedBox(height: AppSpacing.s8),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.body,
    required this.isReversed,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    if (!isDesktop) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FeatureIconCard(icon: icon, title: title),
            const SizedBox(height: AppSpacing.s24),
            _FeatureCopy(title: title, body: body),
          ],
        ),
      );
    }

    final iconCard = Expanded(
      flex: 4,
      child: Center(child: _FeatureIconCard(icon: icon, title: title)),
    );
    final copy = Expanded(
      flex: 6,
      child: _FeatureCopy(title: title, body: body),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: isReversed
            ? [copy, const SizedBox(width: AppSpacing.s64), iconCard]
            : [iconCard, const SizedBox(width: AppSpacing.s64), copy],
      ),
    );
  }
}

class _FeatureIconCard extends StatelessWidget {
  const _FeatureIconCard({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s40,
        vertical: AppSpacing.s48,
      ),
      decoration: BoxDecoration(
        color: kaizenCream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kaizenInk.withValues(alpha: 0.07)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kaizenGold,
            ),
            child: Icon(icon, color: kaizenBlue, size: 30, semanticLabel: null),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            title,
            style: AppTypography.headingS.copyWith(color: kaizenInk),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FeatureCopy extends StatelessWidget {
  const _FeatureCopy({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: AppTypography.headingM.copyWith(color: kaizenInk)),
        const SizedBox(height: AppSpacing.s16),
        Text(
          body,
          style: AppTypography.bodyL.copyWith(color: kaizenMuted),
        ),
      ],
    );
  }
}

// ===========================================================================
// SECTION — ONE TOOL, THREE THINGS IT REPLACES
// ===========================================================================

class _ReplacesSection extends StatelessWidget {
  const _ReplacesSection();

  static const _cards = [
    (
      'Reference Book',
      'Concept summaries, in context.',
    ),
    (
      'Supplementary Guide',
      'Visuals and prompts on the same page as the notes.',
    ),
    (
      'Plain Notebook',
      'Premium paper and structured writing space.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return ColoredBox(
      color: kaizenCream,
      child: _padded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedReveal(
              child: Text(
                'One tool. Three things it replaces.',
                style: AppTypography.headingL.copyWith(color: kaizenInk),
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
                        delay: Duration(milliseconds: i * 80),
                        child: _ReplacesCard(
                          crossedOut: _cards[i].$1,
                          replacement: _cards[i].$2,
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
                      delay: Duration(milliseconds: i * 60),
                      child: _ReplacesCard(
                        crossedOut: _cards[i].$1,
                        replacement: _cards[i].$2,
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

class _ReplacesCard extends StatelessWidget {
  const _ReplacesCard({required this.crossedOut, required this.replacement});
  final String crossedOut;
  final String replacement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s32),
      decoration: BoxDecoration(
        color: kaizenPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kaizenInk.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            crossedOut,
            style: AppTypography.headingS.copyWith(
              color: kaizenMuted,
              decoration: TextDecoration.lineThrough,
              decorationColor: kaizenMuted,
              decorationThickness: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kaizenGold,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text(
                  replacement,
                  style: AppTypography.bodyM.copyWith(color: kaizenInk),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// SECTION — BUILT AROUND CBSE
// ===========================================================================

class _CbseSection extends StatelessWidget {
  const _CbseSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return Container(
      color: kaizenBlueDeep,
      child: _padded(
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AnimatedReveal(
                      child: Text(
                        'Built around\nthe CBSE\ncurriculum.',
                        style: AppTypography.displayM.copyWith(color: kaizenGold),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s96),
                  Expanded(
                    child: AnimatedReveal(
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        'Every notebook is mapped to CBSE learning outcomes for its specific '
                        'class and subject. Content is layered for the cognitive level of the '
                        'grade — simpler scaffolding for younger learners, more structured '
                        'explanations as students grow.',
                        style: AppTypography.bodyL.copyWith(
                          color: kaizenCream.withValues(alpha: 0.88),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedReveal(
                    child: Text(
                      'Built around the CBSE curriculum.',
                      style: AppTypography.headingL.copyWith(color: kaizenGold),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  AnimatedReveal(
                    delay: const Duration(milliseconds: 80),
                    child: Text(
                      'Every notebook is mapped to CBSE learning outcomes for its specific '
                      'class and subject. Content is layered for the cognitive level of the '
                      'grade — simpler scaffolding for younger learners, more structured '
                      'explanations as students grow.',
                      style: AppTypography.bodyL.copyWith(
                        color: kaizenCream.withValues(alpha: 0.88),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ===========================================================================
// SECTION — BIFURCATIONS
// ===========================================================================

class _BifurcationsSection extends StatelessWidget {
  const _BifurcationsSection();

  static const _cards = [
    (
      Icons.science,
      'Science',
      'Physics · Chemistry · Biology',
      'or Physical Science + Biology',
    ),
    (
      Icons.public,
      'Social Studies',
      'History · Geography',
      'Civics & Economics',
    ),
    (
      Icons.translate,
      'English',
      'Grammar · Creative Writing',
      '',
    ),
    (
      Icons.calendar_today,
      'Term-wise',
      'Term 1 · Term 2',
      'Any subject, any class',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return ColoredBox(
      color: kaizenCream,
      child: _padded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedReveal(
              child: Text(
                'Bifurcations we already support.',
                style: AppTypography.headingL.copyWith(color: kaizenInk),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            AnimatedReveal(
              delay: const Duration(milliseconds: 60),
              child: Text(
                'Each bifurcation is its own notebook — nothing shared, nothing wasted.',
                style: AppTypography.bodyL.copyWith(color: kaizenMuted),
              ),
            ),
            const SizedBox(height: AppSpacing.s48),
            if (isDesktop)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedReveal(
                          child: _BifurcationCard(
                            icon: _cards[0].$1,
                            subject: _cards[0].$2,
                            primary: _cards[0].$3,
                            secondary: _cards[0].$4,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s24),
                      Expanded(
                        child: AnimatedReveal(
                          delay: const Duration(milliseconds: 80),
                          child: _BifurcationCard(
                            icon: _cards[1].$1,
                            subject: _cards[1].$2,
                            primary: _cards[1].$3,
                            secondary: _cards[1].$4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedReveal(
                          delay: const Duration(milliseconds: 120),
                          child: _BifurcationCard(
                            icon: _cards[2].$1,
                            subject: _cards[2].$2,
                            primary: _cards[2].$3,
                            secondary: _cards[2].$4,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s24),
                      Expanded(
                        child: AnimatedReveal(
                          delay: const Duration(milliseconds: 160),
                          child: _BifurcationCard(
                            icon: _cards[3].$1,
                            subject: _cards[3].$2,
                            primary: _cards[3].$3,
                            secondary: _cards[3].$4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Column(
                children: [
                  for (int i = 0; i < _cards.length; i++) ...[
                    AnimatedReveal(
                      delay: Duration(milliseconds: i * 60),
                      child: _BifurcationCard(
                        icon: _cards[i].$1,
                        subject: _cards[i].$2,
                        primary: _cards[i].$3,
                        secondary: _cards[i].$4,
                      ),
                    ),
                    if (i < _cards.length - 1) const SizedBox(height: AppSpacing.s16),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _BifurcationCard extends StatelessWidget {
  const _BifurcationCard({
    required this.icon,
    required this.subject,
    required this.primary,
    required this.secondary,
  });

  final IconData icon;
  final String subject;
  final String primary;
  final String secondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s32),
      decoration: BoxDecoration(
        color: kaizenPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kaizenInk.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kaizenGold,
                ),
                child: Icon(icon, size: 18, color: kaizenBlue, semanticLabel: null),
              ),
              const SizedBox(width: AppSpacing.s12),
              Text(
                subject,
                style: AppTypography.headingS.copyWith(color: kaizenInk),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            primary,
            style: AppTypography.bodyM.copyWith(color: kaizenInk),
          ),
          if (secondary.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s4),
            Text(
              secondary,
              style: AppTypography.bodyS.copyWith(color: kaizenMuted),
            ),
          ],
        ],
      ),
    );
  }
}

// ===========================================================================
// CLOSING CTA — GOLD BAND
// ===========================================================================

class _ClosingCtaSection extends StatelessWidget {
  const _ClosingCtaSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kaizenGold,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s32,
        vertical: AppSpacing.s96,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedReveal(
              child: Text(
                'Want to see sample pages\nfor your grade?',
                style: GoogleFonts.fraunces(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  color: kaizenInk,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AnimatedReveal(
              delay: const Duration(milliseconds: 60),
              child: Text(
                'We\'ll put together a tailored sample for your school.',
                style: AppTypography.bodyL.copyWith(color: kaizenInk.withValues(alpha: 0.65)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
            AnimatedReveal(
              delay: const Duration(milliseconds: 120),
              child: _GoldCtaButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoldCtaButton extends StatefulWidget {
  @override
  State<_GoldCtaButton> createState() => _GoldCtaButtonState();
}

class _GoldCtaButtonState extends State<_GoldCtaButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Get in touch — navigate to Contact page',
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
              color: _hovered
                  ? kaizenInk.withValues(alpha: 0.88)
                  : kaizenInk,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Get in Touch',
              style: AppTypography.label.copyWith(
                color: kaizenCream,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
