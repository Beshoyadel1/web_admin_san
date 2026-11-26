import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class TypeCar extends StatelessWidget {
  const TypeCar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      children: [
        Column(
          children: [
            TextInAppWidget(
              text: LocaleKeys.modelAriya,
              textSize: 14,
              textColor: AppColors.darkColor,
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        TextInAppWidget(
          text: LocaleKeys.brandNissan,
          textSize: 14,
          textColor: AppColors.darkColor,
        ),
      ],
    );
  }
}
