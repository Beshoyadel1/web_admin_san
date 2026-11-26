import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/title_with_sub_title.dart';

class CustomAdminsPageListWidget extends StatelessWidget {
  const CustomAdminsPageListWidget({
    super.key,
    this.id,
    this.spacing,
    this.nameAdmin,
    this.phone,
    this.email,
    this.image,
    this.joinDate,
    this.isActive, // ADD
    this.onTapDetails,
  });

  final String? id;
  final String? nameAdmin;
  final String? phone;
  final String? email;
  final String? joinDate;

  final bool? isActive;

  final double? spacing;

  final Uint8List? image;

  final void Function()? onTapDetails;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: Wrap(
        spacing: spacing ?? 20,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // =================================================
          // ADMIN ID
          // =================================================

          SizedBox(
            width: 120,
            child: TitleWithSubTitle(
              title: LocaleKeys.identity,
              subTitle: id ?? '#1',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =================================================
          // ADMIN NAME + IMAGE
          // =================================================

          SizedBox(
            width: 250,
            child: Wrap(
              spacing: 5,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 5,
              children: [
                image != null
                    ? CircleAvatar(
                        radius: 20,
                        backgroundImage: MemoryImage(image!),
                      )
                    : const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.redColor,
                        child: Icon(
                          Icons.person,
                          color: AppColors.whiteColor,
                        ),
                      ),
                SizedBox(
                  width: 180,
                  child: TextInAppWidget(
                    text: nameAdmin ?? '###',
                    textSize: 15,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.blackColor,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          // =================================================
          // PHONE
          // =================================================

          SizedBox(
            width: 160,
            child: TitleWithSubTitle(
              title: LocaleKeys.phoneNumber,
              subTitle: phone ?? '-',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =================================================
          // EMAIL
          // =================================================

          SizedBox(
            width: 250,
            child: TitleWithSubTitle(
              title: LocaleKeys.Email,
              subTitle: email ?? '-',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =================================================
          // STATUS
          // =================================================

          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextInAppWidget(
                  text: LocaleKeys.status,
                  textSize: 12,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.greyColor,
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isActive == true
                        ? AppColors.greenColor.withValues(alpha: 0.1)
                        : AppColors.redColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextInAppWidget(
                    text: isActive == true
                        ? LocaleKeys.active
                        : LocaleKeys.inactive,
                    textSize: 12,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: isActive == true
                        ? AppColors.greenColor
                        : AppColors.redColor,
                  ),
                ),
              ],
            ),
          ),

          // =================================================
          // DETAILS
          // =================================================

          SizedBox(
            width: 110,
            child: InkWell(
              onTap: onTapDetails,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    color: AppColors.orangeColor,
                  ),
                ),
                child: const Center(
                  child: TextInAppWidget(
                    text: LocaleKeys.details,
                    textSize: 12,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.orangeColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
