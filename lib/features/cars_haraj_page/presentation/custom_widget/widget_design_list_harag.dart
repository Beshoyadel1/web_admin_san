import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../core/theming/text_styles.dart';

class WidgetDesignListHarag extends StatelessWidget {
  const WidgetDesignListHarag(
      {super.key,
        this.providerId,
        this.spacing,
        this.name,
        this.onTabDetails,
        this.nameButton,
        this.image,
        this.totalCars,
        this.lastOrderDate,
        this.joiningDate
      });

  final String? providerId,name,nameButton,totalCars,lastOrderDate,joiningDate;
  final double? spacing;
  final void Function()? onTabDetails;
  final Uint8List? image;
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

          SizedBox(
            width: 120,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.identity,
              subTitle: providerId ?? "#1",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

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
                  backgroundImage:
                  MemoryImage(image!),
                )
                    : const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                ),

                SizedBox(
                  width: 180,
                  child: TextInAppWidget(
                    text: name ?? "###",
                    textSize: 15,
                    fontWeightIndex:
                    FontSelectionData.mediumFontFamily,
                    textColor: AppColors.blackColor,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 120,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.totalCars,
              subTitle: totalCars ?? "0",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          SizedBox(
            width: 180,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.lastOrderDate,
              subTitle: lastOrderDate ?? "---",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // SizedBox(
          //   width: 180,
          //   child: TitleWithSubTitle(
          //     title: AppLanguageKeys.joiningDate,
          //     subTitle: joiningDate ?? "---",
          //     textSizeTitle: 12,
          //     titleColor: AppColors.greyColor,
          //     textSizeSubTitle: 14,
          //     subTitleColor: AppColors.darkColor,
          //   ),
          // ),

          SizedBox(
            width: 110,
            child: InkWell(
              onTap: onTabDetails,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius:
                  const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    color: AppColors.orangeColor,
                  ),
                ),
                child: Center(
                  child: TextInAppWidget(
                    text: nameButton ??
                        AppLanguageKeys.details,
                    textSize: 12,
                    fontWeightIndex:
                    FontSelectionData.mediumFontFamily,
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