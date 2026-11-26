import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class PackageColumnData extends StatelessWidget {
  const PackageColumnData({
    super.key,
    required this.title,
    required this.value,
    this.width = 120,
    this.isDescription = false,
  });

  final String title;
  final String value;
  final double width;
  final bool isDescription;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.trim().isEmpty ? '---' : value;

    final childWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextInAppWidget(
          text: title.tr(),
          textSize: 11,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.greyColor,
          maxLines: 1,
        ),
        const SizedBox(height: 6),
        TextInAppWidget(
          text: displayValue,
          textSize: 13,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.darkColor,
          maxLines: isDescription ? 2 : 1,
        ),
      ],
    );

    return SizedBox(
      width: width,
      child: isDescription
          ? Tooltip(
              message: displayValue,
              waitDuration: const Duration(milliseconds: 300),
              child: childWidget,
            )
          : childWidget,
    );
  }
}
