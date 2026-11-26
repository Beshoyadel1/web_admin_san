import 'package:flutter/material.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

class StatCard extends StatelessWidget {
  final double width;
  final String title;
  final Widget child;
  final IconData icon;
  final Color? iconBgColor;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.width,
    required this.title,
    required this.child,
    required this.icon,
    this.iconBgColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 88),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.veryLightGreyColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInAppWidget(
                  text: title,
                  textSize: 12,
                  textColor: AppColors.darkGreyColor,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  maxLines: 1,
                  isEllipsisTextOverflow: true,
                ),
                const SizedBox(height: 6),
                child,
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor ?? AppColors.veryLightGreyColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: iconColor ?? AppColors.orangeColor,
            ),
          ),
        ],
      ),
    );
  }
}
