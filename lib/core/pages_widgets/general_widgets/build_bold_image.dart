import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/colors.dart';

Widget buildBoldImage({
  required Widget image,
  required bool isSelected,
}) {
  return ColorFiltered(
    colorFilter: isSelected
        ? const ColorFilter.mode(
      AppColors.whiteColor,
      BlendMode.srcIn,
    )
        : const ColorFilter.mode(
      AppColors.orangeColor,
      BlendMode.srcIn,
    ),
    child: image,
  );
}