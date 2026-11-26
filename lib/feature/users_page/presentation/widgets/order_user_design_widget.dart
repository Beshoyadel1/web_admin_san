import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/title_with_sub_title.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/widgets/custom_container.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

class OrderUserDesignWidget extends StatelessWidget {
  const OrderUserDesignWidget({
    super.key,
    this.id,
    this.spacing,
    this.nameProvider,
    this.onTapViewRates,
    this.nameButton,
    this.imageProvider,
    this.joinDate,
    this.lastOrderDate,
  });

  final String? id, nameProvider, nameButton, joinDate, lastOrderDate;
  final double? spacing;
  final void Function()? onTapViewRates;
  final Uint8List? imageProvider;
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
              title: LocaleKeys.identity,
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
                imageProvider != null
                    ? CircleAvatar(
                        radius: 20,
                        backgroundImage: MemoryImage(imageProvider!),
                      )
                    : const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.red,
                      ),
                SizedBox(
                  width: 180,
                  child: TextInAppWidget(
                    text: nameProvider ?? "###",
                    textSize: 15,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
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
              title: LocaleKeys.joiningDate,
              subTitle: joinDate ?? "0",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),
          SizedBox(
            width: 180,
            child: TitleWithSubTitle(
              title: LocaleKeys.lastOrderDate,
              subTitle: lastOrderDate ?? "---",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),
          SizedBox(
            width: 110,
            child: InkWell(
              onTap: onTapViewRates,
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
                child: Center(
                  child: TextInAppWidget(
                    text: nameButton ?? LocaleKeys.details,
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
