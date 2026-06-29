import 'dart:math';
import 'package:flutter/material.dart';

class MultiArcDiagram extends StatelessWidget {
  const MultiArcDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(220, 220),
      painter: MultiArcPainter(),
    );
  }
}

class MultiArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 22.0;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const gap = 10.0; // gap بين كل جزء

    final sweep = ((360 - gap * 4) / 4) * pi / 180;
    final gapRad = gap * pi / 180;

    double start = -90 * pi / 180;

    final colors = [
      const Color(0xffFF6A1A),
      const Color(0xff8E9196),
      const Color(0xffB9E7ED),
      const Color(0xff2D99AC),
    ];

    for (final color in colors) {
      paint.color = color;

      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        paint,
      );

      start += sweep + gapRad;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}