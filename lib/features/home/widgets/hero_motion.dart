import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

// kaizenCream (#FAFAF7) × 0.96 per channel → #F0F0ED
const Color _kAltPaper = Color(0xFFF0F0ED);

// ---------------------------------------------------------------------------
// Paper sheet descriptor — fully const, defines fixed geometry and drift path.
// ---------------------------------------------------------------------------

class _Sheet {
  const _Sheet({
    required this.w,
    required this.h,
    required this.sx,
    required this.sy,
    required this.ex,
    required this.ey,
    required this.r0,
    required this.r1,
    required this.phase,
    required this.isDark,
  });

  final double w, h;
  final double sx, sy; // start centre as canvas fraction (can be < 0 or > 1)
  final double ex, ey; // end centre as canvas fraction
  final double r0, r1; // rotation at start / end, radians
  final double phase;  // 0–1 loop offset — spreads sheets across the timeline
  final bool isDark;

  Color get fillColor => isDark ? _kAltPaper : kaizenPaper;
}

// Six sheets: three drifting NE (indices 0, 2, 4), three SW (1, 3, 5).
// Phases evenly spread by 1/6. Four kaizenPaper, two alt cream.
// All paths extend ≥ 30% of rectangle size off-canvas on both ends.
const List<_Sheet> _kSheets = [
  // 0 — NE, largest, kaizenPaper, phase 0
  _Sheet(
    w: 240, h: 170,
    sx: -0.30, sy: 0.82,
    ex:  1.25, ey: 0.05,
    r0: -5 * math.pi / 180, r1: 13 * math.pi / 180,
    phase: 0.0,
    isDark: false,
  ),
  // 1 — SW, small, alt cream, phase 1/6
  _Sheet(
    w: 100, h: 72,
    sx:  1.22, sy: 0.15,
    ex: -0.28, ey: 0.87,
    r0:  8 * math.pi / 180, r1: -10 * math.pi / 180,
    phase: 1.0 / 6.0,
    isDark: true,
  ),
  // 2 — NE, medium, kaizenPaper, phase 2/6
  _Sheet(
    w: 160, h: 120,
    sx: 0.12, sy: 1.28,
    ex: 0.78, ey: -0.28,
    r0:  2 * math.pi / 180, r1: 22 * math.pi / 180,
    phase: 2.0 / 6.0,
    isDark: false,
  ),
  // 3 — SW, large, kaizenPaper, phase 3/6
  _Sheet(
    w: 200, h: 145,
    sx: 0.88, sy: -0.28,
    ex: 0.22, ey:  1.28,
    r0: -3 * math.pi / 180, r1: -21 * math.pi / 180,
    phase: 3.0 / 6.0,
    isDark: false,
  ),
  // 4 — NE, small, kaizenPaper, phase 4/6
  _Sheet(
    w: 80, h: 60,
    sx: -0.28, sy: 0.58,
    ex:  1.22, ey: 0.08,
    r0: -8 * math.pi / 180, r1: 12 * math.pi / 180,
    phase: 4.0 / 6.0,
    isDark: false,
  ),
  // 5 — SW, medium, alt cream, phase 5/6
  _Sheet(
    w: 130, h: 95,
    sx:  0.72, sy: -0.22,
    ex: -0.22, ey:  0.82,
    r0:  6 * math.pi / 180, r1: -16 * math.pi / 180,
    phase: 5.0 / 6.0,
    isDark: true,
  ),
];

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

class HeroMotion extends StatefulWidget {
  const HeroMotion({super.key});

  @override
  State<HeroMotion> createState() => _HeroMotionState();
}

class _HeroMotionState extends State<HeroMotion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final _HeroMotionPainter _painter;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );
    _painter = _HeroMotionPainter(_controller);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!MediaQuery.of(context).disableAnimations) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: CustomPaint(painter: _painter),
    );
  }
}

// ---------------------------------------------------------------------------
// Painter — single instance, driven by repaint listenable.
// All Paint objects are instance fields, created once in the constructor.
// ---------------------------------------------------------------------------

class _HeroMotionPainter extends CustomPainter {
  _HeroMotionPainter(Animation<double> animation)
      : _anim = animation,
        super(repaint: animation);

  final Animation<double> _anim;

  // Fill paint — colour is mutated per sheet, which is safe (single-threaded).
  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0
    ..color = kaizenInk.withValues(alpha: 0.08);

  final Paint _shadowPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = kaizenInk.withValues(alpha: 0.05)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

  final Paint _dotPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = kaizenInk.withValues(alpha: 0.04);

  // Line paint — colour alpha is mutated per frame for the heartbeat.
  final Paint _linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..strokeCap = StrokeCap.round;

  // Dot grid path — rebuilt only when canvas size changes (rare).
  Size? _gridSize;
  Path? _gridPath;

  static const double _wobbleAmp = 8.0;
  // Non-integer frequency avoids sheets visibly syncing their wobble.
  static const double _wobbleFreq = 3.7;
  static const double _lineLen = 120.0;

  // ── paint ──────────────────────────────────────────────────────────────────

  @override
  void paint(Canvas canvas, Size size) {
    final t = _anim.value;
    canvas.clipRect(Offset.zero & size);

    _paintGrid(canvas, size);
    for (final sheet in _kSheets) {
      _paintSheet(canvas, size, sheet, t);
    }
    _paintLine(canvas, size, t);
  }

  // Layer 1 — static dot grid (path cached until size changes)
  void _paintGrid(Canvas canvas, Size size) {
    if (_gridSize != size) {
      _gridSize = size;
      final path = Path();
      const step = 28.0;
      const r = 1.5;
      for (double x = 0; x <= size.width + step; x += step) {
        for (double y = 0; y <= size.height + step; y += step) {
          path.addOval(Rect.fromCircle(center: Offset(x, y), radius: r));
        }
      }
      _gridPath = path;
    }
    canvas.drawPath(_gridPath!, _dotPaint);
  }

  // Layer 2 — drifting paper sheets
  void _paintSheet(Canvas canvas, Size size, _Sheet s, double t) {
    final p = (t + s.phase) % 1.0;

    // Linear interpolation for drift — no easing (easing makes drift feel
    // mechanical because the speed-up and slow-down become the visible motion).
    final baseCx = (s.sx + (s.ex - s.sx) * p) * size.width;
    final baseCy = (s.sy + (s.ey - s.sy) * p) * size.height;

    // Perpendicular wobble computed in pixel space so canvas aspect doesn't skew it.
    final dxPx = (s.ex - s.sx) * size.width;
    final dyPx = (s.ey - s.sy) * size.height;
    final dLen = math.sqrt(dxPx * dxPx + dyPx * dyPx);
    final wobble = dLen > 0
        ? _wobbleAmp * math.sin(2 * math.pi * (t + s.phase) * _wobbleFreq)
        : 0.0;
    final cx = baseCx + (dLen > 0 ? (-dyPx / dLen) * wobble : 0.0);
    final cy = baseCy + (dLen > 0 ? (dxPx / dLen) * wobble : 0.0);

    final angle = s.r0 + (s.r1 - s.r0) * p;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(angle);

    // Shadow first — offset (0, 8) in rotated space, slightly larger rect.
    canvas.drawRect(
      Rect.fromCenter(
          center: const Offset(0, 8), width: s.w + 4, height: s.h + 4),
      _shadowPaint,
    );

    // Fill and hairline border.
    _fillPaint.color = s.fillColor;
    final body =
        Rect.fromCenter(center: Offset.zero, width: s.w, height: s.h);
    canvas.drawRect(body, _fillPaint);
    canvas.drawRect(body, _borderPaint);

    canvas.restore();
  }

  // Layer 3 — gold heartbeat line
  // Cycle: 12 s within the 60 s loop.
  //   0.0 – 1.4 s : draw-in (ease-out quad width)
  //   1.4 – 5.4 s : hold full
  //   5.4 – 7.0 s : fade out (linear alpha)
  //   7.0 – 12.0 s: invisible
  void _paintLine(Canvas canvas, Size size, double t) {
    final s = (t * 60.0) % 12.0; // seconds within current cycle

    double width = 0;
    double alpha = 0;

    if (s < 1.4) {
      final raw = s / 1.4;
      width = _lineLen * (1.0 - (1.0 - raw) * (1.0 - raw)); // ease-out quad
      alpha = 1.0;
    } else if (s < 5.4) {
      width = _lineLen;
      alpha = 1.0;
    } else if (s < 7.0) {
      width = _lineLen;
      alpha = 1.0 - (s - 5.4) / 1.6;
    }

    if (alpha <= 0 || width <= 0) return;

    _linePaint.color = kaizenGold.withValues(alpha: alpha);

    final lineY = size.height * 0.45;
    final startX = (size.width - _lineLen) / 2.0;

    canvas.drawLine(
      Offset(startX, lineY),
      Offset(startX + width, lineY),
      _linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HeroMotionPainter old) => false;
  // Repaints are driven by the repaint: listenable passed to super().
  // shouldRepaint is only called when a new painter instance is attached
  // to the widget — which never happens here since _painter lives in State.
}
