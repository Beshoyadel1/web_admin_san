import 'dart:math';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

class ArcDiagram extends StatelessWidget {
  final double percentage;

  const ArcDiagram({
    super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomPaint(
              size: const Size(220, 220),
              painter: ArcPainter(
                progressPercent: percentage / 100,
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextInAppWidget(
                  text: "%",
                  textSize: 18,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.greyColor,
                ),
                const SizedBox(width: 2),
                TextInAppWidget(
                  text: percentage.toStringAsFixed(0),
                  textSize: 36,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                  textColor: AppColors.greyColor,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double progressPercent;

  ArcPainter({
    required this.progressPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 18.0;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final background = Paint()
      ..color = AppColors.greyColor.withOpacity(.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progress = Paint()
      ..color = AppColors.orangeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const gapAngle = 99.0;
    const startAngle = 90 + gapAngle / 2;

    final totalSweep = (360 - gapAngle) * pi / 180;

    canvas.drawArc(
      rect,
      startAngle * pi / 180,
      totalSweep,
      false,
      background,
    );

    canvas.drawArc(
      rect,
      startAngle * pi / 180,
      totalSweep * progressPercent.clamp(0.0, 1.0),
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return oldDelegate.progressPercent != progressPercent;
  }
}