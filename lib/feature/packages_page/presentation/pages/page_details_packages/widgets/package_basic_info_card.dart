import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/packages_page/data/model/get_packages_model/get_packages_model.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/page_details_packages/widgets/package_details_field_tile.dart';

class PackageBasicInfoCard extends StatelessWidget {
  const PackageBasicInfoCard({
    super.key,
    required this.package,
  });

  final PackageModel package;

  String _formatPrice(double? price) {
    if (price == null) return '0';
    return price.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '');
  }

  @override
  Widget build(BuildContext context) {
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
                    color: AppColors.orangeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.monetization_on_outlined,
                    size: 20,
                    color: AppColors.orangeColor,
                  ),
                ),
                const SizedBox(width: 12),
                TextInAppWidget(
                  text: LocaleKeys.packageName.tr(),
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

            // Identifier (المعرف)
            PackageDetailsFieldTile(
              title: LocaleKeys.identifier,
              value:
                  package.packageid != null ? '#${package.packageid}' : '---',
              icon: Icons.tag,
            ),

            // Arabic Name
            PackageDetailsFieldTile(
              title: LocaleKeys.packageName,
              value: package.packagename ?? '---',
              icon: Icons.badge_outlined,
            ),

            // English Name
            PackageDetailsFieldTile(
              title: LocaleKeys.packageLatinName,
              value: package.packagelatinname ?? '---',
              icon: Icons.language,
            ),

            // Monthly Price
            PackageDetailsFieldTile(
              title: LocaleKeys.monthlyPrice,
              value: _formatPrice(package.monthprice),
              icon: Icons.calendar_month_outlined,
            ),

            // Annual Price
            PackageDetailsFieldTile(
              title: LocaleKeys.annualPrice,
              value: _formatPrice(package.annualprice),
              icon: Icons.event_repeat_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
