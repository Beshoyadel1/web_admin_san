import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CouponAssignedProvidersCard extends StatelessWidget {
  final List<int> providerIds;
  final Map<int, CreateUserRequest> providerUsers;

  const CouponAssignedProvidersCard({
    super.key,
    required this.providerIds,
    required this.providerUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.darkColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 20,
                    color: AppColors.orangeColor,
                  ),
                  SizedBox(width: 8),
                  TextInAppWidget(
                    text: LocaleKeys.serviceProviders,
                    textSize: 15,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                    textColor: AppColors.darkColor,
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextInAppWidget(
                  text: providerIds.isEmpty
                      ? LocaleKeys.all.tr()
                      : '${providerIds.length} ${LocaleKeys.provider.tr()}',
                  textSize: 12,
                  textColor: AppColors.orangeColor,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (providerIds.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.greenColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.greenColor.withValues(alpha: 0.2),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.all_inclusive,
                    size: 24,
                    color: AppColors.greenColor,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInAppWidget(
                          text: LocaleKeys.allProvidersGeneralCoupon,
                          textSize: 13,
                          fontWeightIndex: FontSelectionData.boldFontFamily,
                          textColor: AppColors.darkColor,
                        ),
                        SizedBox(height: 2),
                        TextInAppWidget(
                          text: LocaleKeys.couponValidForAllProviders,
                          textSize: 12,
                          textColor: AppColors.darkGreyColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: providerIds.map((id) {
                final user = providerUsers[id];
                final name = user?.providerDetails?.name ??
                    user?.username ??
                    '${LocaleKeys.provider.tr()} #$id';

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.darkColor.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor:
                            AppColors.orangeColor.withValues(alpha: 0.15),
                        child: const Icon(
                          Icons.business,
                          size: 16,
                          color: AppColors.orangeColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextInAppWidget(
                            text: name,
                            textSize: 13,
                            fontWeightIndex: FontSelectionData.mediumFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                          TextInAppWidget(
                            text: '#$id',
                            textSize: 11,
                            textColor: AppColors.greyColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
