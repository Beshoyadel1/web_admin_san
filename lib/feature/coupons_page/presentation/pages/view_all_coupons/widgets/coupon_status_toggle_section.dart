import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class CouponStatusToggleSection extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const CouponStatusToggleSection({
    super.key,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        (isActive ? AppColors.greenColor : AppColors.greyColor)
                            .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isActive ? Icons.check_circle_outline : Icons.block,
                    size: 20,
                    color:
                        isActive ? AppColors.greenColor : AppColors.greyColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInAppWidget(
                        text:
                            isActive ? LocaleKeys.active : LocaleKeys.inactive,
                        textSize: 14,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.darkColor,
                        isEllipsisTextOverflow: true,
                      ),
                      const SizedBox(height: 2),
                      TextInAppWidget(
                        text: isActive
                            ? LocaleKeys.couponReadyForUseDesc.tr()
                            : LocaleKeys.couponDisabledDesc.tr(),
                        textSize: 12,
                        textColor: AppColors.darkGreyColor,
                        isEllipsisTextOverflow: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isActive,
            activeThumbColor: AppColors.orangeColor,
            activeTrackColor: AppColors.orangeColor.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.greyColor,
            inactiveTrackColor: AppColors.lightGreyColor,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}
