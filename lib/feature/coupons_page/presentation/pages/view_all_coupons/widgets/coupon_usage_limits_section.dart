import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/text_form_field_widget.dart';

class CouponUsageLimitsSection extends StatelessWidget {
  final TextEditingController usersUseCountController;
  final TextEditingController oneUserUseCountController;

  const CouponUsageLimitsSection({
    super.key,
    required this.usersUseCountController,
    required this.oneUserUseCountController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.people_alt_outlined,
                size: 18,
                color: AppColors.orangeColor,
              ),
              SizedBox(width: 6),
              TextInAppWidget(
                text: LocaleKeys.usageLimits,
                textSize: 14,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.darkColor,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Total users usage limit
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextInAppWidget(
                      text: LocaleKeys.usersUseCount,
                      textSize: 13,
                      textColor: AppColors.darkGreyColor,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                    ),
                    const SizedBox(height: 6),
                    TextFormFieldWidget(
                      textFormController: usersUseCountController,
                      isDigit: true,
                      hintText: '${LocaleKeys.example.tr()}: 500',
                      fillColor: AppColors.scaffoldColor,
                      borderColor: AppColors.darkColor.withValues(alpha: 0.15),
                      hintTextSize: 13,
                      hintTextColor: AppColors.greyColor,
                      textSize: 14,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.enterTotalUsageLimit.tr();
                        }
                        final num = int.tryParse(value.trim());
                        if (num == null || num <= 0) {
                          return LocaleKeys.invalidNumber.tr();
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Single user usage limit
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextInAppWidget(
                      text: LocaleKeys.oneUserUseCount,
                      textSize: 13,
                      textColor: AppColors.darkGreyColor,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                    ),
                    const SizedBox(height: 6),
                    TextFormFieldWidget(
                      textFormController: oneUserUseCountController,
                      isDigit: true,
                      hintText: '${LocaleKeys.example.tr()}: 1',
                      fillColor: AppColors.scaffoldColor,
                      borderColor: AppColors.darkColor.withValues(alpha: 0.15),
                      hintTextSize: 13,
                      hintTextColor: AppColors.greyColor,
                      textSize: 14,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.pleaseEnterUserLimit.tr();
                        }
                        final num = int.tryParse(value.trim());
                        if (num == null || num <= 0) {
                          return LocaleKeys.invalidNumber.tr();
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
