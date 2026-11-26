import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class PackageDetailsFieldTile extends StatelessWidget {
  const PackageDetailsFieldTile({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  final String title;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.trim().isEmpty ? '---' : value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: AppColors.greyColor,
                ),
                const SizedBox(width: 5),
              ],
              TextInAppWidget(
                text: title.tr(),
                textSize: 12,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
                textColor: AppColors.greyColor,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 38,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.lightGreyColor.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
            alignment: AlignmentDirectional.centerStart,
            child: TextInAppWidget(
              text: displayValue,
              textSize: 14,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor: AppColors.darkColor,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
