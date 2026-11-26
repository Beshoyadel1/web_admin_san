import 'package:flutter/material.dart';
import '../../../../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/title_with_sub_title.dart';

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
        : LocaleKeys.unknownType;

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
              title: LocaleKeys.identity,
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
              title: LocaleKeys.price,
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
              title: LocaleKeys.durationType,
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
              title: LocaleKeys.durationValue,
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
