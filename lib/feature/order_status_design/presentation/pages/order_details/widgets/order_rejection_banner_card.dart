import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/networking/api_link.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';

class OrderRejectionBannerCard extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderRejectionBannerCard({
    super.key,
    required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    final status = orderDetails?.status;
    final isRejectedOrCancelled = status == OrderStatus.rejectedByCompany ||
        status == OrderStatus.rejectedByProvider ||
        status == OrderStatus.cancelledByUser;

    final reason = orderDetails?.rejectreason;

    if (!isRejectedOrCancelled && (reason == null || reason.trim().isEmpty)) {
      return const SizedBox.shrink();
    }

    final reasonText = (reason != null && reason.trim().isNotEmpty)
        ? reason
        : (status == OrderStatus.cancelledByUser
            ? LocaleKeys.orderCancelledByCustomer.tr()
            : (status == OrderStatus.rejectedByCompany
                ? LocaleKeys.orderRejectedByCompany.tr()
                : LocaleKeys.orderRejectedByProvider.tr()));

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.redColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.redColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 22,
            color: AppColors.redColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInAppWidget(
                  text: LocaleKeys.cancellationOrRejectionReason.tr(),
                  textSize: 13,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                  textColor: AppColors.redColor,
                ),
                const SizedBox(height: 4),
                TextInAppWidget(
                  text: reasonText,
                  textSize: 12,
                  textColor: AppColors.darkColor,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
