import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

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
      return LocaleKeys.fixedAmount;
    }

    if (isPercentage) {
      return LocaleKeys.percentage;
    }

    return LocaleKeys.unknownType;
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
        color: typeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: typeColor.withValues(alpha: 0.2),
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
            fontWeightIndex: FontSelectionData.mediumFontFamily,
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
            text: LocaleKeys.fixedAmount,
            textSize: 13,
          ),
        ),
        const PopupMenuItem<int>(
          value: DiscountType.percentage,
          child: TextInAppWidget(
            text: LocaleKeys.percentage,
            textSize: 13,
          ),
        ),
      ],
      child: content,
    );
  }
}
