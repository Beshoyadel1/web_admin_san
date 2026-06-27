import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../core/theming/text_styles.dart';

class WidgetDesignListDrivers extends StatelessWidget {
  const WidgetDesignListDrivers(
      {super.key,
        this.id,
        this.spacing,
        this.name,
        this.onTabDetails,
        this.nameButton,
        this.imageUser,
        this.email,
        this.phone,
        this.plateNo,
        this.nameBrandModel,
        this.imageBrand
      });

  final String? id,name,nameButton,phone,email,nameBrandModel,plateNo;
  final double? spacing;
  final void Function()? onTabDetails;
  final Uint8List? imageUser,imageBrand;
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
              subTitle: id ?? "#1",
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
                imageUser != null
                    ? CircleAvatar(
                  radius: 20,
                  backgroundImage:
                  MemoryImage(imageUser!),
                )
                    : const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.orangeColor,
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
            width: 180,
            child: Row(
              children: [
                Flexible(
                  child: TitleWithSubTitle(
                    title: nameBrandModel??'--',
                    subTitle:plateNo?? '--',
                    textSizeTitle: 12,
                    titleColor: AppColors.darkColor,
                    textSizeSubTitle: 12,
                    subTitleColor: AppColors.darkColor,
                  ),
                ),
                const SizedBox(width: 5),
                imageBrand != null
                    ?
                Image.memory(
                  imageBrand!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ):
                Image.asset(
                  AppImageKeys.car501,
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 180,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.name,
              subTitle: name ?? "---",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          SizedBox(
            width: 180,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.phoneNumber,
              subTitle: phone ?? "---",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

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