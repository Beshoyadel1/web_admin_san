import 'package:flutter/material.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

class CouponStatusWidget extends StatelessWidget {
  const CouponStatusWidget({
    super.key,
    required this.isActive,
    required this.endDate,
    this.onTap,
  });

  final bool? isActive;
  final DateTime? endDate;
  final VoidCallback? onTap;

  bool get isExpired {
    if (endDate == null) return false;

    return DateTime.now().isAfter(endDate!);
  }

  bool get isCouponActive {
    return isActive == true && !isExpired;
  }

  @override
  Widget build(BuildContext context) {
    final String status;
    final Color color;

    if (isExpired) {
      status = AppLanguageKeys.expired;
      color = AppColors.orangeColor;
    } else if (isActive == true) {
      status = AppLanguageKeys.active;
      color = AppColors.greenColor;
    } else {
      status = AppLanguageKeys.inactive;
      color = Colors.red;
    }

    final Widget statusWidget = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextInAppWidget(
        text: status,
        textSize: 12,
        fontWeightIndex:
        FontSelectionData.mediumFontFamily,
        textColor: color,
        isTextCenter: true,
      ),
    );

    if (!isCouponActive || onTap == null) {
      return statusWidget;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: statusWidget,
    );
  }
}