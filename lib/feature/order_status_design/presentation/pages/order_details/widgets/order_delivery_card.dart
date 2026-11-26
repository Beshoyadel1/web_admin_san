import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/services/web_interop/web_interop.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';

class OrderDeliveryCard extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderDeliveryCard({
    super.key,
    required this.orderDetails,
  });

  void _openWhatsApp(String? phone) {
    if (phone == null || phone.trim().isEmpty) return;
    var clean = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.startsWith('05')) {
      clean = '966${clean.substring(1)}';
    } else if (clean.startsWith('5') && clean.length == 9) {
      clean = '966$clean';
    }
    openExternalUrl('https://wa.me/$clean');
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '--:--';
    final dt = DateTime.tryParse(raw)?.toLocal();
    if (dt == null) return raw;
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final delivery = orderDetails?.deliveryOrder;
    if (delivery == null && !(orderDetails?.isDeliveryOrder ?? false)) {
      return const SizedBox.shrink();
    }

    final courierName = delivery?.mandoobName;
    final courierPhone = delivery?.mandoobPhone;
    final deliveryStatus = delivery?.deliveryOrderStatus;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.veryLightGreyColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Delivery Status Badge
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.blueColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  size: 18,
                  color: AppColors.blueColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextInAppWidget(
                  text: LocaleKeys.deliveryAndShippingInfo.tr(),
                  textSize: 15,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                  textColor: AppColors.darkColor,
                ),
              ),
              if (deliveryStatus != null && deliveryStatus.trim().isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.blueColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.blueColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: TextInAppWidget(
                    text: deliveryStatus,
                    textSize: 11,
                    textColor: AppColors.blueColor,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Courier Details
          if (courierName != null && courierName.trim().isNotEmpty) ...[
            OrderDeliveryInfoRow(
              icon: Icons.person_outline_rounded,
              label: LocaleKeys.shippingRepName.tr(),
              value: courierName,
            ),
            const SizedBox(height: 10),
          ],

          if (courierPhone != null && courierPhone.trim().isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 16,
                      color: AppColors.darkGreyColor,
                    ),
                    const SizedBox(width: 6),
                    TextInAppWidget(
                      text: LocaleKeys.shippingRepPhone.tr(),
                      textSize: 12,
                      textColor: AppColors.darkGreyColor,
                      fontWeightIndex: FontSelectionData.regularFontFamily,
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextInAppWidget(
                      text: courierPhone,
                      textSize: 12,
                      textColor: AppColors.darkColor,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                    ),
                    const SizedBox(width: 6),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () => _openWhatsApp(courierPhone),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.greenColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 14,
                            color: AppColors.greenColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],

          // Dates
          if (delivery?.mandoobAcceptOrderDate != null &&
              delivery!.mandoobAcceptOrderDate!.trim().isNotEmpty) ...[
            OrderDeliveryInfoRow(
              icon: Icons.check_circle_outline_rounded,
              label: LocaleKeys.repAcceptanceDate.tr(),
              value: _formatDate(delivery.mandoobAcceptOrderDate),
            ),
            const SizedBox(height: 10),
          ],

          if (delivery?.mandoobReceiveOrderDate != null &&
              delivery!.mandoobReceiveOrderDate!.trim().isNotEmpty) ...[
            OrderDeliveryInfoRow(
              icon: Icons.arrow_circle_up_outlined,
              label: LocaleKeys.repPickupDate.tr(),
              value: _formatDate(delivery.mandoobReceiveOrderDate),
            ),
            const SizedBox(height: 10),
          ],

          if (delivery?.mandoobDeliverOrderDate != null &&
              delivery!.mandoobDeliverOrderDate!.trim().isNotEmpty) ...[
            OrderDeliveryInfoRow(
              icon: Icons.task_alt_rounded,
              label: LocaleKeys.orderDeliveryDate.tr(),
              value: _formatDate(delivery.mandoobDeliverOrderDate),
            ),
            const SizedBox(height: 10),
          ],

          // Delivery Fee
          if (delivery?.deliveryFee != null) ...[
            OrderDeliveryInfoRow(
              icon: Icons.payments_outlined,
              label: LocaleKeys.deliveryFee.tr(),
              value: '${delivery!.deliveryFee!.toStringAsFixed(2)} SAR',
            ),
            const SizedBox(height: 10),
          ],

          // Delivery Order ID
          if (delivery?.deliveryOrderId != null) ...[
            OrderDeliveryInfoRow(
              icon: Icons.tag_rounded,
              label: LocaleKeys.deliveryOrderId.tr(),
              value: '#${delivery!.deliveryOrderId}',
            ),
            const SizedBox(height: 10),
          ],

          // National Address
          if (orderDetails?.nationaladdress != null &&
              orderDetails!.nationaladdress!.trim().isNotEmpty) ...[
            OrderDeliveryInfoRow(
              icon: Icons.location_on_outlined,
              label: LocaleKeys.nationalAddress.tr(),
              value: orderDetails!.nationaladdress!,
            ),
          ],
        ],
      ),
    );
  }
}

class OrderDeliveryInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const OrderDeliveryInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.darkGreyColor),
            const SizedBox(width: 6),
            TextInAppWidget(
              text: label,
              textSize: 12,
              textColor: AppColors.darkGreyColor,
              fontWeightIndex: FontSelectionData.regularFontFamily,
            ),
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextInAppWidget(
              text: value,
              textSize: 12,
              textColor: AppColors.darkColor,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}
