import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

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
      status = LocaleKeys.expired;
      color = AppColors.orangeColor;
    } else if (isActive == true) {
      status = LocaleKeys.active;
      color = AppColors.greenColor;
    } else {
      status = LocaleKeys.inactive;
      color = AppColors.redColor;
    }

    final Widget statusWidget = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextInAppWidget(
        text: status,
        textSize: 12,
        fontWeightIndex: FontSelectionData.mediumFontFamily,
        textColor: color,
        isTextCenter: true,
      ),
    );

    if (isExpired || onTap == null) {
      return statusWidget;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Tooltip(
          message: isActive == true
              ? LocaleKeys.clickToDeactivate.tr()
              : LocaleKeys.clickToActivate.tr(),
          child: statusWidget,
        ),
      ),
    );
  }
}
