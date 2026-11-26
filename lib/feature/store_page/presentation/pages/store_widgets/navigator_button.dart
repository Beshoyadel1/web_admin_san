import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../core/widgets/custom_container.dart';
import '../../../../../core/helpers/colors/app_colors.dart';

class NavigatorButton extends StatelessWidget {
  const NavigatorButton({
    super.key,
    this.onTapOrangeButton,
    this.onTapGrayButton,
    this.textOrangeButton,
    this.textGrayButton,
  });

  final VoidCallback? onTapOrangeButton;
  final VoidCallback? onTapGrayButton;
  final String? textOrangeButton;
  final String? textGrayButton;

  @override
  Widget build(BuildContext context) {
    final bool showOrangeButton =
        onTapOrangeButton != null || textOrangeButton != null;

    return CustomContainer(
      containerWidth: double.infinity,
      border: const Border(
        bottom: BorderSide(color: AppColors.lightGreyColor),
        left: BorderSide(color: AppColors.lightGreyColor),
        right: BorderSide(color: AppColors.lightGreyColor),
      ),
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.lightGreyColor.withAlpha(60),
          blurRadius: 2,
          spreadRadius: 1,
          offset: const Offset(0, -3),
        ),
      ],
      isSelected: false,
      onTap: () {},
      typeWidget: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 10,
        runSpacing: 10,
        children: [
          if (showOrangeButton)
            CustomContainer(
              isSelected: false,
              onTap: onTapOrangeButton ?? () {},
              text: textOrangeButton ?? LocaleKeys.Next,
              containerColor: AppColors.orangeColor,
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
            ),
          CustomContainer(
            isSelected: false,
            onTap: onTapGrayButton ?? () {},
            text: textGrayButton ?? LocaleKeys.backKey,
            containerColor: AppColors.darkGreyColor,
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
          ),
        ],
      ),
    );
  }
}
