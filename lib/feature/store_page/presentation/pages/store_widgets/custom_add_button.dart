import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_container.dart';
import '../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../core/helpers/themes/fonts.dart';
import '../../../../../core/helpers/themes/text_styles.dart';

class CustomAddButton extends StatelessWidget {
  const CustomAddButton(
      {super.key, required this.text, required this.onTap, this.width});

  final String text;
  final double? width;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: onTap,
      containerColor: AppColors.orangeColor,
      containerWidth: width ?? 162,
      containerHeight: 42,
      borderRadius: BorderRadius.circular(25),
      typeWidget: Row(
        children: [
          const Icon(
            Icons.add,
            color: AppColors.whiteColor,
            size: 28,
          ),
          TextInAppWidget(
            text: text,
            textSize: 16,
            textColor: AppColors.whiteColor,
            fontWeightIndex: FontSelectionData.boldFontFamily,
          ),
        ],
      ),
    );
  }
}
