import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class ServicePrice extends StatelessWidget {
  const ServicePrice({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextInAppWidget(
            text: LocaleKeys.servicePriceKey,
            textSize: 12,
            textColor: AppColors.darkGreyColor),
        TextInAppWidget(
            text: '250.00', textSize: 14, textColor: AppColors.darkColor),
      ],
    );
  }
}
