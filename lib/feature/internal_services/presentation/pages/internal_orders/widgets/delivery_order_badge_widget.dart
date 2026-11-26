import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class DeliveryOrderBadgeWidget extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const DeliveryOrderBadgeWidget({
    super.key,
    this.iconSize = 11,
    this.fontSize = 9.5,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.orangeColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppColors.orangeColor.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: iconSize,
            color: AppColors.whiteColor,
          ),
          const SizedBox(width: 3),
          Text(
            LocaleKeys.deliveryOrderBadge.tr(),
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
