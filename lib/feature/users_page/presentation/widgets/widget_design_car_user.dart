import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/users_page/data/model/user_details_model/user_details_model.dart';

class WidgetDesignCarUser extends StatelessWidget {
  final UserCarModel car;

  const WidgetDesignCarUser({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    final isDefault = car.isDefault;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault
              ? AppColors.orangeColor
              : AppColors.greyColor.withValues(alpha: 0.25),
          width: isDefault ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDefault
                ? AppColors.orangeColor.withValues(alpha: 0.08)
                : AppColors.darkColor.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Image + Name + Default Badge
          _CarHeader(car: car),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.veryLightGreyColor),
          const SizedBox(height: 14),

          // Details Grid / Items
          _CarDetailItem(
            icon: Icons.branding_watermark_outlined,
            title: LocaleKeys.brandLabel,
            value: car.brandName.isNotEmpty ? car.brandName : '-',
          ),
          const SizedBox(height: 8),
          _CarDetailItem(
            icon: Icons.directions_car_outlined,
            title: LocaleKeys.modelLabel,
            value: car.modelName.isNotEmpty ? car.modelName : '-',
          ),
          const SizedBox(height: 8),
          _CarDetailItem(
            icon: Icons.calendar_today_outlined,
            title: LocaleKeys.releaseDate,
            value: car.releaseDate > 0 ? '${car.releaseDate}' : '-',
          ),
          const SizedBox(height: 8),
          _CarDetailItem(
            icon: Icons.pin_outlined,
            title: LocaleKeys.plateNo,
            value: car.plateNo.isNotEmpty ? car.plateNo : '-',
          ),
          const SizedBox(height: 8),
          _CarDetailItem(
            icon: Icons.confirmation_number_outlined,
            title: LocaleKeys.chassisNumber,
            value: car.chassisNo.isNotEmpty ? car.chassisNo : '-',
          ),
          const SizedBox(height: 8),
          _CarDetailItem(
            icon: Icons.verified_user_outlined,
            title: LocaleKeys.insurancePolicyNumber,
            value: car.insuranceNo.isNotEmpty ? car.insuranceNo : '-',
          ),
          const SizedBox(height: 8),
          _CarStatusItem(isActive: car.isActive),
        ],
      ),
    );
  }
}

class _CarHeader extends StatelessWidget {
  final UserCarModel car;

  const _CarHeader({required this.car});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 44,
            color: AppColors.scaffoldColor,
            padding: const EdgeInsets.all(4),
            child: car.brandImage != null
                ? Image.memory(
                    car.brandImage!,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    AppImageKeys.car501,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInAppWidget(
                text: car.name.isNotEmpty ? car.name : car.modelName,
                textSize: 14,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.darkColor,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              TextInAppWidget(
                text: car.plateNo.isNotEmpty ? car.plateNo : '#${car.carId}',
                textSize: 12,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
                textColor: AppColors.greyColor,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _CarDefaultBadge(isDefault: car.isDefault),
      ],
    );
  }
}

class _CarDefaultBadge extends StatelessWidget {
  final bool isDefault;

  const _CarDefaultBadge({required this.isDefault});

  @override
  Widget build(BuildContext context) {
    if (isDefault) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.CircleLightorangeColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.orangeColor,
            width: 1.2,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              color: AppColors.orangeColor,
              size: 14,
            ),
            SizedBox(width: 4),
            TextInAppWidget(
              text: LocaleKeys.defaultCar,
              textSize: 11,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              textColor: AppColors.orangeColor,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.greyColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.greyColor.withValues(alpha: 0.3),
        ),
      ),
      child: const TextInAppWidget(
        text: LocaleKeys.secondaryCar,
        textSize: 11,
        fontWeightIndex: FontSelectionData.mediumFontFamily,
        textColor: AppColors.greyColor,
      ),
    );
  }
}

class _CarDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _CarDetailItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: AppColors.darkGreyColor,
        ),
        const SizedBox(width: 8),
        TextInAppWidget(
          text: title,
          textSize: 12,
          textColor: AppColors.darkGreyColor,
        ),
        const Spacer(),
        TextInAppWidget(
          text: value,
          textSize: 12,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.darkColor,
        ),
      ],
    );
  }
}

class _CarStatusItem extends StatelessWidget {
  final bool isActive;

  const _CarStatusItem({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.toggle_on_outlined,
          size: 15,
          color: AppColors.darkGreyColor,
        ),
        const SizedBox(width: 8),
        const TextInAppWidget(
          text: LocaleKeys.status,
          textSize: 12,
          textColor: AppColors.darkGreyColor,
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.greenColor.withValues(alpha: 0.1)
                : AppColors.redColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextInAppWidget(
            text: isActive ? LocaleKeys.active : LocaleKeys.inactive,
            textSize: 11,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            textColor: isActive ? AppColors.greenColor : AppColors.redColor,
          ),
        ),
      ],
    );
  }
}
