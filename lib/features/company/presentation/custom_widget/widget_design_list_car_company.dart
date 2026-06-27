import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../core/theming/text_styles.dart';

import 'package:web_admin_san/features/company/data/model/get_company_cars_with_drivers_model/get_company_cars_with_drivers_model.dart';

class WidgetDesignListCarCompany extends StatelessWidget {
  const WidgetDesignListCarCompany({
    super.key,
    required this.cars,
    this.isHasDriver = true,
  });

  final List<GetCompanyCarWithDriver> cars;
  final bool isHasDriver;

  @override
  Widget build(BuildContext context) {

    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: Column(
        spacing: 20,
        children: [
          _header(),

          ...List.generate(
            cars.length,
                (index) {
              final car = cars[index];
              final isArabic = Directionality.of(context) == TextDirection.rtl;

              final brandName = isArabic
                  ? (car.brand?.name ?? "")
                  : (car.brand?.latinName ?? "");

              final modelName = car.model?.name ?? "";

              final carName = "$brandName - $modelName";
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomContainer(
                  isSelected: false,
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  typeWidget: LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 500;

                      return isMobile
                          ? Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          _carInfo(
                            car: car,
                            isMobile: true,
                            carName: carName
                          ),
                          const SizedBox(height: 12),
                          _plateInfo(
                            car: car,
                            isMobile: true,
                          ),
                        ],
                      )
                          : Row(
                        children: [
                          Expanded(
                            child: _carInfo(
                              car: car,
                              isMobile: false,
                                carName: carName
                            ),
                          ),
                          const SizedBox(width: 15),
                          _plateInfo(
                            car: car,
                            isMobile: false,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _carInfo({
    required GetCompanyCarWithDriver car,
    required bool isMobile,
    required String carName,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.orangeColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: TextInAppWidget(
              text: car.carId.toString(),
              textSize: 11,
              fontWeightIndex:
              FontSelectionData.regularFontFamily,
              textColor: AppColors.whiteColor,
              isTextCenter: true,
            ),
          ),
        ),
        const SizedBox(width: 8),

        isMobile
            ? Expanded(
          child: TextInAppWidget(
            text: carName,
            textSize: 11,
            fontWeightIndex:
            FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
        )
            : Flexible(
          child: TextInAppWidget(
            text:
            carName,
            textSize: 11,
            fontWeightIndex:
            FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
        ),

        const SizedBox(width: 8),

        car.model?.image != null
            ? Image.memory(
          car.model!.image!,
          width: 35,
          height: 22,
          fit: BoxFit.contain,
        )
            : Image.asset(
          AppImageKeys.car501,
          width: 35,
          height: 22,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _plateInfo({
    required GetCompanyCarWithDriver car,
    required bool isMobile,
  }) {
    return Row(
      spacing: 5,
      mainAxisAlignment: isMobile
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      mainAxisSize:
      isMobile ? MainAxisSize.max : MainAxisSize.min,
      children: [
        TextInAppWidget(
          text: car.plateNo ?? "-",
          textSize: 12,
          fontWeightIndex:
          FontSelectionData.mediumFontFamily,
          textColor: AppColors.blackColor,
        ),
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 13,
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: TextInAppWidget(
            text: isHasDriver
                ? AppLanguageKeys.employeeCars
                : AppLanguageKeys.salesCars,
            textSize: 15,
            fontWeightIndex:
            FontSelectionData.mediumFontFamily,
            textColor: AppColors.orangeColor,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextInAppWidget(
              text: AppLanguageKeys.edit,
              textSize: 12,
              fontWeightIndex:
              FontSelectionData.mediumFontFamily,
              textColor: AppColors.blackColor,
              decorationText: TextDecoration.underline,
              decorationTextColor: AppColors.blackColor,
            ),
            const SizedBox(width: 5),
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}