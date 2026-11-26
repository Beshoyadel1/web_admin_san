import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../core/helpers/colors/app_colors.dart';
import '../../../../core/helpers/themes/fonts.dart';
import '../../../../core/helpers/themes/text_styles.dart';

class ModelsPanelHeader extends StatelessWidget {
  final String brandName;
  final int totalCount;
  final VoidCallback onAddModel;

  const ModelsPanelHeader({
    super.key,
    required this.brandName,
    required this.totalCount,
    required this.onAddModel,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const TextInAppWidget(
                text: LocaleKeys.models,
                textSize: 17,
                textColor: AppColors.darkColor,
                fontWeightIndex: FontSelectionData.boldFontFamily,
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      brandName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.orangeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '($totalCount)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.orangeColor.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                foregroundColor: AppColors.whiteColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              onPressed: onAddModel,
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                LocaleKeys.addModelKey.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
