import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Pedagogy glyphs — one small hand-drawn icon per "Why It Works" principle.
//
// Each glyph is a CustomPainter on a square canvas using fractional (0..1)
// coordinates, matching the technique already used in hero_motion.dart and
// product_page.dart's _RuledLinePainter — no new asset pipeline, no stock
// imagery, just an extension of the vector language the site already uses.
//
// The badge itself deliberately inverts the logo's palette (gold glyph on a
// kaizenBlueDeep disc, rather than blue mark on gold) so it reads as a
// distinct "icon" register rather than a second logo.
// ---------------------------------------------------------------------------

/// Circular badge that paints the glyph for [index] (0-4, matching the five
/// principles in display order).
class PedagogyBadge extends StatelessWidget {
  const PedagogyBadge({super.key, required this.index, this.size = 56});

  final int index;
  final double size;

  static const _painters = [
    _ConstructivistGlyph(),
    _DualCodingGlyph(),
    _CognitiveLoadGlyph(),
    _RetrievalGlyph(),
    _MetacognitionGlyph(),
  ];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // Decorative — the adjacent principle title already names the concept.
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: kaizenBlueDeep,
        ),
        padding: EdgeInsets.all(size * 0.24),
        child: CustomPaint(
          painter: _painters[index % _painters.length],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared paint helpers
// ---------------------------------------------------------------------------

abstract class _GlyphPainter extends CustomPainter {
  const _GlyphPainter();

  Paint stroke(Size size, {double width = 0.10, Color color = kaizenGold}) =>
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.shortestSide * width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

  Paint fill({Color color = kaizenGold}) => Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  @override
  bool shouldRepaint(covariant _GlyphPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// 01 — Constructivist Learning: new understanding built on top of a base —
// a small staggered stack of blocks, ascending like the logo's mountain.
// ---------------------------------------------------------------------------

class _ConstructivistGlyph extends _GlyphPainter {
  const _ConstructivistGlyph();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final r = Radius.circular(w * 0.06);

    void block(double x0, double y0, double x1, double y1, Paint p) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(x0 * w, y0 * h, x1 * w, y1 * h),
          r,
        ),
        p,
      );
    }

    block(0.04, 0.66, 0.62, 0.90, fill(color: kaizenGold.withValues(alpha: 0.35)));
    block(0.26, 0.38, 0.84, 0.62, fill(color: kaizenGold.withValues(alpha: 0.65)));
    block(0.42, 0.10, 0.96, 0.34, fill());
  }
}

// ---------------------------------------------------------------------------
// 02 — Dual Coding: a picture and text-lines side by side, on the same page.
// ---------------------------------------------------------------------------

class _DualCodingGlyph extends _GlyphPainter {
  const _DualCodingGlyph();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Left — a small framed "picture" (visual channel).
    final frame = RRect.fromRectAndRadius(
      Rect.fromLTRB(0.04 * w, 0.14 * h, 0.46 * w, 0.86 * h),
      Radius.circular(w * 0.05),
    );
    canvas.drawRRect(frame, stroke(size, width: 0.07));

    final peak = Path()
      ..moveTo(0.10 * w, 0.68 * h)
      ..lineTo(0.22 * w, 0.42 * h)
      ..lineTo(0.30 * w, 0.56 * h)
      ..lineTo(0.38 * w, 0.34 * h)
      ..lineTo(0.42 * w, 0.68 * h)
      ..close();
    canvas.drawPath(peak, fill(color: kaizenGold.withValues(alpha: 0.75)));
    canvas.drawCircle(Offset(0.34 * w, 0.28 * h), w * 0.035, fill());

    // Right — three text lines (verbal channel).
    final line = stroke(size, width: 0.09);
    canvas.drawLine(Offset(0.56 * w, 0.30 * h), Offset(0.94 * w, 0.30 * h), line);
    canvas.drawLine(Offset(0.56 * w, 0.50 * h), Offset(0.88 * w, 0.50 * h), line);
    canvas.drawLine(Offset(0.56 * w, 0.70 * h), Offset(0.92 * w, 0.70 * h), line);
  }
}

// ---------------------------------------------------------------------------
// 03 — Cognitive Load & Scaffolding: ascending steps, each a manageable rise —
// the same "small step forward" idea as the Kaizen tagline, made literal.
// ---------------------------------------------------------------------------

class _CognitiveLoadGlyph extends _GlyphPainter {
  const _CognitiveLoadGlyph();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    const baseline = 0.88;
    const heights = [0.22, 0.40, 0.58, 0.78];
    const barW = 0.16;
    const gap = 0.06;
    final alphas = [0.30, 0.50, 0.72, 1.0];

    var x = 0.04;
    for (var i = 0; i < heights.length; i++) {
      final top = baseline - heights[i];
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTRB(x * w, top * h, (x + barW) * w, baseline * h),
          topLeft: Radius.circular(w * 0.035),
          topRight: Radius.circular(w * 0.035),
        ),
        fill(color: kaizenGold.withValues(alpha: alphas[i])),
      );
      x += barW + gap;
    }
  }
}

// ---------------------------------------------------------------------------
// 04 — Retrieval Practice & Spacing: evenly spaced touchpoints revisited
// over time, with a return arc looping back to the start.
// ---------------------------------------------------------------------------

class _RetrievalGlyph extends _GlyphPainter {
  const _RetrievalGlyph();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    const xs = [0.14, 0.38, 0.62, 0.86];
    const alphas = [1.0, 0.55, 1.0, 0.55];

    for (var i = 0; i < xs.length; i++) {
      canvas.drawCircle(
        Offset(xs[i] * w, 0.66 * h),
        w * 0.075,
        fill(color: kaizenGold.withValues(alpha: alphas[i])),
      );
    }

    // Return arc — revisiting what's already been learned.
    final arc = Path()
      ..moveTo(0.86 * w, 0.34 * h)
      ..quadraticBezierTo(0.50 * w, 0.06 * h, 0.14 * w, 0.34 * h);
    canvas.drawPath(arc, stroke(size, width: 0.075));

    // Arrowhead at the return point.
    final head = Path()
      ..moveTo(0.14 * w, 0.34 * h)
      ..lineTo(0.21 * w, 0.28 * h)
      ..moveTo(0.14 * w, 0.34 * h)
      ..lineTo(0.23 * w, 0.40 * h);
    canvas.drawPath(head, stroke(size, width: 0.075));
  }
}

// ---------------------------------------------------------------------------
// 05 — Metacognition & Transparent Goals: a target with the destination
// marked — knowing what "done" looks like before you start.
// ---------------------------------------------------------------------------

class _MetacognitionGlyph extends _GlyphPainter {
  const _MetacognitionGlyph();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final c = Offset(0.42 * w, 0.58 * h);

    canvas.drawCircle(c, w * 0.38, stroke(size, width: 0.07, color: kaizenGold.withValues(alpha: 0.35)));
    canvas.drawCircle(c, w * 0.24, stroke(size, width: 0.07, color: kaizenGold.withValues(alpha: 0.65)));
    canvas.drawCircle(c, w * 0.09, fill());

    // Flag planted at the destination.
    final pole = Path()
      ..moveTo(c.dx + w * 0.20, c.dy - h * 0.20)
      ..lineTo(c.dx + w * 0.58, c.dy - h * 0.58);
    canvas.drawPath(pole, stroke(size, width: 0.065));

    final pennant = Path()
      ..moveTo(c.dx + w * 0.58, c.dy - h * 0.58)
      ..lineTo(c.dx + w * 0.86, c.dy - h * 0.50)
      ..lineTo(c.dx + w * 0.58, c.dy - h * 0.36)
      ..close();
    canvas.drawPath(pennant, fill());
  }
}
