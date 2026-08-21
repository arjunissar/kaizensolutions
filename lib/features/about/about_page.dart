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

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroSection(),
          _StorySection(),
          _FounderCardSection(),
          _ClosingBand(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared layout helpers
// ---------------------------------------------------------------------------

Widget _readingWidth({required Widget child}) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSpacing.maxReadingWidth),
      child: child,
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
    final headlineSize = (screenW * 0.10).clamp(38.0, 80.0);

    return Padding(
      padding: EdgeInsets.only(
        top: screenW > Breakpoints.tablet ? 160 : 80,
        bottom: AppSpacing.s96,
        left: AppSpacing.s32,
        right: AppSpacing.s32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedReveal(
                child: Text(
                  'Our Story',
                  style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    height: 1.15,
                    color: kaizenMuted,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              AnimatedReveal(
                delay: const Duration(milliseconds: 80),
                child: Text(
                  'Built by a teacher.\nFor teachers.\nFor students.',
                  style: GoogleFonts.fraunces(
                    fontSize: headlineSize,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    color: kaizenInk,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              AnimatedReveal(
                delay: const Duration(milliseconds: 160),
                child: Text(
                  'Kaizen Solutions Notebooks began in a classroom, not a boardroom. '
                  'After more than 25 years of teaching and leading schools across India, '
                  'our founder kept noticing the same quiet problem: students were carrying '
                  'heavy bags full of textbooks, reference books, guides, and notebooks — '
                  'but still struggling to connect what they read with what they wrote.',
                  style: GoogleFonts.interTight(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                    color: kaizenInk,
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
// STORY SECTION
// ===========================================================================

class _StorySection extends StatelessWidget {
  const _StorySection();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kaizenCream,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s32,
          vertical: AppSpacing.s16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _readingWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BodyParagraph(
                    'Over a quarter-century in classrooms and staffrooms, she watched thousands '
                    'of students learn — and watched the gap between content and practice widen. '
                    'A textbook would explain a concept on one page. A student would try to recreate '
                    'it, days later, on a blank page in a separate notebook. Somewhere in between, '
                    'the thread would break.',
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  _BodyParagraph(
                    'As a teacher and later as an administrator, she saw how much a simple shift '
                    'in materials could change outcomes. A well-structured summary at the top of '
                    'a chapter. A diagram beside the definition. A prompt that asked '
                    '‘what do you think?’ instead of ‘what is the answer?’. '
                    'Small things. Kaizen things.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s48),
            _readingWidth(
              child: AnimatedReveal(
                child: _PullQuoteCard(
                  'Great learning rarely comes from more material. It comes from better material, '
                  'held together in one place.',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s48),
            _readingWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BodyParagraph(
                    'Kaizen Solutions Notebooks is the quiet result of those 25 years. It is not '
                    'a textbook. It is not a reference book. It is not a blank notebook. It is the '
                    'thing she always wished her students had — one tool that held the concept, '
                    'the visual, the attainment target, and the space to write, together.',
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  _BodyParagraph(
                    'Every notebook is designed for a specific class and a specific subject, '
                    'aligned with CBSE learning outcomes. Every page has been considered by '
                    'someone who has stood at the front of a classroom and watched which '
                    'approaches actually land.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s48),
            _readingWidth(
              child: AnimatedReveal(
                child: _PullQuoteCard(
                  'We don’t want to change how students are taught. We want to change '
                  'what they carry with them while they learn.',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s48),
            _readingWidth(
              child: _BodyParagraph(
                'Today, Kaizen Solutions partners directly with schools across India — '
                'customising paper quality, size, page count, and subject bifurcations to '
                'match each institution’s way of working. Every notebook still begins '
                'with the same belief it started with: that learning, like Kaizen, is a '
                'daily, deliberate practice.',
              ),
            ),
            const SizedBox(height: AppSpacing.s96),
          ],
        ),
      ),
    );
  }
}

class _BodyParagraph extends StatelessWidget {
  const _BodyParagraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return AnimatedReveal(
      child: Text(
        text,
        style: AppTypography.bodyL.copyWith(color: kaizenInk),
      ),
    );
  }
}

class _PullQuoteCard extends StatelessWidget {
  const _PullQuoteCard(this.quote);

  final String quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s40),
      decoration: BoxDecoration(
        color: kaizenGold,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '“$quote”',
        style: GoogleFonts.fraunces(
          fontSize: 24,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
          height: 1.45,
          color: kaizenInk,
        ),
      ),
    );
  }
}

// ===========================================================================
// FOUNDER CARD
// ===========================================================================

class _FounderCardSection extends StatelessWidget {
  const _FounderCardSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        MediaQuery.sizeOf(context).width > Breakpoints.tablet;

    return ColoredBox(
      color: kaizenCream,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s32,
          vertical: AppSpacing.s96,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: AnimatedReveal(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.s48),
                decoration: BoxDecoration(
                  color: kaizenPaper,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kaizenGold, width: 1),
                ),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _FounderAvatar(),
                          const SizedBox(width: AppSpacing.s48),
                          Expanded(child: _FounderContent()),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _FounderAvatar(),
                          const SizedBox(height: AppSpacing.s40),
                          _FounderContent(),
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

class _FounderAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: swap in real photo at assets/images/founder.jpg
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: kaizenGold,
      ),
      child: Center(
        child: Text(
          'S',
          style: GoogleFonts.fraunces(
            fontSize: 88,
            fontWeight: FontWeight.w700,
            color: kaizenInk,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

class _FounderContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'FOUNDER',
          style: GoogleFonts.interTight(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.5,
            color: kaizenBlue,
            height: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        // TODO: founder name — insert name above this Text widget
        Text(
          'Educational Innovations Division, Kaizen Solutions',
          style: AppTypography.headingM.copyWith(color: kaizenInk),
        ),
        const SizedBox(height: AppSpacing.s16),
        Text(
          '25+ years of teaching and school administrative experience across India. '
          'A lifelong educator who believes that the smallest, most consistent '
          'improvements compound into the deepest learning.',
          style: AppTypography.bodyM.copyWith(color: kaizenMuted),
        ),
        const SizedBox(height: AppSpacing.s24),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: const [
            _InfoChip('Teacher'),
            _InfoChip('Administrator'),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.label);

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
// CLOSING BAND
// ===========================================================================

class _ClosingBand extends StatelessWidget {
  const _ClosingBand();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kaizenBlueDeep,
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
                'Capture Learning. Create Progress.',
                style: GoogleFonts.fraunces(
                  fontSize: 36,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  color: kaizenGold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
            AnimatedReveal(
              delay: const Duration(milliseconds: 100),
              child: _ClosingCtaButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClosingCtaButton extends StatefulWidget {
  @override
  State<_ClosingCtaButton> createState() => _ClosingCtaButtonState();
}

class _ClosingCtaButtonState extends State<_ClosingCtaButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: Semantics(
      label: 'Start the Conversation — navigate to Contact',
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
              'Start the Conversation',
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
