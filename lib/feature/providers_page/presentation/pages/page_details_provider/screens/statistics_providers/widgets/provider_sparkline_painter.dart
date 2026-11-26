import 'package:flutter/material.dart';

class ProviderSparklinePainter extends CustomPainter {
  final Color color;
  final bool isIncrease;

  const ProviderSparklinePainter({
    required this.color,
    this.isIncrease = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final path = Path();
    final fillPath = Path();

    // Normalized points based on trend
    final List<Offset> points = isIncrease
        ? [
            Offset(0, size.height * 0.75),
            Offset(size.width * 0.15, size.height * 0.65),
            Offset(size.width * 0.28, size.height * 0.78),
            Offset(size.width * 0.42, size.height * 0.55),
            Offset(size.width * 0.58, size.height * 0.45),
            Offset(size.width * 0.75, size.height * 0.30),
            Offset(size.width * 0.88, size.height * 0.18),
            Offset(size.width, size.height * 0.22),
          ]
        : [
            Offset(0, size.height * 0.25),
            Offset(size.width * 0.15, size.height * 0.35),
            Offset(size.width * 0.28, size.height * 0.22),
            Offset(size.width * 0.42, size.height * 0.50),
            Offset(size.width * 0.58, size.height * 0.60),
            Offset(size.width * 0.75, size.height * 0.70),
            Offset(size.width * 0.88, size.height * 0.82),
            Offset(size.width, size.height * 0.80),
          ];

    path.moveTo(points.first.dx, points.first.dy);
    fillPath.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );

      fillPath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.35),
          color.withValues(alpha: 0.05),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant ProviderSparklinePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isIncrease != isIncrease;
  }
}
