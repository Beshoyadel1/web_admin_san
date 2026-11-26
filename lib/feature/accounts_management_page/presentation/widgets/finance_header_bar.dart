import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class FinanceHeaderBar extends StatelessWidget {
  final ProviderDetailsRequest providerDetailsRequest;
  final VoidCallback onStartSettlement;

  const FinanceHeaderBar({
    super.key,
    required this.providerDetailsRequest,
    required this.onStartSettlement,
  });

  @override
  Widget build(BuildContext context) {
    final providerId = providerDetailsRequest.id ?? 0;
    final providerName =
        providerDetailsRequest.name ?? providerDetailsRequest.latinname ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 12,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.darkColor,
                    size: 20,
                  ),
                  tooltip: LocaleKeys.back.tr(),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.orangeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextInAppWidget(
                    text: LocaleKeys.providerFinancialManagement.tr(),
                    textSize: 18,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                    textColor: AppColors.darkColor,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (providerName.isNotEmpty) ...[
                        TextInAppWidget(
                          text: providerName,
                          textSize: 13,
                          fontWeightIndex: FontSelectionData.mediumFontFamily,
                          textColor: AppColors.darkGreyColor,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.greyColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      TextInAppWidget(
                        text: '#$providerId',
                        textSize: 13,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.orangeColor,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ElevatedButton.icon(
              onPressed: onStartSettlement,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                foregroundColor: AppColors.whiteColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.handshake_outlined, size: 18),
              label: TextInAppWidget(
                text: LocaleKeys.startSettlement.tr(),
                textSize: 14,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
