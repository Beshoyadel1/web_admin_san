import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class OrderState extends StatelessWidget {
  const OrderState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TextInAppWidget(
            text: LocaleKeys.orderStatusKey,
            textSize: 12,
            textColor: AppColors.darkGreyColor),
        CustomContainer(
          containerHeight: 28,
          containerWidth: 105,
          containerColor: AppColors.orangeColor.withAlpha(50),
          isSelected: false,
          onTap: () {},
          border: const Border(),
          padding: EdgeInsets.zero,
          typeWidget: const Center(
            child: Row(
              spacing: 2,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings, color: AppColors.orangeColor, size: 14),
                TextInAppWidget(
                    text: LocaleKeys.underServiceKey,
                    textSize: 12,
                    textColor: AppColors.orangeColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
