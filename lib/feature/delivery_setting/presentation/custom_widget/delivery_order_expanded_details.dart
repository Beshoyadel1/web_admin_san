import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../data/model/delivery_order_model.dart';

class DeliveryOrderExpandedDetails extends StatelessWidget {
  final DeliveryOrderItemModel order;
  final bool isCancellable;
  final VoidCallback onCancel;

  const DeliveryOrderExpandedDetails({
    super.key,
    required this.order,
    required this.isCancellable,
    required this.onCancel,
  });

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    AppSnackBar.showSuccess(LocaleKeys.nationalAddressCopied.tr());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;
        final isWide = constraints.maxWidth > 850;
        final cardWidth =
            isWide ? (constraints.maxWidth - 32) / 3 : constraints.maxWidth;

        return Container(
          padding: EdgeInsets.all(isMobile ? 12 : 20),
          decoration: BoxDecoration(
            color: AppColors.whiteGreyColor,
            border: Border(
              top: BorderSide(
                  color: AppColors.cardStroke.withValues(alpha: 0.6)),
              bottom: const BorderSide(color: AppColors.cardStroke),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: isMobile ? 10 : 16,
                runSpacing: isMobile ? 10 : 16,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: _DeliveryAddressCard(
                      order: order,
                      isMobile: isMobile,
                      onCopy: (txt) => _copyToClipboard(context, txt),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _DeliveryMandoobTimelineCard(
                      order: order,
                      isMobile: isMobile,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _DeliveryOrderFinancialSummaryCard(
                      order: order,
                      isMobile: isMobile,
                    ),
                  ),
                ],
              ),

              // Cancel button footer if order is cancellable
              if (isCancellable) ...[
                const SizedBox(height: 16),
                const Divider(color: AppColors.cardStroke, height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: OutlinedButton.icon(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.redColor,
                          side: const BorderSide(color: AppColors.redColor),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 14 : 18,
                            vertical: isMobile ? 10 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: Text(
                          LocaleKeys.cancelDelivery.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 12 : 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DeliveryAddressCard extends StatelessWidget {
  final DeliveryOrderItemModel order;
  final bool isMobile;
  final void Function(String text) onCopy;

  const _DeliveryAddressCard({
    required this.order,
    this.isMobile = false,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final hasAddress = order.nationalAddress.trim().isNotEmpty;
    final addressText = hasAddress ? order.nationalAddress : '-';
    final deliveryOrderIdStr =
        order.deliveryOrderId != null ? '#${order.deliveryOrderId}' : '-';

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightOrangeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.orangeColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                LocaleKeys.nationalAddress.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.darkColor,
                ),
              ),
              const Spacer(),
              if (hasAddress)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: IconButton(
                    icon: const Icon(Icons.copy_outlined, size: 16),
                    color: AppColors.darkGreyColor,
                    tooltip: LocaleKeys.copyTooltip.tr(),
                    onPressed: () => onCopy(order.nationalAddress),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            addressText,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.darkColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.veryLightGreyColor, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.deliveryOrderId.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.darkGreyColor,
                ),
              ),
              Text(
                deliveryOrderIdStr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.seaBlueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeliveryMandoobTimelineCard extends StatelessWidget {
  final DeliveryOrderItemModel order;
  final bool isMobile;

  const _DeliveryMandoobTimelineCard({
    required this.order,
    this.isMobile = false,
  });

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('yyyy-MM-dd HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.blueColor100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.two_wheeler_outlined,
                  color: AppColors.seaBlueColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                LocaleKeys.mandoobName.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.darkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 16, color: AppColors.darkGreyColor),
              const SizedBox(width: 8),
              Text(
                (order.mandoobName != null && order.mandoobName!.isNotEmpty)
                    ? order.mandoobName!
                    : '-',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkColor,
                ),
              ),
            ],
          ),
          if (order.mandoobPhone != null && order.mandoobPhone!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.phone_outlined,
                    size: 16, color: AppColors.darkGreyColor),
                const SizedBox(width: 8),
                Text(
                  order.mandoobPhone!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGreyColor,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          const Divider(color: AppColors.veryLightGreyColor, height: 1),
          const SizedBox(height: 10),
          _TimelineItem(
            label: LocaleKeys.mandoobAcceptDate.tr(),
            value: _formatDate(order.mandoobAcceptDate),
          ),
          const SizedBox(height: 6),
          _TimelineItem(
            label: LocaleKeys.mandoobReceiveDate.tr(),
            value: _formatDate(order.mandoobReceiveDate),
          ),
          const SizedBox(height: 6),
          _TimelineItem(
            label: LocaleKeys.mandoobDeliverDate.tr(),
            value: _formatDate(order.mandoobDeliverDate),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String label;
  final String value;

  const _TimelineItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.darkGreyColor,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.darkColor,
          ),
        ),
      ],
    );
  }
}

class _DeliveryOrderFinancialSummaryCard extends StatelessWidget {
  final DeliveryOrderItemModel order;
  final bool isMobile;

  const _DeliveryOrderFinancialSummaryCard({
    required this.order,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightGreenColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.greenColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                LocaleKeys.orderDetailsHeader.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.darkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.user.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.darkGreyColor,
                ),
              ),
              Text(
                order.customerName.isNotEmpty ? order.customerName : '-',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkColor,
                ),
              ),
            ],
          ),
          if (order.customerPhone.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.customerPhone.tr(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGreyColor,
                  ),
                ),
                Text(
                  order.customerPhone,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGreyColor,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.provider.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.darkGreyColor,
                ),
              ),
              Text(
                order.providerName.isNotEmpty ? order.providerName : '-',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.darkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.veryLightGreyColor, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.deliveryFee.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.darkGreyColor,
                ),
              ),
              Text(
                '${order.deliveryFee.toStringAsFixed(2)} SAR',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.total.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkColor,
                ),
              ),
              Text(
                '${order.totalPrice.toStringAsFixed(2)} SAR',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.orangeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
