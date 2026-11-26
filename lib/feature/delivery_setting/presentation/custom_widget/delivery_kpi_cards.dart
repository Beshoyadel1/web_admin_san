import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../data/model/delivery_setting_model.dart';

class DeliveryKpiCards extends StatelessWidget {
  final DeliveryInfoModel? deliveryInfo;

  const DeliveryKpiCards({
    super.key,
    required this.deliveryInfo,
  });

  @override
  Widget build(BuildContext context) {
    final setting = deliveryInfo?.deliverySetting;
    final totalOrders = deliveryInfo?.totalDeliveryOrdersCount ?? 0;
    final isEnabled = setting?.isDeliveryEnabled ?? false;
    final price = setting?.deliveryPrice ?? 0.0;
    final cost = setting?.deliveryCost ?? 0.0;
    final margin = price - cost;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;
        final int crossAxisCount = constraints.maxWidth < 1100 ? 2 : 4;
        final double spacing = isMobile ? 10.0 : 16.0;
        final double totalSpacing = spacing * (crossAxisCount - 1);
        final double cardWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;

        // Ensure fixed height regardless of width so content never overflows
        final double targetHeight = isMobile ? 116.0 : 126.0;
        final double childAspectRatio = cardWidth / targetHeight;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: childAspectRatio,
          children: [
            DeliveryKpiItemCard(
              title: LocaleKeys.totalDeliveryOrders.tr(),
              value: totalOrders.toString(),
              subtitle: LocaleKeys.order.tr(),
              icon: Icons.local_shipping_outlined,
              iconColor: AppColors.seaBlueColor,
              iconBgColor: AppColors.blueColor100,
              isMobile: isMobile,
            ),
            DeliveryKpiItemCard(
              title: LocaleKeys.deliveryStatus.tr(),
              value: isEnabled
                  ? LocaleKeys.active.tr()
                  : LocaleKeys.drivers_disabled.tr(),
              subtitle: isEnabled ? 'Active' : 'Disabled',
              icon: isEnabled
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              iconColor: isEnabled ? AppColors.greenColor : AppColors.redColor,
              iconBgColor: isEnabled
                  ? AppColors.lightGreenColor
                  : AppColors.whiteColorF4,
              isMobile: isMobile,
            ),
            DeliveryKpiItemCard(
              title: LocaleKeys.deliveryFee.tr(),
              value: price.toStringAsFixed(2),
              subtitle: 'SAR',
              icon: Icons.payments_outlined,
              iconColor: AppColors.orangeColor,
              iconBgColor: AppColors.CircleLightorangeColor,
              isMobile: isMobile,
            ),
            DeliveryKpiItemCard(
              title: LocaleKeys.deliveryMargin.tr(),
              value: margin.toStringAsFixed(2),
              subtitle:
                  '${LocaleKeys.deliveryCostNet.tr()}: ${cost.toStringAsFixed(2)} SAR',
              icon: Icons.trending_up_outlined,
              iconColor: margin >= 0 ? AppColors.cyanColor : AppColors.redColor,
              iconBgColor: margin >= 0
                  ? AppColors.lightCyanColor
                  : AppColors.whiteColorF4,
              isMobile: isMobile,
            ),
          ],
        );
      },
    );
  }
}

class DeliveryKpiItemCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final bool isMobile;

  const DeliveryKpiItemCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 14,
        vertical: isMobile ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardStroke, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 11.5 : 12.5,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(isMobile ? 5 : 7),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: isMobile ? 16 : 18,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 17 : 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkColor,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreyColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
