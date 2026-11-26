import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details/order_details.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../data/model/delivery_order_model.dart';
import 'delivery_order_status_badge.dart';

class DeliveryOrderCardWidget extends StatelessWidget {
  final DeliveryOrderItemModel order;

  const DeliveryOrderCardWidget({
    super.key,
    required this.order,
  });

  void _openOrderDetails(BuildContext context) {
    Navigator.push(
      context,
      NavigateToPageWidget(OrderDetails(orderId: order.orderId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 1100;
        final bool isTablet =
            constraints.maxWidth >= 650 && constraints.maxWidth < 1100;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 16 : 14,
            vertical: isDesktop ? 12 : 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardStroke, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isDesktop
              ? DeliveryOrderDesktopCardRow(
                  order: order,
                  onDetailsTap: () => _openOrderDetails(context),
                )
              : isTablet
                  ? DeliveryOrderTabletCardContent(
                      order: order,
                      onDetailsTap: () => _openOrderDetails(context),
                    )
                  : DeliveryOrderMobileCardContent(
                      order: order,
                      onDetailsTap: () => _openOrderDetails(context),
                    ),
        );
      },
    );
  }
}

class DeliveryOrderBadgeTag extends StatelessWidget {
  const DeliveryOrderBadgeTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.lightOrangeColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.orangeColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            size: 13,
            color: AppColors.orangeColor,
          ),
          const SizedBox(width: 4),
          Text(
            LocaleKeys.deliveryOrderBadge.tr(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.orangeColor,
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryOrderDesktopCardRow extends StatelessWidget {
  final DeliveryOrderItemModel order;
  final VoidCallback onDetailsTap;

  const DeliveryOrderDesktopCardRow({
    super.key,
    required this.order,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = order.orderDate != null
        ? DateFormat('yyyy-MM-dd').format(order.orderDate!)
        : '-';
    final formattedTime = order.orderDate != null
        ? DateFormat('HH:mm').format(order.orderDate!)
        : '';

    return Row(
      children: [
        // 1. Identity & Delivery Badge
        Expanded(
          flex: 13,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '#${order.orderId}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: AppColors.darkColor,
                ),
              ),
              const SizedBox(height: 4),
              const DeliveryOrderBadgeTag(),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // 2. Provider
        Expanded(
          flex: 14,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.blueColor100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  size: 16,
                  color: AppColors.seaBlueColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.provider.tr(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.darkGreyColor,
                      ),
                    ),
                    Text(
                      order.providerName.isNotEmpty ? order.providerName : '-',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // 3. Customer
        Expanded(
          flex: 15,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.whiteGreyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: AppColors.darkGreyColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      order.customerName.isNotEmpty ? order.customerName : '-',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (order.customerPhone.isNotEmpty)
                      Text(
                        order.customerPhone,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.darkGreyColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // 4. Mandoob Courier
        Expanded(
          flex: 14,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.whiteGreyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.two_wheeler_outlined,
                  size: 16,
                  color: AppColors.darkGreyColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      (order.mandoobName != null &&
                              order.mandoobName!.isNotEmpty)
                          ? order.mandoobName!
                          : '-',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: (order.mandoobName != null &&
                                order.mandoobName!.isNotEmpty)
                            ? AppColors.darkColor
                            : AppColors.darkGreyColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (order.mandoobPhone != null &&
                        order.mandoobPhone!.isNotEmpty)
                      Text(
                        order.mandoobPhone!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.darkGreyColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // 5. Delivery Status Badge
        Expanded(
          flex: 13,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: DeliveryOrderStatusBadge(
              status: order.deliveryOrderStatus,
            ),
          ),
        ),
        const SizedBox(width: 10),

        // 6. Date & Time
        Expanded(
          flex: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkColor,
                ),
              ),
              if (formattedTime.isNotEmpty)
                Text(
                  formattedTime,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.darkGreyColor,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // 7. Price (Total + Delivery Fee)
        Expanded(
          flex: 13,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${order.totalPrice.toStringAsFixed(2)} SAR',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.orangeColor,
                ),
              ),
              Text(
                '(${LocaleKeys.deliveryFee.tr()}: ${order.deliveryFee.toStringAsFixed(2)})',
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.darkGreyColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // 8. Details Button
        DeliveryOrderDetailsButton(onTap: onDetailsTap),
      ],
    );
  }
}

class DeliveryOrderTabletCardContent extends StatelessWidget {
  final DeliveryOrderItemModel order;
  final VoidCallback onDetailsTap;

  const DeliveryOrderTabletCardContent({
    super.key,
    required this.order,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = order.orderDate != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(order.orderDate!)
        : '-';

    return Column(
      children: [
        // Top Row: Identity, Provider, Customer, Status
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '#${order.orderId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(width: 8),
                const DeliveryOrderBadgeTag(),
              ],
            ),
            const Spacer(),
            DeliveryOrderStatusBadge(status: order.deliveryOrderStatus),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: AppColors.veryLightGreyColor, height: 1),
        const SizedBox(height: 10),

        // Middle Row: Provider, Customer, Courier
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.storefront_outlined,
                    size: 15,
                    color: AppColors.darkGreyColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      order.providerName.isNotEmpty ? order.providerName : '-',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 15,
                    color: AppColors.darkGreyColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      order.customerName.isNotEmpty ? order.customerName : '-',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.darkColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.two_wheeler_outlined,
                    size: 15,
                    color: AppColors.darkGreyColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      (order.mandoobName != null &&
                              order.mandoobName!.isNotEmpty)
                          ? order.mandoobName!
                          : '-',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.darkColor,
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

        // Bottom Row: Date, Price, Details Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: AppColors.darkGreyColor,
                ),
                const SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.darkGreyColor,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${order.totalPrice.toStringAsFixed(2)} SAR',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
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
                const SizedBox(width: 14),
                DeliveryOrderDetailsButton(onTap: onDetailsTap),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class DeliveryOrderMobileCardContent extends StatelessWidget {
  final DeliveryOrderItemModel order;
  final VoidCallback onDetailsTap;

  const DeliveryOrderMobileCardContent({
    super.key,
    required this.order,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = order.orderDate != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(order.orderDate!)
        : '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Bar: Order ID, Delivery Badge, Status
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    '#${order.orderId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppColors.darkColor,
                    ),
                  ),
                  const DeliveryOrderBadgeTag(),
                ],
              ),
            ),
            DeliveryOrderStatusBadge(status: order.deliveryOrderStatus),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: AppColors.veryLightGreyColor, height: 1),
        const SizedBox(height: 10),

        // Customer Info
        Row(
          children: [
            const Icon(
              Icons.person_outline,
              size: 15,
              color: AppColors.darkGreyColor,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                order.customerName.isNotEmpty ? order.customerName : '-',
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

        // Provider & Courier Info
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.storefront_outlined,
                    size: 14,
                    color: AppColors.darkGreyColor,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      order.providerName.isNotEmpty ? order.providerName : '-',
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
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.two_wheeler_outlined,
                    size: 14,
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

        // Bottom Bar: Price, Date & Details Action
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.whiteGreyColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(
                    '(${LocaleKeys.deliveryFee.tr()}: ${order.deliveryFee.toStringAsFixed(2)} SAR) • $formattedDate',
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                ],
              ),
              DeliveryOrderDetailsButton(
                onTap: onDetailsTap,
                isSmall: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DeliveryOrderDetailsButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSmall;

  const DeliveryOrderDetailsButton({
    super.key,
    required this.onTap,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isSmall ? 5 : 6,
            horizontal: isSmall ? 12 : 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.orangeColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkColor.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              LocaleKeys.details.tr(),
              style: TextStyle(
                fontSize: isSmall ? 11.5 : 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.orangeColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
