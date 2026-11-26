import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';
import 'select_date_widget.dart';

class SelectModelYears extends StatelessWidget {
  const SelectModelYears({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: LocaleKeys.selectModelYearsKey,
          textSize: 15.7,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.darkGreyColor,
        ),
        SizedBox(
          height: 12,
        ),
        SelectDateWidget()
      ],
    );
  }
}
