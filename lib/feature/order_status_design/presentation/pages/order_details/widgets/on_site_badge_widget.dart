import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class OnSiteBadgeWidget extends StatelessWidget {
  final bool isOnSite;

  const OnSiteBadgeWidget({
    super.key,
    required this.isOnSite,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isOnSite ? AppColors.lightGreenColor : AppColors.blueColor100;
    final fgColor = isOnSite ? AppColors.seaBlueColor : AppColors.blueColor;
    final iconData =
        isOnSite ? Icons.storefront_outlined : Icons.location_on_outlined;
    final text = isOnSite
        ? LocaleKeys.orderOnSite.tr()
        : LocaleKeys.orderCustomerLocation.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fgColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData, size: 14, color: fgColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}
