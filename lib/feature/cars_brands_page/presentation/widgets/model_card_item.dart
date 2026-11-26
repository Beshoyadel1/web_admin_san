import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/colors/app_colors.dart';
import '../../../../core/helpers/themes/fonts.dart';
import '../../../../core/helpers/themes/text_styles.dart';
import '../../data/Models/car_model.dart';

class ModelCardItem extends StatelessWidget {
  final CarsBrandModel carModel;
  final VoidCallback onEdit;

  const ModelCardItem({
    super.key,
    required this.carModel,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final imageBytes = carModel.imageBytes;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.cardStroke,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.scaffoldColor,
              border: Border.all(
                color: AppColors.cardStroke,
                width: 1,
              ),
            ),
            child: ClipOval(
              child: imageBytes != null && imageBytes.isNotEmpty
                  ? Image.memory(
                      imageBytes,
                      width: 38,
                      height: 38,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.directions_car_filled,
                        size: 20,
                        color: AppColors.darkGreyColor,
                      ),
                    )
                  : const Icon(
                      Icons.directions_car_filled,
                      size: 20,
                      color: AppColors.darkGreyColor,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextInAppWidget(
              text: carModel.modelName.isNotEmpty ? carModel.modelName : '---',
              textSize: 14,
              textColor: AppColors.darkColor,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              isEllipsisTextOverflow: true,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.greyColor200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '#${carModel.modelId}',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.darkGreyColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: AppColors.darkGreyColor,
            ),
            tooltip: LocaleKeys.editModelKey.tr(),
            onPressed: onEdit,
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}
