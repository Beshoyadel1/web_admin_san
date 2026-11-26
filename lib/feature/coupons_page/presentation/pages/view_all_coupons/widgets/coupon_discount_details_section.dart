import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/text_form_field_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CouponDiscountDetailsSection extends StatelessWidget {
  final TextEditingController discountValueController;
  final TextEditingController maxDiscountController;
  final TextEditingController minValueController;
  final bool isPercentage;

  const CouponDiscountDetailsSection({
    super.key,
    required this.discountValueController,
    required this.maxDiscountController,
    required this.minValueController,
    this.isPercentage = false,
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
                Icons.calculate_outlined,
                size: 18,
                color: AppColors.orangeColor,
              ),
              SizedBox(width: 6),
              TextInAppWidget(
                text: LocaleKeys.discountValuesAndRules,
                textSize: 14,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.darkColor,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Discount Value
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInAppWidget(
                      text: isPercentage
                          ? '${LocaleKeys.discountValue} (%)'
                          : LocaleKeys.discountValue,
                      textSize: 13,
                      textColor: AppColors.darkGreyColor,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                    ),
                    const SizedBox(height: 6),
                    TextFormFieldWidget(
                      textFormController: discountValueController,
                      isDigitDot: true,
                      hintText:
                          '${LocaleKeys.example.tr()}: ${isPercentage ? '15' : '50.0'}',
                      fillColor: AppColors.scaffoldColor,
                      borderColor: AppColors.darkColor.withValues(alpha: 0.15),
                      hintTextSize: 13,
                      hintTextColor: AppColors.greyColor,
                      textSize: 14,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.enterDiscountValuePrompt.tr();
                        }
                        final num = double.tryParse(value.trim());
                        if (num == null || num <= 0) {
                          return LocaleKeys.invalidValue.tr();
                        }
                        if (isPercentage && num > 100) {
                          return LocaleKeys.percentageCannotExceed100.tr();
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Max Discount Value
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextInAppWidget(
                      text: LocaleKeys.maxDiscountValue,
                      textSize: 13,
                      textColor: AppColors.darkGreyColor,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                    ),
                    const SizedBox(height: 6),
                    TextFormFieldWidget(
                      textFormController: maxDiscountController,
                      isDigitDot: true,
                      hintText: '${LocaleKeys.example.tr()}: 100.0',
                      fillColor: AppColors.scaffoldColor,
                      borderColor: AppColors.darkColor.withValues(alpha: 0.15),
                      hintTextSize: 13,
                      hintTextColor: AppColors.greyColor,
                      textSize: 14,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.enterMaxDiscountPrompt.tr();
                        }
                        final num = double.tryParse(value.trim());
                        if (num == null || num < 0) {
                          return LocaleKeys.invalidValue.tr();
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Min Cart Value to Apply
          const TextInAppWidget(
            text: LocaleKeys.minValueToApply,
            textSize: 13,
            textColor: AppColors.darkGreyColor,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
          ),
          const SizedBox(height: 6),
          TextFormFieldWidget(
            textFormController: minValueController,
            isDigitDot: true,
            hintText:
                '${LocaleKeys.example.tr()}: 150.0 (${LocaleKeys.minOrderValue.tr()})',
            fillColor: AppColors.scaffoldColor,
            borderColor: AppColors.darkColor.withValues(alpha: 0.15),
            hintTextSize: 13,
            hintTextColor: AppColors.greyColor,
            textSize: 14,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return LocaleKeys.enterMinOrderPrompt.tr();
              }
              final num = double.tryParse(value.trim());
              if (num == null || num < 0) {
                return LocaleKeys.invalidValue.tr();
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
