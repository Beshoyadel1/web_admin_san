import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/feature/companies_page/data/model/car_group_model/car_group_model.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/cars_companies/company_car_details_dialog.dart';
import 'package:web_admin_san/feature/companies_page/presentation/widgets/company_car_status_badge.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CarGroupCardWidget extends StatelessWidget {
  final CarGroupModel carGroup;

  const CarGroupCardWidget({
    super.key,
    required this.carGroup,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      typeWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CarGroupCardHeader(
            groupName: carGroup.name ?? '',
            carsCount: carGroup.cars.length,
          ),
          const SizedBox(height: 16),
          if (carGroup.cars.isEmpty)
            const CarGroupEmptyState()
          else
            ...List.generate(
              carGroup.cars.length,
              (index) {
                final car = carGroup.cars[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CarGroupCarItemCard(car: car),
                );
              },
            ),
        ],
      ),
    );
  }
}

class CarGroupCardHeader extends StatelessWidget {
  final String groupName;
  final int carsCount;

  const CarGroupCardHeader({
    super.key,
    required this.groupName,
    required this.carsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextInAppWidget(
            text: groupName.isNotEmpty ? groupName : LocaleKeys.cars,
            textSize: 18,
            fontWeightIndex: FontSelectionData.semiBoldFontFamily,
            textColor: AppColors.orangeColor,
            maxLines: 1,
            isEllipsisTextOverflow: true,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.orangeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.orangeColor.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.directions_car,
                size: 14,
                color: AppColors.orangeColor,
              ),
              const SizedBox(width: 4),
              TextInAppWidget(
                text: '$carsCount',
                textSize: 12,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.orangeColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CarGroupEmptyState extends StatelessWidget {
  const CarGroupEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 38,
              color: AppColors.greyColor.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 8),
            const TextInAppWidget(
              text: LocaleKeys.cars_noCarsInGroup,
              textSize: 13,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor: AppColors.darkGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}

class CarGroupCarItemCard extends StatelessWidget {
  final CarInfo car;

  const CarGroupCarItemCard({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final brandName = isArabic
        ? (car.brand?.brandName ?? '')
        : (car.brand?.brandLatinName ?? car.brand?.brandName ?? '');
    final modelName = isArabic
        ? (car.model?.modelName ?? '')
        : (car.model?.modelLatinName ?? car.model?.modelName ?? '');
    final carTitle =
        [brandName, modelName].where((s) => s.isNotEmpty).join(' - ');

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
                    CarGroupCarItemLeading(
                      car: car,
                      carTitle: carTitle,
                    ),
                    const SizedBox(height: 10),
                    CarGroupCarItemTrailing(car: car),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: CarGroupCarItemLeading(
                        car: car,
                        carTitle: carTitle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    CarGroupCarItemTrailing(car: car),
                  ],
                );
        },
      ),
    );
  }
}

class CarGroupCarItemLeading extends StatelessWidget {
  final CarInfo car;
  final String carTitle;

  const CarGroupCarItemLeading({
    super.key,
    required this.car,
    required this.carTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.orangeColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: TextInAppWidget(
              text: '${car.id ?? 0}',
              textSize: 11,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              textColor: AppColors.whiteColor,
              isTextCenter: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: TextInAppWidget(
            text: carTitle.isNotEmpty
                ? carTitle
                : (car.name?.isNotEmpty == true ? car.name! : '-'),
            textSize: 13,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.blackColor,
            maxLines: 1,
            isEllipsisTextOverflow: true,
          ),
        ),
        if (car.driver?.name != null && car.driver!.name!.isNotEmpty) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.whiteGreyColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.lightGreyColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 12,
                  color: AppColors.darkGreyColor,
                ),
                const SizedBox(width: 3),
                TextInAppWidget(
                  text: car.driver!.name!,
                  textSize: 10,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.darkGreyColor,
                ),
              ],
            ),
          ),
        ],
        const SizedBox(width: 8),
        if (car.image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.memory(
              car.image!,
              width: 38,
              height: 24,
              fit: BoxFit.contain,
            ),
          )
        else if (car.model?.image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.memory(
              car.model!.image!,
              width: 38,
              height: 24,
              fit: BoxFit.contain,
            ),
          )
        else
          Image.asset(
            AppImageKeys.car501,
            width: 38,
            height: 24,
            fit: BoxFit.contain,
          ),
      ],
    );
  }
}

class CarGroupCarItemTrailing extends StatelessWidget {
  final CarInfo car;

  const CarGroupCarItemTrailing({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CompanyCarStatusBadge(
          approvalStatus: car.approvalStatus ?? 2,
          isActive: car.isActive ?? true,
        ),
        if (car.hasPendingUpdate == true) ...[
          const SizedBox(width: 6),
          const CompanyCarPendingUpdateBadge(),
        ],
        const SizedBox(width: 8),
        if (car.plateNo != null && car.plateNo!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.lightGreyColor,
              ),
            ),
            child: TextInAppWidget(
              text: car.plateNo!,
              textSize: 12,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              textColor: AppColors.blackColor,
            ),
          ),
          const SizedBox(width: 10),
        ],
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => CompanyCarDetailsDialog(car: car),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.orangeColor),
              ),
              child: const TextInAppWidget(
                text: LocaleKeys.details,
                textSize: 11,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
                textColor: AppColors.orangeColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
