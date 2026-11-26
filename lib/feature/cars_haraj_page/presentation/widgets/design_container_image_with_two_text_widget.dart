import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

import '../../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/title_with_sub_title.dart';

class DesignContainerImageWithTwoTextWidget extends StatelessWidget {
  final String? imagePath, title, subTitle;
  final double? textSizeTitle,
      textSizeSubTitle,
      imageContainerWidth,
      imageContainerHeight;
  final Color? subTitleColor, titleColor, imageContainerColor;
  final bool? isBorder, isFlex;

  const DesignContainerImageWithTwoTextWidget({
    super.key,
    this.imagePath,
    this.title,
    this.subTitle,
    this.textSizeTitle,
    this.textSizeSubTitle,
    this.subTitleColor,
    this.titleColor,
    this.isBorder = false,
    this.isFlex = false,
    this.imageContainerColor,
    this.imageContainerHeight,
    this.imageContainerWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          // ContainerImageWidget(
          //   imagePath: imagePath ?? AppImageKeys.account_sun1,
          //   color: imageContainerColor ?? AppColors.pinkColor,
          //   isBorder: isBorder ?? false,
          //   width: imageContainerWidth ?? 70,
          //   height: imageContainerHeight,
          // ),
          TitleWithSubTitle(
            title: title ?? LocaleKeys.totalBalancesLabel.tr(),
            subTitle: subTitle ?? '0 ${LocaleKeys.sarCurrency.tr()}',
            textSizeTitle: textSizeTitle ?? 15,
            textSizeSubTitle: textSizeSubTitle ?? 14,
            subTitleColor: subTitleColor ?? AppColors.orangeColor,
            titleColor: titleColor ?? AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}
