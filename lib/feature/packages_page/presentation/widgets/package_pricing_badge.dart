import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class PackagePricingBadge extends StatelessWidget {
  const PackagePricingBadge({
    super.key,
    required this.title,
    required this.price,
    required this.icon,
    required this.color,
  });

  final String title;
  final String price;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          TextInAppWidget(
            text: '${title.tr()}: ',
            textSize: 11,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.greyColor,
          ),
          TextInAppWidget(
            text: price,
            textSize: 13,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            textColor: AppColors.darkColor,
          ),
        ],
      ),
    );
  }
}
