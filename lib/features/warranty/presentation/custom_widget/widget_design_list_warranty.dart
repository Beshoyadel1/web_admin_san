import 'package:flutter/material.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';

class WidgetDesignListWarranty extends StatelessWidget {
  final int? warrantyId;
  final num? price;
  final int? durationTypeId;
  final int? durationValue;
  final VoidCallback? onTapDetails;

  const WidgetDesignListWarranty({
    super.key,
    this.warrantyId,
    this.price,
    this.durationTypeId,
    this.durationValue,
    this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    final durationType = DurationType.all.where(
          (type) => type.id == durationTypeId,
    );

    final String durationName = durationType.isNotEmpty
        ? durationType.first.name
        : AppLanguageKeys.unknownType;

    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: Wrap(
        spacing: 20,
        runSpacing: 15,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.identity,
              subTitle: warrantyId?.toString() ?? '---',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.price,
              subTitle: '${price ?? 0}',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.durationType,
              subTitle: durationName,
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.durationValue,
              subTitle: '${durationValue ?? 0}',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

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
                    FontSelectionData.mediumFontFamily,
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