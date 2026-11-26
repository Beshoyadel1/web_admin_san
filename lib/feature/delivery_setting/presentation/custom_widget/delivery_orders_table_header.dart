import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class DeliveryOrdersTableHeader extends StatelessWidget {
  const DeliveryOrdersTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.whiteGreyColor,
        border: Border(
          bottom: BorderSide(color: AppColors.cardStroke, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Placeholder for expand chevron
          const SizedBox(width: 36),

          // Order #
          Expanded(
            flex: 10,
            child: Text(
              '${LocaleKeys.order.tr()} #',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.darkColor,
              ),
            ),
          ),

          // Provider
          Expanded(
            flex: 14,
            child: Text(
              LocaleKeys.provider.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.darkColor,
              ),
            ),
          ),

          // Customer
          Expanded(
            flex: 16,
            child: Text(
              LocaleKeys.user.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.darkColor,
              ),
            ),
          ),

          // Mandoob
          Expanded(
            flex: 14,
            child: Text(
              LocaleKeys.mandoobName.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.darkColor,
              ),
            ),
          ),

          // Delivery Fee
          Expanded(
            flex: 12,
            child: Text(
              LocaleKeys.deliveryFee.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.darkColor,
              ),
            ),
          ),

          // Total
          Expanded(
            flex: 12,
            child: Text(
              LocaleKeys.total.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.darkColor,
              ),
            ),
          ),

          // Status
          Expanded(
            flex: 14,
            child: Text(
              LocaleKeys.deliveryOrderStatus.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.darkColor,
              ),
            ),
          ),

          // Date
          Expanded(
            flex: 14,
            child: Text(
              LocaleKeys.orderDate.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.darkColor,
              ),
            ),
          ),

          // Action
          SizedBox(
            width: 48,
            child: Center(
              child: Text(
                LocaleKeys.action.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.darkColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
