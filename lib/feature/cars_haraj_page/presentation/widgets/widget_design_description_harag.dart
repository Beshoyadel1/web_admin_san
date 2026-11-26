import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_all_harage_model/harage_data.dart';

class WidgetDesignDescriptionHarag extends StatelessWidget {
  const WidgetDesignDescriptionHarag({
    super.key,
    required this.harage,
  });

  final HarageData harage;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      containerWidth: double.infinity,
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextInAppWidget(
              text: LocaleKeys.description,
              textSize: 16,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor: AppColors.darkColor,
            ),
            const SizedBox(height: 15),
            TextInAppWidget(
              text: harage.description?.isNotEmpty == true
                  ? harage.description!
                  : LocaleKeys.empty,
              textSize: 14,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.darkColor,
            ),
          ],
        ),
      ),
    );
  }
}
