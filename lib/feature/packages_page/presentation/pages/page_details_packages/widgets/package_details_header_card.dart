import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/packages_page/data/model/get_packages_model/get_packages_model.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/package_card_action_button.dart';

class PackageDetailsHeaderCard extends StatelessWidget {
  const PackageDetailsHeaderCard({
    super.key,
    required this.package,
    required this.onEdit,
    required this.onDelete,
  });

  final PackageModel package;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      containerWidth: double.infinity,
      typeWidget: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            // Left: Title, Latin Name, and Identifier Badge
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.orangeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    size: 28,
                    color: AppColors.orangeColor,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextInAppWidget(
                          text: package.packagename ?? '---',
                          textSize: 18,
                          fontWeightIndex: FontSelectionData.boldFontFamily,
                          textColor: AppColors.darkColor,
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.orangeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  AppColors.orangeColor.withValues(alpha: 0.25),
                            ),
                          ),
                          child: TextInAppWidget(
                            text:
                                '${LocaleKeys.identifier.tr()}: #${package.packageid ?? '---'}',
                            textSize: 12,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.orangeColor,
                          ),
                        ),
                      ],
                    ),
                    if (package.packagelatinname != null &&
                        package.packagelatinname!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      TextInAppWidget(
                        text: package.packagelatinname!,
                        textSize: 13,
                        fontWeightIndex: FontSelectionData.regularFontFamily,
                        textColor: AppColors.greyColor,
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // Right: Actions (Edit & Delete)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PackageCardActionButton(
                  text: LocaleKeys.edit,
                  icon: Icons.edit_outlined,
                  color: AppColors.orangeColor,
                  onTap: onEdit,
                  width: 90,
                ),
                const SizedBox(width: 10),
                PackageCardActionButton(
                  text: LocaleKeys.delete,
                  icon: Icons.delete_outline,
                  color: AppColors.redColor,
                  onTap: onDelete,
                  width: 90,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
