import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class MoodFacePainter extends CustomPainter {
  final MoodType mood;
  final Color color;
  final double animationValue; // 0.0 to 1.0

  MoodFacePainter({
    required this.mood,
    required this.color,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    // --- Face circle background ---
    final bgPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // --- Face circle border ---
    final borderPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04;
    canvas.drawCircle(center, radius, borderPaint);

    // --- Draw features based on mood ---
    switch (mood) {
      case MoodType.ecstatic:
        _drawEcstatic(canvas, size, center, radius, color);
        break;
      case MoodType.happy:
        _drawHappy(canvas, size, center, radius, color);
        break;
      case MoodType.neutral:
        _drawNeutral(canvas, size, center, radius, color);
        break;
      case MoodType.sad:
        _drawSad(canvas, size, center, radius, color);
        break;
      case MoodType.awful:
        _drawAwful(canvas, size, center, radius, color);
        break;
    }
  }

  Paint _featurePaint(Color c, {double width = 3.0, bool fill = false}) {
    return Paint()
      ..color = c
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width;
  }

  // ── ECSTATIC: big open smile, raised arched brows, shining eyes ──
  void _drawEcstatic(Canvas canvas, Size size, Offset center, double radius, Color color) {
    final sw = size.width;
    final paint = _featurePaint(color, width: sw * 0.05);

    // Eyes - closed happy crescents
    final eyeY = center.dy - radius * 0.2;
    final eyeOffsetX = radius * 0.38;

    final leftEyeRect = Rect.fromCenter(
        center: Offset(center.dx - eyeOffsetX, eyeY),
        width: radius * 0.45,
        height: radius * 0.35);
    canvas.drawArc(leftEyeRect, 3.14, 3.14, false, paint); // upside-down arc = closed happy eye

    final rightEyeRect = Rect.fromCenter(
        center: Offset(center.dx + eyeOffsetX, eyeY),
        width: radius * 0.45,
        height: radius * 0.35);
    canvas.drawArc(rightEyeRect, 3.14, 3.14, false, paint);

    // Eyebrows - strongly raised and arched
    final browPaint = _featurePaint(color, width: sw * 0.045);
    final browY = center.dy - radius * 0.58;
    _drawBrow(canvas, Offset(center.dx - eyeOffsetX, browY), radius * 0.36, -0.35, browPaint);
    _drawBrow(canvas, Offset(center.dx + eyeOffsetX, browY), radius * 0.36, -0.35, browPaint);

    // Big open mouth smile
    final mouthRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.28),
        width: radius * 1.1,
        height: radius * 0.75);
    canvas.drawArc(mouthRect, 0, 3.14, false, paint); // big happy smile arc

    // Cheek blush dots
    final blushPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - radius * 0.6, center.dy + radius * 0.1), radius * 0.15, blushPaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.6, center.dy + radius * 0.1), radius * 0.15, blushPaint);
  }

  // ── HAPPY: classic smile, normal eyes, gentle brows ──
  void _drawHappy(Canvas canvas, Size size, Offset center, double radius, Color color) {
    final sw = size.width;
    final paint = _featurePaint(color, width: sw * 0.05);

    // Eyes - simple filled circles
    final eyeY = center.dy - radius * 0.22;
    final eyeOffsetX = radius * 0.38;
    final eyePaint = _featurePaint(color, fill: true);
    canvas.drawCircle(Offset(center.dx - eyeOffsetX, eyeY), radius * 0.1, eyePaint);
    canvas.drawCircle(Offset(center.dx + eyeOffsetX, eyeY), radius * 0.1, eyePaint);

    // Eyebrows - mildly raised, flat
    final browPaint = _featurePaint(color, width: sw * 0.04);
    final browY = center.dy - radius * 0.52;
    _drawBrow(canvas, Offset(center.dx - eyeOffsetX, browY), radius * 0.32, -0.15, browPaint);
    _drawBrow(canvas, Offset(center.dx + eyeOffsetX, browY), radius * 0.32, -0.15, browPaint);

    // Smile arc
    final mouthRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.2),
        width: radius * 0.85,
        height: radius * 0.5);
    canvas.drawArc(mouthRect, 0, 3.14, false, paint);
  }

  // ── NEUTRAL: flat line mouth, flat brows, dot eyes ──
  void _drawNeutral(Canvas canvas, Size size, Offset center, double radius, Color color) {
    final sw = size.width;

    // Eyes - filled dots
    final eyeY = center.dy - radius * 0.2;
    final eyeOffsetX = radius * 0.38;
    final eyePaint = _featurePaint(color, fill: true);
    canvas.drawCircle(Offset(center.dx - eyeOffsetX, eyeY), radius * 0.1, eyePaint);
    canvas.drawCircle(Offset(center.dx + eyeOffsetX, eyeY), radius * 0.1, eyePaint);

    // Eyebrows - completely flat, horizontal
    final browPaint = _featurePaint(color, width: sw * 0.04);
    final browY = center.dy - radius * 0.5;
    canvas.drawLine(
      Offset(center.dx - eyeOffsetX - radius * 0.18, browY),
      Offset(center.dx - eyeOffsetX + radius * 0.18, browY),
      browPaint,
    );
    canvas.drawLine(
      Offset(center.dx + eyeOffsetX - radius * 0.18, browY),
      Offset(center.dx + eyeOffsetX + radius * 0.18, browY),
      browPaint,
    );

    // Flat mouth
    final mouthPaint = _featurePaint(color, width: sw * 0.05);
    canvas.drawLine(
      Offset(center.dx - radius * 0.35, center.dy + radius * 0.32),
      Offset(center.dx + radius * 0.35, center.dy + radius * 0.32),
      mouthPaint,
    );
  }

  // ── SAD: frown, droopy eyes, angled-down brows ──
  void _drawSad(Canvas canvas, Size size, Offset center, double radius, Color color) {
    final sw = size.width;
    final paint = _featurePaint(color, width: sw * 0.05);

    // Eyes - slightly drooping, teardrop shape
    final eyeY = center.dy - radius * 0.18;
    final eyeOffsetX = radius * 0.38;
    final eyePaint = _featurePaint(color, fill: true);
    canvas.drawCircle(Offset(center.dx - eyeOffsetX, eyeY), radius * 0.1, eyePaint);
    canvas.drawCircle(Offset(center.dx + eyeOffsetX, eyeY), radius * 0.1, eyePaint);

    // Teardrops
    _drawTear(canvas, Offset(center.dx - eyeOffsetX, eyeY + radius * 0.12), radius * 0.08, color);

    // Eyebrows - angled DOWN toward center (sad V shape)
    final browPaint = _featurePaint(color, width: sw * 0.04);
    final browY = center.dy - radius * 0.52;
    // Left brow: left side up, right side down (inner corner down)
    canvas.drawLine(
      Offset(center.dx - eyeOffsetX - radius * 0.18, browY - radius * 0.06),
      Offset(center.dx - eyeOffsetX + radius * 0.18, browY + radius * 0.1),
      browPaint,
    );
    // Right brow: left side down, right side up
    canvas.drawLine(
      Offset(center.dx + eyeOffsetX - radius * 0.18, browY + radius * 0.1),
      Offset(center.dx + eyeOffsetX + radius * 0.18, browY - radius * 0.06),
      browPaint,
    );

    // Frown arc (upside down smile)
    final mouthRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.62),
        width: radius * 0.75,
        height: radius * 0.45);
    canvas.drawArc(mouthRect, 3.14, 3.14, false, paint);
  }

  // ── AWFUL: extreme frown, angry brows, X eyes ──
  void _drawAwful(Canvas canvas, Size size, Offset center, double radius, Color color) {
    final sw = size.width;
    final paint = _featurePaint(color, width: sw * 0.05);

    // Eyes - X shape (distressed)
    final eyeY = center.dy - radius * 0.22;
    final eyeOffsetX = radius * 0.38;
    final eyeSize = radius * 0.13;
    _drawXEye(canvas, Offset(center.dx - eyeOffsetX, eyeY), eyeSize, paint);
    _drawXEye(canvas, Offset(center.dx + eyeOffsetX, eyeY), eyeSize, paint);

    // Eyebrows - strongly angled DOWN (angry V)
    final browPaint = _featurePaint(color, width: sw * 0.055);
    final browY = center.dy - radius * 0.52;
    canvas.drawLine(
      Offset(center.dx - eyeOffsetX - radius * 0.2, browY - radius * 0.14),
      Offset(center.dx - eyeOffsetX + radius * 0.2, browY + radius * 0.18),
      browPaint,
    );
    canvas.drawLine(
      Offset(center.dx + eyeOffsetX - radius * 0.2, browY + radius * 0.18),
      Offset(center.dx + eyeOffsetX + radius * 0.2, browY - radius * 0.14),
      browPaint,
    );

    // Big dramatic frown
    final mouthRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.72),
        width: radius * 0.9,
        height: radius * 0.55);
    canvas.drawArc(mouthRect, 3.14, 3.14, false, paint);

    // Sweat drop
    _drawTear(canvas, Offset(center.dx + eyeOffsetX, eyeY + radius * 0.14), radius * 0.09, color);
  }

  // Helper: draw an eyebrow arc centered at given point
  void _drawBrow(Canvas canvas, Offset center, double width, double curvature, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - width / 2, center.dy);
    path.quadraticBezierTo(
      center.dx,
      center.dy + curvature * width,
      center.dx + width / 2,
      center.dy,
    );
    canvas.drawPath(path, paint);
  }

  // Helper: draw X eyes
  void _drawXEye(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawLine(
      Offset(center.dx - size, center.dy - size),
      Offset(center.dx + size, center.dy + size),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + size, center.dy - size),
      Offset(center.dx - size, center.dy + size),
      paint,
    );
  }

  // Helper: draw a teardrop
  void _drawTear(Canvas canvas, Offset top, double size, Color color) {
    final tearPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(top.dx, top.dy);
    path.quadraticBezierTo(top.dx + size, top.dy + size * 1.5, top.dx, top.dy + size * 2.5);
    path.quadraticBezierTo(top.dx - size, top.dy + size * 1.5, top.dx, top.dy);
    canvas.drawPath(path, tearPaint);
  }

  @override
  bool shouldRepaint(MoodFacePainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.color != color ||
        oldDelegate.animationValue != animationValue;
  }
}
