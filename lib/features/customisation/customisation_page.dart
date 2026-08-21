import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/animated_reveal.dart';
import '../../shared/widgets/page_scroll_view.dart';
import '../../shared/widgets/tap_scale.dart';

class CustomisationPage extends StatelessWidget {
  const CustomisationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroSection(),
          _OptionCardsSection(),
          _AlsoIncludedSection(),
          _OrderingTimelineSection(),
          _FaqSection(),
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
    final headlineSize = (screenW * 0.075).clamp(36.0, 80.0);
    final isDesktop = screenW > Breakpoints.tablet;

    return ColoredBox(
      color: kaizenCream,
      child: _padded(
        v: isDesktop ? AppSpacing.s96 : AppSpacing.s64,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedReveal(
                child: Text(
                  'Customisation',
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
                  'Your school.\nYour notebook.',
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
                  constraints:
                      const BoxConstraints(maxWidth: AppSpacing.maxReadingWidth),
                  child: Text(
                    'Every Kaizen Notebook is built to order. Choose the paper, the size, '
                    'the pages, the subjects — or let us recommend a configuration based '
                    'on your school\'s needs.',
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
// OPTION CARDS — 2×2 desktop, 1-col mobile
// ===========================================================================

class _OptionCardsSection extends StatelessWidget {
  const _OptionCardsSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    const paperCard = _OptionCard(
      icon: Icons.layers_outlined,
      title: 'Paper Quality',
      options: [
        '70 GSM — Standard',
        '80 GSM — Premium',
        '100 GSM — Luxury',
        'Eco-friendly recycled paper (optional)',
      ],
      caption: 'All paper is no-bleed, smooth and durable.',
    );

    const sizeCard = _OptionCard(
      icon: Icons.straighten,
      title: 'Notebook Size',
      options: [
        'Kaizen Standard — 24 cm × 18 cm',
        'Long Book',
        'Medium Book',
        'Custom dimensions on request',
      ],
    );

    const pageCard = _OptionCard(
      icon: Icons.article_outlined,
      title: 'Page Count',
      options: [
        'Standard — 150 writing pages',
        'Custom page count decided by the school',
        'Optional extras: ruled / blank / grid pages',
      ],
    );

    const bifCard = _OptionCard(
      icon: Icons.account_tree_outlined,
      title: 'Subject Bifurcations',
      options: [
        'Science — Physics / Chemistry / Biology or Physical Science + Biology',
        'Social Studies — History / Geography / Civics & Economics',
        'English — Grammar / Creative Writing',
        'Term-wise notebooks (Term 1 / Term 2)',
      ],
    );

    return ColoredBox(
      color: kaizenPaper,
      child: _padded(
        child: isDesktop
            ? Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AnimatedReveal(child: paperCard),
                      ),
                      const SizedBox(width: AppSpacing.s24),
                      Expanded(
                        child: AnimatedReveal(
                          delay: const Duration(milliseconds: 80),
                          child: sizeCard,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AnimatedReveal(
                          delay: const Duration(milliseconds: 120),
                          child: pageCard,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s24),
                      Expanded(
                        child: AnimatedReveal(
                          delay: const Duration(milliseconds: 160),
                          child: bifCard,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  for (final card in [paperCard, sizeCard, pageCard, bifCard]) ...[
                    AnimatedReveal(child: card),
                    const SizedBox(height: AppSpacing.s16),
                  ],
                ],
              ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.options,
    this.caption,
  });

  final IconData icon;
  final String title;
  final List<String> options;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s40),
      decoration: BoxDecoration(
        color: kaizenCream,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: kaizenGold, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kaizenGold,
                ),
                child: Icon(icon, size: 20, color: kaizenBlue, semanticLabel: null),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.headingM.copyWith(color: kaizenInk),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s32),
          for (final opt in options) ...[
            _OptionRow(opt),
            if (opt != options.last) const SizedBox(height: AppSpacing.s12),
          ],
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.s24),
            const Divider(height: 1, color: kaizenPaper),
            const SizedBox(height: AppSpacing.s16),
            Text(
              caption!,
              style: AppTypography.caption.copyWith(color: kaizenMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kaizenGold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyM.copyWith(color: kaizenInk),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// ALSO INCLUDED — chip row
// ===========================================================================

class _AlsoIncludedSection extends StatelessWidget {
  const _AlsoIncludedSection();

  static const _chips = [
    'School-branded covers',
    'Custom templates',
    'Class-specific content',
    'CBSE-aligned',
    'Attainment targets built in',
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kaizenCream,
      child: Column(
        children: [
          const Divider(height: 1, color: kaizenPaper),
          _padded(
            v: AppSpacing.s48,
            child: Column(
              children: [
                AnimatedReveal(
                  child: Text(
                    'Also included with every order',
                    style: AppTypography.label.copyWith(
                      color: kaizenMuted,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                AnimatedReveal(
                  delay: const Duration(milliseconds: 80),
                  child: Wrap(
                    spacing: AppSpacing.s8,
                    runSpacing: AppSpacing.s8,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final chip in _chips) _AlsoChip(chip),
                    ],
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

class _AlsoChip extends StatelessWidget {
  const _AlsoChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: kaizenPaper,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: kaizenGold.withValues(alpha: 0.6)),
      ),
      child: Text(
        label,
        style: AppTypography.bodyS.copyWith(color: kaizenInk),
      ),
    );
  }
}

// ===========================================================================
// HOW ORDERING WORKS — 4-step timeline
// ===========================================================================

class _OrderingTimelineSection extends StatelessWidget {
  const _OrderingTimelineSection();

  static const _steps = [
    (
      '1',
      'Discover',
      'We learn your school\'s curriculum pattern and needs.',
    ),
    (
      '2',
      'Design',
      'We draft class-wise and subject-wise specifications with you.',
    ),
    (
      '3',
      'Approve',
      'You sign off on specs, quantities and branding.',
    ),
    (
      '4',
      'Deliver',
      'We produce and deliver notebooks to your school premises.',
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
                'How ordering works.',
                style: AppTypography.headingL.copyWith(color: kaizenInk),
              ),
            ),
            const SizedBox(height: AppSpacing.s64),
            AnimatedReveal(
              delay: const Duration(milliseconds: 80),
              child: isDesktop
                  ? _HorizontalTimeline(steps: _steps)
                  : _VerticalTimeline(steps: _steps),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalTimeline extends StatelessWidget {
  const _HorizontalTimeline({required this.steps});
  final List<(String, String, String)> steps;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Expanded(
            child: _TimelineStep(
              numeral: steps[i].$1,
              name: steps[i].$2,
              description: steps[i].$3,
            ),
          ),
          if (i < steps.length - 1)
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: SizedBox(
                width: AppSpacing.s32,
                child: Container(
                  height: 2,
                  color: kaizenBlue.withValues(alpha: 0.25),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _VerticalTimeline extends StatelessWidget {
  const _VerticalTimeline({required this.steps});
  final List<(String, String, String)> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TimelineCircle(steps[i].$1),
              const SizedBox(width: AppSpacing.s24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i].$2,
                        style: AppTypography.headingS.copyWith(color: kaizenInk),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        steps[i].$3,
                        style: AppTypography.bodyM.copyWith(color: kaizenMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (i < steps.length - 1)
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 4, bottom: 4),
              child: Container(
                width: 2,
                height: AppSpacing.s32,
                color: kaizenBlue.withValues(alpha: 0.25),
              ),
            ),
        ],
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.numeral,
    required this.name,
    required this.description,
  });

  final String numeral;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimelineCircle(numeral),
        const SizedBox(height: AppSpacing.s16),
        Text(
          name,
          style: AppTypography.headingS.copyWith(color: kaizenInk),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          description,
          style: AppTypography.bodyS.copyWith(color: kaizenMuted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TimelineCircle extends StatelessWidget {
  const _TimelineCircle(this.numeral);
  final String numeral;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: kaizenGold,
      ),
      child: Center(
        child: Text(
          numeral,
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: kaizenInk,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// FAQ — ExpansionTile list inside bordered container
// ===========================================================================

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  static const _faqs = [
    (
      'Do you share pricing publicly?',
      'No. We price each order based on the specifications a school chooses. '
          'Request a proposal and we\'ll share a detailed quote within a few working days.',
    ),
    (
      'What is the minimum order quantity?',
      'Minimums depend on your chosen specifications. We work with schools of all sizes '
          '— from small campuses to multi-section institutions.',
    ),
    (
      'How long does production take?',
      'Typical production and delivery timelines are a few weeks after final approval and '
          'advance payment, depending on quantity and customisation.',
    ),
    (
      'Can we include our school branding?',
      'Yes. School-branded covers and custom templates are available.',
    ),
    (
      'Is the content aligned to CBSE?',
      'Yes. All Kaizen Notebooks are CBSE-aligned by class and subject.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kaizenPaper,
      child: _padded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedReveal(
              child: Text(
                'Common questions.',
                style: AppTypography.headingL.copyWith(color: kaizenInk),
              ),
            ),
            const SizedBox(height: AppSpacing.s48),
            AnimatedReveal(
              delay: const Duration(milliseconds: 60),
              child: Container(
                decoration: BoxDecoration(
                  color: kaizenCream,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kaizenInk.withValues(alpha: 0.08)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      for (int i = 0; i < _faqs.length; i++) ...[
                        _FaqTile(
                          question: _faqs[i].$1,
                          answer: _faqs[i].$2,
                        ),
                        if (i < _faqs.length - 1)
                          const Divider(
                            height: 1,
                            indent: AppSpacing.s24,
                            endIndent: AppSpacing.s24,
                            color: kaizenPaper,
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s24,
          vertical: AppSpacing.s8,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.s24,
          0,
          AppSpacing.s24,
          AppSpacing.s24,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        backgroundColor: kaizenCream,
        collapsedBackgroundColor: kaizenCream,
        iconColor: kaizenGold,
        collapsedIconColor: kaizenInk.withValues(alpha: 0.5),
        title: Text(
          question,
          style: AppTypography.bodyM.copyWith(
            color: kaizenInk,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Text(
            answer,
            style: AppTypography.bodyM.copyWith(color: kaizenMuted),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// CLOSING CTA — gold band
// ===========================================================================

class _ClosingCtaSection extends StatelessWidget {
  const _ClosingCtaSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoints.tablet;

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
                'Let\'s design a notebook\nfor your school.',
                style: GoogleFonts.fraunces(
                  fontSize: isDesktop ? 48 : 36,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  color: kaizenInk,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            AnimatedReveal(
              delay: const Duration(milliseconds: 60),
              child: Text(
                'Tell us about your school and we\'ll put together\na tailored proposal — at no obligation.',
                style: AppTypography.bodyL.copyWith(
                  color: kaizenInk.withValues(alpha: 0.65),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.s48),
            AnimatedReveal(
              delay: const Duration(milliseconds: 120),
              child: const _CtaButton(),
            ),
          ],
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
    return TapScale(
      child: Semantics(
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
              color: _hovered
                  ? kaizenInk.withValues(alpha: 0.88)
                  : kaizenInk,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Request a Proposal',
              style: AppTypography.label.copyWith(
                color: kaizenCream,
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
