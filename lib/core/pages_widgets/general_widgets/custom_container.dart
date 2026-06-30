import 'package:flutter/material.dart';
import '../../../core/theming/text_styles.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/fonts.dart';

class CustomContainer extends StatelessWidget {
  final String? text;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? typeWidget;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final double? containerHeight;
  final double? containerWidth;
  final Color? containerColor;
  final EdgeInsets? padding;
  final List<BoxShadow>? boxShadow;
  final Color? textColor;
  final bool isLoading;

  const CustomContainer({
    super.key,
    this.text,
    required this.isSelected,
    required this.onTap,
    this.typeWidget,
    this.borderRadius,
    this.border,
    this.containerHeight,
    this.containerWidth,
    this.containerColor,
    this.padding,
    this.boxShadow,
    this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: containerHeight,
        width: containerWidth,
        padding: padding ?? const EdgeInsetsGeometry.all(10),
        decoration: BoxDecoration(
          color: containerColor ?? AppColors.whiteColor,
          border: border ??
              Border.all(
                color: isSelected
                    ? AppColors.orangeColor
                    :AppColors.greyColor.withOpacity(0.3),
              ),
          borderRadius: borderRadius ?? BorderRadius.circular(24),
          boxShadow: boxShadow ??
              [
                BoxShadow(
                  color: AppColors.darkColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: typeWidget ??
            TextInAppWidget(
              text: text ?? "",
              textSize: 14,
              textAlign: TextAlign.center,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: textColor ?? AppColors.whiteColor,
            ),
      ),
    );
  }
}
