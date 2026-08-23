import 'package:flutter/material.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';


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
    this.isSelectable = false,
    this.onChanged,
  });

  final int? discountType;
  final bool isSelectable;
  final ValueChanged<int?>? onChanged;

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
    final content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: typeColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            typeIcon,
            size: 14,
            color: typeColor,
          ),
          const SizedBox(width: 5),
          TextInAppWidget(
            text: typeText,
            textSize: 12,
            fontWeightIndex:
            FontSelectionData.mediumFontFamily,
            textColor: typeColor,
            isTextCenter: true,
          ),
        ],
      ),
    );

    if (!isSelectable) {
      return content;
    }

    return PopupMenuButton<int>(
      onSelected: (value) {
        onChanged?.call(value);
      },
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: DiscountType.fixedAmount,
          child: TextInAppWidget(
            text: AppLanguageKeys.fixedAmount,
            textSize: 13,
          ),
        ),
        const PopupMenuItem<int>(
          value: DiscountType.percentage,
          child: TextInAppWidget(
            text: AppLanguageKeys.percentage,
            textSize: 13,
          ),
        ),
      ],
      child: content,
    );
  }
}