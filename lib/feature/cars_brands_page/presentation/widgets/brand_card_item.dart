import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/colors/app_colors.dart';
import '../../../../core/helpers/themes/fonts.dart';
import '../../../../core/helpers/themes/text_styles.dart';
import '../../data/Models/brand_model.dart';

class BrandCardItem extends StatelessWidget {
  final BrandModel brand;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const BrandCardItem({
    super.key,
    required this.brand,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final primaryName = brand.getLocalizedName(context.locale.languageCode);
    final secondaryName =
        brand.getLocalizedSubName(context.locale.languageCode);
    final imageBytes = brand.imageBytes;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.orangeColor.withValues(alpha: 0.08)
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.orangeColor : AppColors.cardStroke,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.orangeColor.withValues(alpha: 0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.scaffoldColor,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.orangeColor.withValues(alpha: 0.5)
                        : AppColors.cardStroke,
                    width: 1,
                  ),
                ),
                child: ClipOval(
                  child: imageBytes != null && imageBytes.isNotEmpty
                      ? Image.memory(
                          imageBytes,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.directions_car,
                            size: 22,
                            color: AppColors.darkGreyColor,
                          ),
                        )
                      : const Icon(
                          Icons.directions_car_outlined,
                          size: 22,
                          color: AppColors.darkGreyColor,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInAppWidget(
                      text: primaryName.isNotEmpty ? primaryName : '---',
                      textSize: 14,
                      textColor: isSelected
                          ? AppColors.orangeColor
                          : AppColors.darkColor,
                      fontWeightIndex: isSelected
                          ? FontSelectionData.boldFontFamily
                          : FontSelectionData.semiBoldFontFamily,
                      isEllipsisTextOverflow: true,
                    ),
                    if (secondaryName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      TextInAppWidget(
                        text: secondaryName,
                        textSize: 12,
                        textColor: AppColors.darkGreyColor,
                        isEllipsisTextOverflow: true,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.darkGreyColor,
                ),
                tooltip: LocaleKeys.editBrandKey.tr(),
                onPressed: onEdit,
                splashRadius: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
