import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

class VersionWidget extends StatelessWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        TextInAppWidget(
          text: LocaleKeys.Version,
          textSize: 12,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.darkColor,
        ),
        TextInAppWidget(
          text: ValuesOfAllApp.version,
          textSize: 12,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.darkColor,
        ),
      ],
    );
  }
}
