import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class DeliveryOrderStatusBadge extends StatelessWidget {
  final String status;

  const DeliveryOrderStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusConfig.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusConfig.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: statusConfig.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusConfig.labelKey.tr(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusConfig.textColor,
            ),
          ),
        ],
      ),
    );
  }

  _StatusStyle _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'new':
      case 'neworder':
        return const _StatusStyle(
          labelKey: LocaleKeys.deliveryStatusNew,
          backgroundColor: AppColors.blueColor100,
          borderColor: AppColors.blueColorBF,
          dotColor: AppColors.seaBlueColor,
          textColor: AppColors.seaBlueColor,
        );
      case 'accepted':
        return const _StatusStyle(
          labelKey: LocaleKeys.deliveryStatusAccepted,
          backgroundColor: AppColors.lightGreenColor,
          borderColor: AppColors.cyanColor,
          dotColor: AppColors.cyanColor,
          textColor: AppColors.secondaryColor,
        );
      case 'arrived_to_store':
      case 'arrivedtostore':
        return const _StatusStyle(
          labelKey: LocaleKeys.deliveryStatusArrivedStore,
          backgroundColor: AppColors.CircleLightorangeColor,
          borderColor: AppColors.yelloIconLoadingColor,
          dotColor: AppColors.yelloTextLoadingColor,
          textColor: AppColors.darkorangeColor,
        );
      case 'picked':
      case 'pickedup':
        return const _StatusStyle(
          labelKey: LocaleKeys.deliveryStatusPicked,
          backgroundColor: AppColors.pinkColor,
          borderColor: AppColors.veryLightOrangeColor,
          dotColor: AppColors.orangeColor,
          textColor: AppColors.darkorangeColor,
        );
      case 'delivered':
      case 'completed':
        return const _StatusStyle(
          labelKey: LocaleKeys.deliveryStatusDelivered,
          backgroundColor: AppColors.lightGreenColor,
          borderColor: AppColors.partGreenMixColor,
          dotColor: AppColors.greenColor,
          textColor: AppColors.greenColor,
        );
      case 'cancelled':
      case 'canceled':
        return const _StatusStyle(
          labelKey: LocaleKeys.deliveryStatusCancelled,
          backgroundColor: AppColors.whiteColorF4,
          borderColor: AppColors.lightRedColor,
          dotColor: AppColors.redColor,
          textColor: AppColors.redColor,
        );
      default:
        return _StatusStyle(
          labelKey: status,
          backgroundColor: AppColors.veryLightGreyColor,
          borderColor: AppColors.lightGreyColor,
          dotColor: AppColors.darkGreyColor,
          textColor: AppColors.darkGreyColor,
        );
    }
  }
}

class _StatusStyle {
  final String labelKey;
  final Color backgroundColor;
  final Color borderColor;
  final Color dotColor;
  final Color textColor;

  const _StatusStyle({
    required this.labelKey,
    required this.backgroundColor,
    required this.borderColor,
    required this.dotColor,
    required this.textColor,
  });
}
