import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class AppSearchDropdown<T> extends StatelessWidget {
  const AppSearchDropdown({
    super.key,
    required this.onChanged,
    this.initialSelection,
    this.enableOrDisableDropDown = true,
    required this.aboveText,
    this.enableSearch = true,
    required this.dropdownMenuEntries,
    this.controller,
    this.hintText,
    this.height,
    this.width,
    this.borderRadius,
  });

  final ValueChanged<T?> onChanged;
  final bool enableOrDisableDropDown;
  final bool enableSearch;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final TextEditingController? controller;
  final String? hintText;
  final String aboveText;
  final double? height;
  final double? width;
  final double? borderRadius;
  final T? initialSelection;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: TextInAppWidget(
            text: aboveText,
            textColor: AppColors.darkColor,
            textSize: 14,
            fontWeightIndex: FontSelectionData.semiBoldFontFamily,
            isEllipsisTextOverflow: true,
          ),
        ),
        SizedBox(
          height: height ?? 35,
          width: width ?? 250,
          child: DropdownMenu<T>(
            enabled: enableOrDisableDropDown,
            expandedInsets: EdgeInsets.zero,
            initialSelection: initialSelection,
            controller: controller,
            menuHeight: size.height * 0.35,
            trailingIcon: const Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: AppColors.darkGreyColor,
            ),
            selectedTrailingIcon: const Icon(
              Icons.arrow_drop_up,
              size: 20,
              color: AppColors.darkGreyColor,
            ),
            inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              fillColor: AppColors.whiteColor,
              filled: true,
              hintStyle: const TextStyle(
                color: AppColors.darkGreyColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide: const BorderSide(color: AppColors.darkGreyColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide: const BorderSide(
                  color: AppColors.orangeColor,
                  width: 1.5,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide: const BorderSide(color: AppColors.darkGreyColor),
              ),
            ),
            hintText: hintText?.tr(),
            requestFocusOnTap: true,
            enableFilter: enableSearch,
            menuStyle: MenuStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                AppColors.whiteColor,
              ),
            ),
            onSelected: onChanged,
            dropdownMenuEntries: dropdownMenuEntries,
          ),
        ),
      ],
    );
  }
}
