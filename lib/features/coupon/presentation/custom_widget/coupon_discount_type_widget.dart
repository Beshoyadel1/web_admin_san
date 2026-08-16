import 'package:flutter/material.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';


class CouponDiscountTypeWidget extends StatelessWidget {
  const CouponDiscountTypeWidget({
    super.key,
    required this.discountType,
  });

  final int? discountType;

  bool get isFixedAmount {
    return discountType == DiscountType.fixedAmount;
  }

  bool get isPercentage {
    return discountType == DiscountType.percentage;
  }

  String get typeText {
    if (isFixedAmount) {
      return AppLanguageKeys.fixedAmount;
    }

    if (isPercentage) {
      return AppLanguageKeys.percentage;
    }

    return AppLanguageKeys.unknownType;
  }

  Color get typeColor {
    if (isFixedAmount) {
      return AppColors.orangeColor;
    }

    if (isPercentage) {
      return AppColors.greenColor;
    }

    return AppColors.greyColor;
  }

  IconData get typeIcon {
    if (isFixedAmount) {
      return Icons.payments_outlined;
    }

    if (isPercentage) {
      return Icons.percent;
    }

    return Icons.help_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            typeIcon,
            size: 14,
            color: typeColor,
          ),

          const SizedBox(width: 5),

          Flexible(
            child: TextInAppWidget(
              text: typeText,
              textSize: 12,
              fontWeightIndex:
              FontSelectionData.mediumFontFamily,
              textColor: typeColor,
              isTextCenter: true,
            ),
          ),
        ],
      ),
    );
  }
}