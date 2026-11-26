import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/widgets/text_form_field_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CouponBasicInfoSection extends StatelessWidget {
  final TextEditingController codeController;
  final int? selectedDiscountType;
  final ValueChanged<int?> onDiscountTypeChanged;

  const CouponBasicInfoSection({
    super.key,
    required this.codeController,
    required this.selectedDiscountType,
    required this.onDiscountTypeChanged,
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
                Icons.tag,
                size: 18,
                color: AppColors.orangeColor,
              ),
              SizedBox(width: 6),
              TextInAppWidget(
                text: LocaleKeys.basicDataAndDiscountType,
                textSize: 14,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.darkColor,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Coupon Code Field
          const TextInAppWidget(
            text: LocaleKeys.couponCode,
            textSize: 13,
            textColor: AppColors.darkGreyColor,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
          ),
          const SizedBox(height: 6),
          TextFormFieldWidget(
            textFormController: codeController,
            hintText: '${LocaleKeys.example.tr()}: SAN2026',
            fillColor: AppColors.scaffoldColor,
            borderColor: AppColors.darkColor.withValues(alpha: 0.15),
            hintTextSize: 13,
            hintTextColor: AppColors.greyColor,
            textSize: 14,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return LocaleKeys.enterCouponCodePrompt.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Discount Type Selector
          const TextInAppWidget(
            text: LocaleKeys.discountType,
            textSize: 13,
            textColor: AppColors.darkGreyColor,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
          ),
          const SizedBox(height: 6),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.scaffoldColor,
              border: Border.all(
                color: AppColors.darkColor.withValues(alpha: 0.15),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedDiscountType,
                hint: const TextInAppWidget(
                  text: LocaleKeys.pleaseSelectDiscountType,
                  textSize: 13,
                  textColor: AppColors.greyColor,
                ),
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.darkGreyColor,
                ),
                items: const [
                  DropdownMenuItem<int>(
                    value: DiscountType.fixedAmount,
                    child: Row(
                      children: [
                        Icon(
                          Icons.money,
                          size: 18,
                          color: AppColors.orangeColor,
                        ),
                        SizedBox(width: 8),
                        TextInAppWidget(
                          text: LocaleKeys.fixedAmount,
                          textSize: 13,
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: DiscountType.percentage,
                    child: Row(
                      children: [
                        Icon(
                          Icons.percent,
                          size: 18,
                          color: AppColors.greenColor,
                        ),
                        SizedBox(width: 8),
                        TextInAppWidget(
                          text: LocaleKeys.percentage,
                          textSize: 13,
                        ),
                      ],
                    ),
                  ),
                ],
                onChanged: onDiscountTypeChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
