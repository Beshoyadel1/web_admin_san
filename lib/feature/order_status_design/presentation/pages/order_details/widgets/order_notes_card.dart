import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';

class OrderNotesCard extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderNotesCard({
    super.key,
    required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    final notes = orderDetails?.notes?.trim();
    final hasNotes = notes != null && notes.isNotEmpty;

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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.notes_rounded,
                  color: AppColors.orangeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              TextInAppWidget(
                text: LocaleKeys.orderNotesTitle.tr(),
                textSize: 15,
                textColor: AppColors.darkColor,
                fontWeightIndex: FontSelectionData.boldFontFamily,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.scaffoldColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.veryLightGreyColor.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  hasNotes
                      ? Icons.chat_bubble_outline_rounded
                      : Icons.info_outline_rounded,
                  color: hasNotes
                      ? AppColors.orangeColor
                      : AppColors.darkGreyColor.withValues(alpha: 0.6),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextInAppWidget(
                    text: hasNotes
                        ? notes
                        : LocaleKeys.noAdditionalNotesForOrder.tr(),
                    textSize: 13,
                    textColor: hasNotes
                        ? AppColors.darkColor
                        : AppColors.darkGreyColor,
                    fontWeightIndex: hasNotes
                        ? FontSelectionData.regularFontFamily
                        : FontSelectionData.regularFontFamily,
                    maxLines: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
