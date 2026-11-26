import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/advertisements_page/presentation/widgets/container_edit_delete_widget.dart';

import '../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';

class DesignContainerAdvertisementsUploadedWidget extends StatelessWidget {
  final void Function()? onPressedEdit, onPressedDelete;
  final Uint8List? loadImage;

  final DateTime? startDate;
  final DateTime? endDate;

  const DesignContainerAdvertisementsUploadedWidget({
    super.key,
    this.onPressedDelete,
    this.onPressedEdit,
    this.loadImage,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10,
            children: [
              ContainerEditDeleteWidget(
                isDelete: true,
                onPressed: onPressedDelete,
              ),
              ContainerEditDeleteWidget(
                onPressed: onPressedEdit,
              ),
            ],
          ),
          SizedBox(
            height: 140,
            width: double.infinity,
            child: loadImage != null
                ? Image.memory(
                    loadImage!,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    AppImageKeys.testBanner,
                    fit: BoxFit.cover,
                  ),
          ),
          if (startDate != null || endDate != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextInAppWidget(
                  text: LocaleKeys.durationFromTo,
                  textSize: 13,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                  textColor: AppColors.blackColor,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    buildDateView(
                      title: LocaleKeys.from,
                      date: startDate,
                    ),
                    const SizedBox(width: 10),
                    buildDateView(
                      title: LocaleKeys.to,
                      date: endDate,
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

Widget buildDateView({
  required String title,
  required DateTime? date,
}) {
  return Expanded(
    child: Container(
      height: 40,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.greyColor,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 14,
            color: AppColors.greyColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextInAppWidget(
              text: "${date?.day.toString().padLeft(2, '0') ?? '--'}/"
                  "${date?.month.toString().padLeft(2, '0') ?? '--'}/"
                  "${date?.year ?? '----'}",
              textSize: 13,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.greyColor,
            ),
          ),
        ],
      ),
    ),
  );
}
