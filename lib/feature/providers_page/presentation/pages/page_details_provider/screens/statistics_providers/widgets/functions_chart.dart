import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/utils/formatters.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

import '../../../../../../../../core/helpers/themes/fonts.dart';

OverlayEntry? overlayEntry;

void showTooltipOverlay(
    BuildContext context, Offset globalPosition, LineBarSpot spot) {
  removeOverlay();
  final overlay = Overlay.maybeOf(context);
  if (overlay == null) return;

  const double tooltipWidth = 120;
  const double tooltipHeight = 56;
  final left = globalPosition.dx - (tooltipWidth / 2);
  final top = globalPosition.dy - tooltipHeight - 12;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      left: left.clamp(
          8.0, MediaQuery.of(context).size.width - tooltipWidth - 8.0),
      top: top.clamp(
          8.0, MediaQuery.of(context).size.height - tooltipHeight - 8.0),
      width: tooltipWidth,
      height: tooltipHeight,
      child: Material(
        color: AppColors.transparent,
        child: Container(
          height: 66,
          width: 119,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.18),
                blurRadius: 12,
                spreadRadius: 0.5,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextInAppWidget(
                  text: spot.x.toInt() > 0
                      ? formatDateFromMilliseconds(spot.x.toInt())
                      : '',
                  textColor: AppColors.darkColor,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                  textSize: 14,
                ),
                const SizedBox(height: 4),
                TextInAppWidget(
                  text: '${spot.y.toInt()} ${LocaleKeys.sarCurrency.tr()}',
                  textColor: AppColors.seaBlueColor,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                  textSize: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry!);
}

void removeOverlay() {
  if (overlayEntry != null) {
    overlayEntry!.remove();
    overlayEntry = null;
  }
}

String formatDateFromMilliseconds(int ms) {
  final date = DateTime.fromMillisecondsSinceEpoch(ms);
  return '${date.day} ${getMonthName(date.month)}';
}
