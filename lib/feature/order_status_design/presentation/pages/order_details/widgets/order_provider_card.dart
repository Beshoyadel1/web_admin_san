import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/services/web_interop/web_interop.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';

class OrderProviderCard extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderProviderCard({
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

  @override
  Widget build(BuildContext context) {
    final provider = orderDetails?.providerInfo;
    final providerName = provider?.name ?? LocaleKeys.unassignedProvider.tr();
    final branchName =
        provider?.branchname ?? LocaleKeys.mainBranchDefault.tr();
    final phone = provider?.phone ?? '--';
    final rating = provider?.averagerate;

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
                      color: AppColors.greenColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.storefront_outlined,
                      color: AppColors.greenColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextInAppWidget(
                    text: LocaleKeys.provider.tr(),
                    textSize: 15,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                    textColor: AppColors.darkColor,
                  ),
                ],
              ),
              if (provider?.phone != null && provider!.phone!.isNotEmpty)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () => _openWhatsApp(provider.phone),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.orangeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.phone_outlined,
                        color: AppColors.orangeColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    AppColors.secondaryColor.withValues(alpha: 0.1),
                backgroundImage:
                    provider?.image != null && provider!.image!.isNotEmpty
                        ? MemoryImage(provider.image!)
                        : null,
                child: (provider?.image == null || provider!.image!.isEmpty)
                    ? const Icon(
                        Icons.business_outlined,
                        color: AppColors.secondaryColor,
                        size: 24,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInAppWidget(
                      text: providerName,
                      textSize: 14,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                      textColor: AppColors.darkColor,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    TextInAppWidget(
                      text: branchName,
                      textSize: 12,
                      textColor: AppColors.darkGreyColor,
                      fontWeightIndex: FontSelectionData.regularFontFamily,
                      maxLines: 1,
                    ),
                    if (phone.isNotEmpty && phone != '--') ...[
                      const SizedBox(height: 2),
                      TextInAppWidget(
                        text: phone,
                        textSize: 11,
                        textColor: AppColors.darkGreyColor,
                        fontWeightIndex: FontSelectionData.regularFontFamily,
                        maxLines: 1,
                      ),
                    ],
                  ],
                ),
              ),
              if (rating != null && rating > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.yelloContainerLoadingColor
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.yelloIconLoadingColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      TextInAppWidget(
                        text: '$rating',
                        textSize: 12,
                        textColor: AppColors.yelloTextLoadingColor,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
