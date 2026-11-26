import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/networking/api_link.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';

class OrderInvoiceBreakdownCard extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderInvoiceBreakdownCard({
    super.key,
    required this.orderDetails,
  });

  String _getPaymentMethodTitle(int? method) {
    return switch (method) {
      PaymentMethodType.cash => LocaleKeys.cashPayment.tr(),
      PaymentMethodType.mada => LocaleKeys.madaCard.tr(),
      PaymentMethodType.visa => LocaleKeys.visaMastercard.tr(),
      PaymentMethodType.applePay => 'Apple Pay',
      PaymentMethodType.wallet => LocaleKeys.eWallet.tr(),
      PaymentMethodType.points => LocaleKeys.rewardPoints.tr(),
      _ => LocaleKeys.electronicPayment.tr(),
    };
  }

  IconData _getPaymentMethodIcon(int? method) {
    return switch (method) {
      PaymentMethodType.cash => Icons.payments_outlined,
      PaymentMethodType.mada => Icons.credit_card_outlined,
      PaymentMethodType.visa => Icons.credit_card_rounded,
      PaymentMethodType.applePay => Icons.apple_outlined,
      PaymentMethodType.wallet => Icons.account_balance_wallet_outlined,
      PaymentMethodType.points => Icons.stars_rounded,
      _ => Icons.credit_card_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = (orderDetails?.totalprice ?? 0).toDouble();
    final double taxAmount = (orderDetails?.taxamount ?? 0).toDouble();
    final double couponDiscount =
        (orderDetails?.applyedcouponamount ?? 0).toDouble();
    final double pointsDiscount =
        (orderDetails?.applyedpointsamount ?? 0).toDouble();
    final double subtotal =
        (totalPrice - taxAmount + couponDiscount + pointsDiscount)
            .clamp(0, double.infinity);

    final String formattedSubtotal = subtotal.truncateToDouble() == subtotal
        ? subtotal.toInt().toString()
        : subtotal.toStringAsFixed(2);
    final String formattedTax = taxAmount.truncateToDouble() == taxAmount
        ? taxAmount.toInt().toString()
        : taxAmount.toStringAsFixed(2);
    final String formattedTotal = totalPrice.truncateToDouble() == totalPrice
        ? totalPrice.toInt().toString()
        : totalPrice.toStringAsFixed(2);
    final int? paymentMethod = orderDetails?.paymentmethod;

    final bool hasDiscounts = (couponDiscount > 0) ||
        (pointsDiscount > 0) ||
        (orderDetails?.applyedcouponid != null &&
            orderDetails!.applyedcouponid! > 0);

    return Container(
      padding: const EdgeInsets.all(18),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.orangeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.orangeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const TextInAppWidget(
                    text: LocaleKeys.invoiceSummary,
                    textSize: 15,
                    textColor: AppColors.darkColor,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.orangeColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getPaymentMethodIcon(paymentMethod),
                      size: 14,
                      color: AppColors.orangeColor,
                    ),
                    const SizedBox(width: 5),
                    TextInAppWidget(
                      text: _getPaymentMethodTitle(paymentMethod),
                      textSize: 11,
                      textColor: AppColors.orangeColor,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Applied Savings Banner (Coupon / Loyalty Points)
          if (hasDiscounts) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.greenColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.greenColor.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (couponDiscount > 0 ||
                      (orderDetails?.applyedcouponid != null &&
                          orderDetails!.applyedcouponid! > 0)) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.confirmation_number_outlined,
                          size: 15,
                          color: AppColors.greenColor,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextInAppWidget(
                            text:
                                '${LocaleKeys.appliedCouponDiscount.tr()}${orderDetails?.couponcode != null ? ' (${orderDetails!.couponcode})' : orderDetails?.applyedcouponid != null ? ' (#${orderDetails!.applyedcouponid})' : ''}',
                            textSize: 12,
                            textColor: AppColors.greenColor,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                          ),
                        ),
                        TextInAppWidget(
                          text:
                              '-${couponDiscount.toStringAsFixed(2)} ${LocaleKeys.sarCurrency.tr()}',
                          textSize: 12,
                          textColor: AppColors.greenColor,
                          fontWeightIndex: FontSelectionData.boldFontFamily,
                        ),
                      ],
                    ),
                  ],
                  if (pointsDiscount > 0) ...[
                    if (couponDiscount > 0) const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          size: 16,
                          color: AppColors.greenColor,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextInAppWidget(
                            text: LocaleKeys.loyaltyPointsDiscount.tr(),
                            textSize: 12,
                            textColor: AppColors.greenColor,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                          ),
                        ),
                        TextInAppWidget(
                          text:
                              '-${pointsDiscount.toStringAsFixed(2)} ${LocaleKeys.sarCurrency.tr()}',
                          textSize: 12,
                          textColor: AppColors.greenColor,
                          fontWeightIndex: FontSelectionData.boldFontFamily,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],

          InvoiceBreakdownRow(
            label: LocaleKeys.servicesSubtotal.tr(),
            amount: '$formattedSubtotal ${LocaleKeys.sarCurrency.tr()}',
          ),
          const SizedBox(height: 10),
          InvoiceBreakdownRow(
            label: LocaleKeys.vatAmount.tr(),
            amount: '$formattedTax ${LocaleKeys.sarCurrency.tr()}',
          ),
          const SizedBox(height: 14),
          const Divider(
            color: AppColors.veryLightGreyColor,
            height: 1,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.scaffoldColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.orangeColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextInAppWidget(
                  text: LocaleKeys.finalTotalAmount.tr(),
                  textSize: 14,
                  textColor: AppColors.darkColor,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                ),
                Row(
                  children: [
                    TextInAppWidget(
                      text: formattedTotal,
                      textSize: 18,
                      textColor: AppColors.orangeColor,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                    ),
                    const SizedBox(width: 4),
                    TextInAppWidget(
                      text: LocaleKeys.sarCurrency.tr(),
                      textSize: 13,
                      textColor: AppColors.orangeColor,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceBreakdownRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isBold;

  const InvoiceBreakdownRow({
    super.key,
    required this.label,
    required this.amount,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextInAppWidget(
          text: label,
          textSize: 13,
          textColor: AppColors.darkGreyColor,
          fontWeightIndex: isBold
              ? FontSelectionData.boldFontFamily
              : FontSelectionData.regularFontFamily,
        ),
        TextInAppWidget(
          text: amount,
          textSize: 13,
          textColor: AppColors.darkColor,
          fontWeightIndex: isBold
              ? FontSelectionData.boldFontFamily
              : FontSelectionData.mediumFontFamily,
        ),
      ],
    );
  }
}
