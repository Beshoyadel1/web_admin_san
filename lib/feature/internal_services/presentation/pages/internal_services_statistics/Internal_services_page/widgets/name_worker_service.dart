import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class NameWorkerService extends StatelessWidget {
  const NameWorkerService({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Image.asset(
          AppImageKeys.profileImage,
          width: 41,
          height: 41,
          fit: BoxFit.contain,
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextInAppWidget(
                text: LocaleKeys.jobNameKey,
                textSize: 12,
                textColor: AppColors.darkGreyColor),
            TextInAppWidget(
                text: LocaleKeys.employeeNameKey,
                textSize: 14,
                textColor: AppColors.darkColor),
          ],
        ),
      ],
    );
  }
}
