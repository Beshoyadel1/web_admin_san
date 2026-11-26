import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_with_container_status_car.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';
import 'car_model.dart';

class AvailableCars extends StatelessWidget {
  const AvailableCars(
      {super.key,
      this.price,
      this.cost,
      this.brandName,
      this.isSold = false,
      this.isNew = false,
      this.addresstext,
      this.releaseDate,
      this.id,
      this.spacing,
      required this.onTap,
      required this.carImage,
      required this.brandImage});

  final String? id, addresstext, releaseDate, brandName, price, cost;
  final double? spacing;
  final VoidCallback onTap;
  final bool isNew, isSold;
  final Uint8List? carImage, brandImage;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      containerWidth: 800,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: Wrap(
        spacing: spacing ?? 20,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          TextInAppWidget(
              text: id ?? '1#', textSize: 16, textColor: AppColors.darkColor),
          CarModel(
            addresstext: addresstext,
            releaseDate: releaseDate,
            imageBytes: carImage,
          ),
          TextWithContainerStatusCar(
            isNew: isNew,
            text: LocaleKeys.carStatus,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              brandImage != null
                  ? Image.memory(
                      brandImage!,
                      width: 65,
                      height: 40,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      AppImageKeys.nesan,
                      width: 30,
                      height: 34,
                      fit: BoxFit.contain,
                    ),
              TextInAppWidget(
                  text: brandName ?? LocaleKeys.brandNissan.tr(),
                  textSize: 14,
                  textColor: AppColors.darkColor),
            ],
          ),
          TextWithContainerStatusCar(
            isSold: isSold,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const TextInAppWidget(
                  text: LocaleKeys.carPrice,
                  textSize: 14,
                  textColor: AppColors.darkColor),
              TextInAppWidget(
                  text: price ?? '',
                  textSize: 14,
                  textColor: AppColors.darkColor),
            ],
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     const TextInAppWidget(
          //         text: LocaleKeys.cost,
          //         textSize: 14,
          //         textColor: AppColors.darkColor),
          //     TextInAppWidget(
          //         text: cost ?? '',
          //         textSize: 14,
          //         textColor: AppColors.darkColor),
          //   ],
          // ),
          CustomContainer(
            containerHeight: 32,
            containerWidth: 80,
            border: Border.all(color: AppColors.orangeColor),
            isSelected: true,
            onTap: onTap,
            padding: EdgeInsets.zero,
            typeWidget: const Center(
              child: TextInAppWidget(
                  text: LocaleKeys.detailsKey,
                  textSize: 14,
                  textColor: AppColors.orangeColor),
            ),
          ),
        ],
      ),
    );
  }
}
