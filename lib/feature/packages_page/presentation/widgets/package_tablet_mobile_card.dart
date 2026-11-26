import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/package_card_action_button.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/package_pricing_badge.dart';

class PackageTabletMobileCard extends StatelessWidget {
  const PackageTabletMobileCard({
    super.key,
    this.packageId,
    this.packageName,
    this.packageLatinName,
    this.monthlyPrice,
    this.annualPrice,
    this.description,
    this.latinDescription,
    this.onTapDetails,
    this.onTapEdit,
    this.onTapDelete,
  });

  final String? packageId;
  final String? packageName;
  final String? packageLatinName;
  final double? monthlyPrice;
  final double? annualPrice;
  final String? description;
  final String? latinDescription;
  final VoidCallback? onTapDetails;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDelete;

  String _formatPrice(double? price) {
    if (price == null) return '0';
    return price.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final hasArabicDesc = description != null && description!.trim().isNotEmpty;
    final hasLatinDesc =
        latinDescription != null && latinDescription!.trim().isNotEmpty;

    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      containerWidth: double.infinity,
      typeWidget: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row: Names + Identifier Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInAppWidget(
                        text: packageName ?? '---',
                        textSize: 15,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.darkColor,
                        maxLines: 1,
                      ),
                      if (packageLatinName != null &&
                          packageLatinName!.trim().isNotEmpty) ...[
                        const SizedBox(height: 3),
                        TextInAppWidget(
                          text: packageLatinName!,
                          textSize: 12,
                          fontWeightIndex: FontSelectionData.regularFontFamily,
                          textColor: AppColors.greyColor,
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.orangeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.orangeColor.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: TextInAppWidget(
                    text:
                        '${LocaleKeys.identifier.tr()}: #${packageId ?? '---'}',
                    textSize: 11,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                    textColor: AppColors.orangeColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Pricing Badges Row
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                PackagePricingBadge(
                  title: LocaleKeys.monthlyPrice,
                  price: _formatPrice(monthlyPrice),
                  icon: Icons.calendar_month_outlined,
                  color: AppColors.seaBlueColor,
                ),
                PackagePricingBadge(
                  title: LocaleKeys.annualPrice,
                  price: _formatPrice(annualPrice),
                  icon: Icons.event_repeat_outlined,
                  color: AppColors.orangeColor,
                ),
              ],
            ),

            // Descriptions Section
            if (hasArabicDesc || hasLatinDesc) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.lightGreyColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasArabicDesc)
                      Tooltip(
                        message: description!,
                        child: TextInAppWidget(
                          text: description!,
                          textSize: 12,
                          fontWeightIndex: FontSelectionData.regularFontFamily,
                          textColor: AppColors.darkGreyColor,
                          maxLines: 2,
                        ),
                      ),
                    if (hasArabicDesc && hasLatinDesc)
                      const SizedBox(height: 4),
                    if (hasLatinDesc)
                      Tooltip(
                        message: latinDescription!,
                        child: TextInAppWidget(
                          text: latinDescription!,
                          textSize: 11,
                          fontWeightIndex: FontSelectionData.regularFontFamily,
                          textColor: AppColors.greyColor,
                          maxLines: 2,
                        ),
                      ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),

            // Footer Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PackageCardActionButton(
                  text: LocaleKeys.details,
                  icon: Icons.visibility_outlined,
                  color: AppColors.seaBlueColor,
                  onTap: onTapDetails,
                  width: 85,
                ),
                const SizedBox(width: 8),
                PackageCardActionButton(
                  text: LocaleKeys.edit,
                  icon: Icons.edit_outlined,
                  color: AppColors.orangeColor,
                  onTap: onTapEdit,
                  width: 80,
                ),
                const SizedBox(width: 8),
                PackageCardActionButton(
                  text: LocaleKeys.delete,
                  icon: Icons.delete_outline,
                  color: AppColors.redColor,
                  onTap: onTapDelete,
                  width: 80,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
