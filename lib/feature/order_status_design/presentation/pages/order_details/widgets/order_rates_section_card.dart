import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';

class OrderRatesSectionCard extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderRatesSectionCard({
    super.key,
    required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    final rates = orderDetails?.rates ?? [];
    final averageRate = orderDetails?.providerInfo?.averagerate;

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
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.orangeColor,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextInAppWidget(
                        text: LocaleKeys.ratingsAndReviews.tr(),
                        textSize: 16,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.darkColor,
                      ),
                    ),
                    if (averageRate != null && averageRate > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.orangeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: AppColors.orangeColor,
                            ),
                            const SizedBox(width: 3),
                            TextInAppWidget(
                              text: averageRate.toStringAsFixed(1),
                              textSize: 11,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                              textColor: AppColors.orangeColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (rates.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.orangeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextInAppWidget(
                    text: '${rates.length} ${LocaleKeys.ratingsCount.tr()}',
                    textSize: 11,
                    textColor: AppColors.orangeColor,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Rates List or Empty View
          if (rates.isEmpty)
            const OrderRatesEmptyView()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final rate = rates[index];

                String? serviceName;
                if (rate.serviceid != null &&
                    orderDetails?.services != null &&
                    orderDetails!.services!.isNotEmpty) {
                  final matchedService = orderDetails!.services!.firstWhere(
                    (s) => s.id == rate.serviceid,
                    orElse: () => Service(),
                  );
                  if (matchedService.name != null &&
                      matchedService.name!.isNotEmpty) {
                    serviceName = matchedService.name;
                  } else if (matchedService.latinname != null &&
                      matchedService.latinname!.isNotEmpty) {
                    serviceName = matchedService.latinname;
                  }
                }

                return OrderRateCardItem(
                  rate: rate,
                  serviceName: serviceName,
                );
              },
            ),
        ],
      ),
    );
  }
}

class OrderRateCardItem extends StatelessWidget {
  final RateModel rate;
  final String? serviceName;

  const OrderRateCardItem({
    super.key,
    required this.rate,
    this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    final double ratingValue = rate.rateValue ?? (rate.rate?.toDouble() ?? 5.0);
    final String displayName =
        (rate.username != null && rate.username!.trim().isNotEmpty)
            ? rate.username!
            : LocaleKeys.userDefault.tr();
    final bool hasImage = rate.userimage != null && rate.userimage!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.veryLightGreyColor.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.orangeColor.withValues(alpha: 0.15),
                backgroundImage: hasImage ? MemoryImage(rate.userimage!) : null,
                child: !hasImage
                    ? TextInAppWidget(
                        text: displayName.isNotEmpty
                            ? displayName[0].toUpperCase()
                            : 'U',
                        textSize: 13,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.orangeColor,
                      )
                    : null,
              ),
              const SizedBox(width: 10),

              // Name and Stars
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: TextInAppWidget(
                            text: displayName,
                            maxLines: 1,
                            textSize: 13,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                        ),
                        if (rate.isEdited == true) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.veryLightGreyColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextInAppWidget(
                              text: LocaleKeys.averageRating.tr(),
                              textSize: 10,
                              textColor: AppColors.darkGreyColor,
                              fontWeightIndex:
                                  FontSelectionData.regularFontFamily,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (starIdx) {
                            final isFilled = ratingValue >= (starIdx + 1);
                            return Icon(
                              isFilled
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 16,
                              color: AppColors.orangeColor,
                            );
                          }),
                        ),
                        const SizedBox(width: 6),
                        TextInAppWidget(
                          text: ratingValue.toStringAsFixed(1),
                          textSize: 12,
                          fontWeightIndex: FontSelectionData.boldFontFamily,
                          textColor: AppColors.orangeColor,
                        ),
                        if (serviceName != null && serviceName!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.blueColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color:
                                    AppColors.blueColor.withValues(alpha: 0.2),
                              ),
                            ),
                            child: TextInAppWidget(
                              text: serviceName!,
                              textSize: 10,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                              textColor: AppColors.blueColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Message
          if (rate.message != null && rate.message!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            TextInAppWidget(
              text: rate.message!,
              textSize: 12,
              textColor: AppColors.darkGreyColor,
              fontWeightIndex: FontSelectionData.regularFontFamily,
            ),
          ],
        ],
      ),
    );
  }
}

class OrderRatesEmptyView extends StatelessWidget {
  const OrderRatesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.veryLightGreyColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_border_rounded,
            size: 36,
            color: AppColors.darkGreyColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          TextInAppWidget(
            text: LocaleKeys.noRatingsForOrder.tr(),
            textSize: 13,
            textColor: AppColors.darkGreyColor,
            fontWeightIndex: FontSelectionData.regularFontFamily,
          ),
        ],
      ),
    );
  }
}
