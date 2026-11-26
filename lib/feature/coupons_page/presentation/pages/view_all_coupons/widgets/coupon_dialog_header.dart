import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CouponDialogHeader extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onClose;

  const CouponDialogHeader({
    super.key,
    required this.isEditMode,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(
            color: AppColors.darkColor.withValues(alpha: 0.08),
          ),
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
                    color: AppColors.orangeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isEditMode
                        ? Icons.edit_note
                        : Icons.confirmation_num_outlined,
                    color: AppColors.orangeColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInAppWidget(
                        text: isEditMode
                            ? LocaleKeys.edit
                            : LocaleKeys.createCoupon,
                        textSize: 16,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.darkColor,
                        isEllipsisTextOverflow: true,
                      ),
                      const SizedBox(height: 2),
                      const TextInAppWidget(
                        text: LocaleKeys.manageCouponDataAndRules,
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
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              color: AppColors.darkGreyColor,
              splashRadius: 20,
              tooltip: LocaleKeys.cancel,
            ),
          ),
        ],
      ),
    );
  }
}
