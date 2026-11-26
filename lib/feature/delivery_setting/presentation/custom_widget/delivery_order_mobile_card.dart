import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../data/model/delivery_order_model.dart';
import 'delivery_order_expanded_details.dart';
import 'delivery_order_status_badge.dart';

class DeliveryOrderMobileCard extends StatelessWidget {
  final DeliveryOrderItemModel order;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onCancelOrder;

  const DeliveryOrderMobileCard({
    super.key,
    required this.order,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onCancelOrder,
  });

  bool get _isCancellable {
    final status = order.deliveryOrderStatus.toLowerCase();
    return status != 'delivered' &&
        status != 'completed' &&
        status != 'cancelled' &&
        status != 'canceled';
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = order.orderDate != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(order.orderDate!)
        : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? AppColors.orangeColor : AppColors.cardStroke,
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: onToggleExpand,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar: Order ID, Status Badge, and Expand Chevron
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightOrangeColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '#${order.orderId}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.orangeColor,
                                  ),
                                ),
                              ),
                              DeliveryOrderStatusBadge(
                                status: order.deliveryOrderStatus,
                              ),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 24,
                            color: AppColors.darkGreyColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      color: AppColors.veryLightGreyColor,
                      height: 1,
                    ),
                    const SizedBox(height: 10),

                    // Customer Row (Name + Phone)
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: AppColors.darkGreyColor,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            order.customerName.isNotEmpty
                                ? order.customerName
                                : '-',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (order.customerPhone.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            order.customerPhone,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.darkGreyColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Provider and Mandoob
                    Row(
                      children: [
                        // Provider
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.storefront_outlined,
                                size: 15,
                                color: AppColors.darkGreyColor,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  order.providerName.isNotEmpty
                                      ? order.providerName
                                      : '-',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Mandoob
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.two_wheeler_outlined,
                                size: 15,
                                color: AppColors.darkGreyColor,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  (order.mandoobName != null &&
                                          order.mandoobName!.isNotEmpty)
                                      ? order.mandoobName!
                                      : '-',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: (order.mandoobName != null &&
                                            order.mandoobName!.isNotEmpty)
                                        ? AppColors.darkColor
                                        : AppColors.darkGreyColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Bottom Bar: Price, Delivery Fee, and Date
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.whiteGreyColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${order.totalPrice.toStringAsFixed(2)} SAR',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.orangeColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(${LocaleKeys.deliveryFee.tr()}: ${order.deliveryFee.toStringAsFixed(2)} SAR)',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.darkGreyColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 11,
                                color: AppColors.darkGreyColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.darkGreyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expanded Content
          if (isExpanded)
            DeliveryOrderExpandedDetails(
              order: order,
              isCancellable: _isCancellable,
              onCancel: onCancelOrder,
            ),
        ],
      ),
    );
  }
}
