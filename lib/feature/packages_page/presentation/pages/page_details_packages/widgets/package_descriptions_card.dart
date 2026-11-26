import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/packages_page/data/model/get_packages_model/get_packages_model.dart';

class PackageDescriptionsCard extends StatelessWidget {
  const PackageDescriptionsCard({
    super.key,
    required this.package,
  });

  final PackageModel package;

  @override
  Widget build(BuildContext context) {
    final arabicDesc =
        (package.packagedisc != null && package.packagedisc!.trim().isNotEmpty)
            ? package.packagedisc!
            : '---';

    final latinDesc = (package.packagelatindisc != null &&
            package.packagelatindisc!.trim().isNotEmpty)
        ? package.packagelatindisc!
        : '---';

    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      containerWidth: double.infinity,
      typeWidget: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Title Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.seaBlueColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    size: 20,
                    color: AppColors.seaBlueColor,
                  ),
                ),
                const SizedBox(width: 12),
                TextInAppWidget(
                  text: LocaleKeys.packageDescription.tr(),
                  textSize: 15,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                  textColor: AppColors.darkColor,
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(
              color: AppColors.lightGreyColor.withValues(alpha: 0.5),
              height: 1,
            ),
            const SizedBox(height: 16),

            // Arabic Description Section
            Row(
              children: [
                const Icon(
                  Icons.notes_rounded,
                  size: 14,
                  color: AppColors.greyColor,
                ),
                const SizedBox(width: 6),
                TextInAppWidget(
                  text: LocaleKeys.packageDescription.tr(),
                  textSize: 12,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.greyColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.lightGreyColor.withValues(alpha: 0.6),
                ),
              ),
              child: SelectableText(
                arabicDesc,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.darkColor,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // English Description Section
            Row(
              children: [
                const Icon(
                  Icons.translate_rounded,
                  size: 14,
                  color: AppColors.greyColor,
                ),
                const SizedBox(width: 6),
                TextInAppWidget(
                  text: LocaleKeys.packageLatinDisc.tr(),
                  textSize: 12,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.greyColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.lightGreyColor.withValues(alpha: 0.6),
                ),
              ),
              child: SelectableText(
                latinDesc,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.darkColor,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
