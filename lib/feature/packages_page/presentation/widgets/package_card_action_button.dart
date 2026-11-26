import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class PackageCardActionButton extends StatelessWidget {
  const PackageCardActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onTap,
    this.width = 85,
    this.isOutlined = true,
  });

  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final double width;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: SizedBox(
        width: width,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isOutlined ? color.withValues(alpha: 0.08) : color,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: onTap == null ? AppColors.greyColor : color,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: isOutlined
                      ? (onTap == null ? AppColors.greyColor : color)
                      : AppColors.whiteColor,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: TextInAppWidget(
                    text: text.tr(),
                    textSize: 11,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: isOutlined
                        ? (onTap == null ? AppColors.greyColor : color)
                        : AppColors.whiteColor,
                    isTextCenter: true,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
