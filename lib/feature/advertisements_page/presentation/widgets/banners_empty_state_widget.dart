import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class BannersEmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddBanner;

  const BannersEmptyStateWidget({
    super.key,
    required this.onAddBanner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.scaffoldColor,
            ),
            child: const Icon(
              Icons.view_carousel_outlined,
              size: 52,
              color: AppColors.darkGreyColor,
            ),
          ),
          const SizedBox(height: 16),
          const TextInAppWidget(
            text: 'لا توجد بنرات إعلانية حالياً',
            textSize: 16,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            textColor: AppColors.darkColor,
          ),
          const SizedBox(height: 6),
          const TextInAppWidget(
            text:
                'يمكنك إضافة بنرات إعلانية جديدة وتحديد فترة ظهورها لجميع مستخدمي التطبيق',
            textSize: 13,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.greyColor,
          ),
          const SizedBox(height: 20),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ElevatedButton.icon(
              onPressed: onAddBanner,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                foregroundColor: AppColors.whiteColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.add, size: 18),
              label: TextInAppWidget(
                text: LocaleKeys.createBannerAd.tr(),
                textSize: 14,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
