import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/companies_page/data/model/get_company_cars_with_drivers_model/get_company_cars_with_drivers_model.dart';

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CompanyCarGroupHeader(isHasDriver: isHasDriver),
          const SizedBox(height: 16),
          if (cars.isEmpty)
            const CompanyCarEmptyGroupView()
          else
            ...List.generate(
              cars.length,
              (index) {
                final car = cars[index];
                final isArabic =
                    Directionality.of(context) == TextDirection.rtl;

                final brandName = isArabic
                    ? (car.brand?.name ?? '')
                    : (car.brand?.latinName ?? '');
                final modelName = car.model?.name ?? '';
                final carName = brandName.isNotEmpty && modelName.isNotEmpty
                    ? '$brandName - $modelName'
                    : (brandName.isNotEmpty ? brandName : modelName);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CompanyCarItemCard(
                    car: car,
                    carName: carName,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class CompanyCarGroupHeader extends StatelessWidget {
  final bool isHasDriver;

  const CompanyCarGroupHeader({
    super.key,
    required this.isHasDriver,
  });

  @override
  Widget build(BuildContext context) {
    return TextInAppWidget(
      text: isHasDriver ? LocaleKeys.employeeCars : LocaleKeys.salesCars,
      textSize: 16,
      fontWeightIndex: FontSelectionData.semiBoldFontFamily,
      textColor: AppColors.orangeColor,
    );
  }
}

class CompanyCarEmptyGroupView extends StatelessWidget {
  const CompanyCarEmptyGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 40,
              color: AppColors.greyColor.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 10),
            const TextInAppWidget(
              text: LocaleKeys.cars_noCarsInGroup,
              textSize: 14,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor: AppColors.darkGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyCarItemCard extends StatelessWidget {
  final GetCompanyCarWithDriver car;
  final String carName;

  const CompanyCarItemCard({
    super.key,
    required this.car,
    required this.carName,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 500;

          return isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompanyCarInfoRow(car: car, carName: carName),
                    const SizedBox(height: 12),
                    CompanyCarPlateRow(car: car, isMobile: true),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: CompanyCarInfoRow(car: car, carName: carName),
                    ),
                    const SizedBox(width: 15),
                    CompanyCarPlateRow(car: car, isMobile: false),
                  ],
                );
        },
      ),
    );
  }
}

class CompanyCarInfoRow extends StatelessWidget {
  final GetCompanyCarWithDriver car;
  final String carName;

  const CompanyCarInfoRow({
    super.key,
    required this.car,
    required this.carName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: AppColors.orangeColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: TextInAppWidget(
              text: car.carId.toString(),
              textSize: 11,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.whiteColor,
              isTextCenter: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: TextInAppWidget(
            text: carName.isNotEmpty ? carName : '-',
            textSize: 12,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
            maxLines: 1,
            isEllipsisTextOverflow: true,
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
}

class CompanyCarPlateRow extends StatelessWidget {
  final GetCompanyCarWithDriver car;
  final bool isMobile;

  const CompanyCarPlateRow({
    super.key,
    required this.car,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMobile ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
      children: [
        TextInAppWidget(
          text: car.plateNo ?? '-',
          textSize: 12,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.blackColor,
        ),
      ],
    );
  }
}
