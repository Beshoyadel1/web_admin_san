import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/title_with_sub_title.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/widgets/custom_container.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

class WidgetDesignListHarag extends StatelessWidget {
  const WidgetDesignListHarag({
    super.key,
    this.haragId,
    this.name,
    this.nameButton,
    this.image,
    this.kilometers,
    this.releaseDate,
    this.sellDate,
    this.isNew,
    this.status,
    this.isSold,
    this.onTabDetails,
    this.spacing,
    this.isDemoData = false,
  });

  final String? haragId;
  final String? name;
  final String? nameButton;
  final String? kilometers;
  final String? releaseDate;
  final String? sellDate;
  final double? spacing;
  final bool isDemoData;
  final void Function()? onTabDetails;
  final Uint8List? image;
  final bool? isNew;
  final int? status;
  final bool? isSold;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: Wrap(
        spacing: spacing ?? 20,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // 1. ID ("المعرف") - To the right of the image
          SizedBox(
            width: 80,
            child: TitleWithSubTitle(
              title: LocaleKeys.identifier.tr(),
              subTitle: haragId ?? '1',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // 2. USER (Avatar + Name)
          if (!isDemoData)
            SizedBox(
              width: 220,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  image != null
                      ? CircleAvatar(
                          radius: 20,
                          backgroundImage: MemoryImage(image!),
                        )
                      : CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              AppColors.lightOrangeColor.withOpacity(0.2),
                          child: const Icon(
                            Icons.person_outline,
                            color: AppColors.orangeColor,
                            size: 20,
                          ),
                        ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextInAppWidget(
                      text: name ?? '---',
                      textSize: 15,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                      textColor: AppColors.blackColor,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),

          // 3. KILOMETERS
          if (!isDemoData)
            SizedBox(
              width: 110,
              child: TitleWithSubTitle(
                title: LocaleKeys.kilometers,
                subTitle: kilometers ?? '0',
                textSizeTitle: 12,
                titleColor: AppColors.greyColor,
                textSizeSubTitle: 14,
                subTitleColor: AppColors.darkColor,
              ),
            ),

          // 4. RELEASE DATE
          SizedBox(
            width: 110,
            child: TitleWithSubTitle(
              title: LocaleKeys.releaseDate,
              subTitle: releaseDate ?? '---',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // 5. CAR CONDITION: "حالة السيارة" (جديدة / مستعملة)
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInAppWidget(
                  text: LocaleKeys.carCondition.tr(),
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
                    color: isNew == true
                        ? AppColors.greenColor.withOpacity(0.12)
                        : AppColors.orangeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextInAppWidget(
                    text: isNew == true
                        ? LocaleKeys.newCar.tr()
                        : LocaleKeys.usedCar.tr(),
                    textSize: 12,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: isNew == true
                        ? AppColors.greenColor
                        : AppColors.orangeColor,
                  ),
                ),
              ],
            ),
          ),

          // 6. HARAG STATUS: "الحالة" (نشط / معلق / تم البيع / محذوف)
          SizedBox(
            width: 125,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInAppWidget(
                  text: LocaleKeys.status.tr(),
                  textSize: 12,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.greyColor,
                ),
                const SizedBox(height: 5),
                _HaragListStatusBadge(
                  status: status,
                  isSold: isSold,
                ),
              ],
            ),
          ),

          // 7. DETAILS BUTTON
          SizedBox(
            width: 100,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: onTabDetails,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 7,
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
                      text: nameButton ?? LocaleKeys.details.tr(),
                      textSize: 12,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                      textColor: AppColors.orangeColor,
                    ),
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

class _HaragListStatusBadge extends StatelessWidget {
  final int? status;
  final bool? isSold;

  const _HaragListStatusBadge({
    required this.status,
    required this.isSold,
  });

  @override
  Widget build(BuildContext context) {
    // HarageStatus: 1: Created (نشط), 2: Suspended (معلق), 3: Sold (تم البيع), 4: Deleted (محذوف)
    final effectiveStatus = status ?? (isSold == true ? 3 : 1);

    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (effectiveStatus) {
      case 2:
        label = LocaleKeys.pending.tr();
        bg = AppColors.lightAmberColor;
        fg = AppColors.amberColor;
        icon = Icons.pause_circle_outline;
        break;
      case 3:
        label = LocaleKeys.sold.tr();
        bg = AppColors.redColor.withOpacity(0.1);
        fg = AppColors.redColor;
        icon = Icons.sell_outlined;
        break;
      case 4:
        label = LocaleKeys.deleted.tr();
        bg = AppColors.greyColor.withOpacity(0.12);
        fg = AppColors.greyColor;
        icon = Icons.delete_outline;
        break;
      case 1:
      default:
        label = LocaleKeys.active.tr();
        bg = AppColors.lightBlueSoft;
        fg = AppColors.blueAccentColor;
        icon = Icons.inventory_2_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: fg.withOpacity(0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: fg,
          ),
          const SizedBox(width: 5),
          TextInAppWidget(
            text: label,
            textSize: 12,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: fg,
          ),
        ],
      ),
    );
  }
}
