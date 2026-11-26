import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class CompanyCarStatusBadge extends StatelessWidget {
  final int approvalStatus;
  final bool isActive;

  const CompanyCarStatusBadge({
    super.key,
    required this.approvalStatus,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    if (!isActive) {
      bgColor = AppColors.badgeGreyBg;
      textColor = AppColors.darkGreyColor;
      label = 'غير نشط';
    } else if (approvalStatus == 1) {
      bgColor = AppColors.badgeOrangeBg;
      textColor = AppColors.orangeColor;
      label = 'قيد المراجعة';
    } else if (approvalStatus == 2) {
      bgColor = AppColors.badgeGreenBg;
      textColor = AppColors.partGreenMixColor;
      label = 'معتمد';
    } else if (approvalStatus == 3) {
      bgColor = AppColors.badgeRedBg;
      textColor = AppColors.redColor;
      label = 'مرفوض';
    } else {
      bgColor = AppColors.badgeGreyBg;
      textColor = AppColors.darkGreyColor;
      label = 'غير محدد';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: TextInAppWidget(
        text: label,
        textSize: 11,
        fontWeightIndex: FontSelectionData.boldFontFamily,
        textColor: textColor,
      ),
    );
  }
}

class CompanyCarPendingUpdateBadge extends StatelessWidget {
  const CompanyCarPendingUpdateBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.lightBlueSoft,
        borderRadius: BorderRadius.circular(6),
        border:
            Border.all(color: AppColors.blueAccentColor.withValues(alpha: 0.3)),
      ),
      child: const TextInAppWidget(
        text: 'تعديل معلق',
        textSize: 11,
        fontWeightIndex: FontSelectionData.boldFontFamily,
        textColor: AppColors.blueAccentColor,
      ),
    );
  }
}
