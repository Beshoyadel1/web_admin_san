import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';

class CustomViewAllAdminsListWidget extends StatelessWidget {
  const CustomViewAllAdminsListWidget({
    super.key,
    this.id,
    this.spacing,
    this.nameAdmin,
    this.phone,
    this.email,
    this.image,
    this.joinDate,
    this.onTapDetails,
  });

  final String? id;
  final String? nameAdmin;
  final String? phone;
  final String? email;
  final String? joinDate;

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
              title: AppLanguageKeys.identity,
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

                // IMAGE
                image != null
                    ? CircleAvatar(
                  radius: 20,
                  backgroundImage: MemoryImage(
                    image!,
                  ),
                )
                    : const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),

                // NAME
                SizedBox(
                  width: 180,
                  child: TextInAppWidget(
                    text: nameAdmin ?? '###',
                    textSize: 15,
                    fontWeightIndex:
                    FontSelectionData
                        .mediumFontFamily,
                    textColor:
                    AppColors.blackColor,
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
              title: AppLanguageKeys.phoneNumber,
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
              title: AppLanguageKeys.email,
              subTitle: email ?? '-',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =================================================
          // JOIN DATE
          // =================================================

          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.joiningDate,
              subTitle: joinDate ?? '-',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
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
                    text: AppLanguageKeys.details,
                    textSize: 12,
                    fontWeightIndex:
                    FontSelectionData
                        .mediumFontFamily,
                    textColor:
                    AppColors.orangeColor,
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