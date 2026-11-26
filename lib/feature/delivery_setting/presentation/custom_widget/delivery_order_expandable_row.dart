import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../data/model/delivery_order_model.dart';
import 'delivery_order_expanded_details.dart';
import 'delivery_order_status_badge.dart';

class DeliveryOrderExpandableRow extends StatefulWidget {
  final DeliveryOrderItemModel order;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onCancelOrder;

  const DeliveryOrderExpandableRow({
    super.key,
    required this.order,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onCancelOrder,
  });

  @override
  State<DeliveryOrderExpandableRow> createState() =>
      _DeliveryOrderExpandableRowState();
}

class _DeliveryOrderExpandableRowState
    extends State<DeliveryOrderExpandableRow> {
  bool _isHovered = false;

  bool get _isCancellable {
    final status = widget.order.deliveryOrderStatus.toLowerCase();
    return status != 'delivered' &&
        status != 'completed' &&
        status != 'cancelled' &&
        status != 'canceled';
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = widget.order.orderDate != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(widget.order.orderDate!)
        : '-';

    final rowBgColor = widget.isExpanded
        ? AppColors.lightOrangeColor.withValues(alpha: 0.35)
        : (_isHovered ? AppColors.whiteGreyColor : AppColors.whiteColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onToggleExpand,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: rowBgColor,
                border: Border(
                  bottom: BorderSide(
                    color: widget.isExpanded
                        ? AppColors.orangeColor.withValues(alpha: 0.3)
                        : AppColors.veryLightGreyColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Expand arrow
                  SizedBox(
                    width: 36,
                    child: Center(
                      child: AnimatedRotation(
                        turns: widget.isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22,
                          color: widget.isExpanded
                              ? AppColors.orangeColor
                              : AppColors.darkGreyColor,
                        ),
                      ),
                    ),
                  ),

                  // Order #
                  Expanded(
                    flex: 10,
                    child: Text(
                      '#${widget.order.orderId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.orangeColor,
                      ),
                    ),
                  ),

                  // Provider
                  Expanded(
                    flex: 14,
                    child: Text(
                      widget.order.providerName.isNotEmpty
                          ? widget.order.providerName
                          : '-',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.darkColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Customer
                  Expanded(
                    flex: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.order.customerName.isNotEmpty
                              ? widget.order.customerName
                              : '-',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.order.customerPhone.isNotEmpty)
                          Text(
                            widget.order.customerPhone,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.darkGreyColor,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Mandoob
                  Expanded(
                    flex: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (widget.order.mandoobName != null &&
                                  widget.order.mandoobName!.isNotEmpty)
                              ? widget.order.mandoobName!
                              : '-',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.darkColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.order.mandoobPhone != null &&
                            widget.order.mandoobPhone!.isNotEmpty)
                          Text(
                            widget.order.mandoobPhone!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.darkGreyColor,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Delivery Fee
                  Expanded(
                    flex: 12,
                    child: Text(
                      '${widget.order.deliveryFee.toStringAsFixed(2)} SAR',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),

                  // Total
                  Expanded(
                    flex: 12,
                    child: Text(
                      '${widget.order.totalPrice.toStringAsFixed(2)} SAR',
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
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: DeliveryOrderStatusBadge(
                        status: widget.order.deliveryOrderStatus,
                      ),
                    ),
                  ),

                  // Date
                  Expanded(
                    flex: 14,
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.darkGreyColor,
                      ),
                    ),
                  ),

                  // Action
                  SizedBox(
                    width: 48,
                    child: Center(
                      child: _isCancellable
                          ? MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  color: AppColors.redColor,
                                  size: 20,
                                ),
                                tooltip: LocaleKeys.cancelDelivery.tr(),
                                onPressed: widget.onCancelOrder,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Expanded details
        if (widget.isExpanded)
          DeliveryOrderExpandedDetails(
            order: widget.order,
            isCancellable: _isCancellable,
            onCancel: widget.onCancelOrder,
          ),
      ],
    );
  }
}
