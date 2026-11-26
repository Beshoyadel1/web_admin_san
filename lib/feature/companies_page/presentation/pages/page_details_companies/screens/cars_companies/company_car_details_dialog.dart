import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/companies_page/data/model/car_group_model/car_group_model.dart';
import 'package:web_admin_san/feature/companies_page/presentation/widgets/company_car_status_badge.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CompanyCarDetailsDialog extends StatelessWidget {
  final CarInfo car;

  const CompanyCarDetailsDialog({
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

    return Dialog(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.orangeColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextInAppWidget(
                          text: '#${car.id ?? 0}',
                          textSize: 12,
                          fontWeightIndex: FontSelectionData.boldFontFamily,
                          textColor: AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextInAppWidget(
                        text:
                            carTitle.isNotEmpty ? carTitle : LocaleKeys.details,
                        textSize: 18,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.blackColor,
                      ),
                    ],
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: AppColors.greyColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.lightGreyColor, height: 24),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Rejection Alert Banner
                      if (car.isRejected &&
                          car.rejectionReason != null &&
                          car.rejectionReason!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.badgeRedBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.redColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.redColor,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextInAppWidget(
                                      text: 'تم رفض السيارة',
                                      textSize: 13,
                                      fontWeightIndex:
                                          FontSelectionData.boldFontFamily,
                                      textColor: AppColors.redColor,
                                    ),
                                    const SizedBox(height: 4),
                                    TextInAppWidget(
                                      text:
                                          'سبب الرفض: ${car.rejectionReason!}',
                                      textSize: 12,
                                      fontWeightIndex:
                                          FontSelectionData.regularFontFamily,
                                      textColor: AppColors.darkGreyColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Pending Update Alert Banner
                      if (car.hasPendingUpdate == true) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlueSoft,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.blueAccentColor
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.blueAccentColor,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextInAppWidget(
                                  text:
                                      'يوجد طلب تعديل قيد المراجعة لهذه السيارة',
                                  textSize: 12,
                                  fontWeightIndex:
                                      FontSelectionData.mediumFontFamily,
                                  textColor: AppColors.blueAccentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Car image banner
                      Center(
                        child: car.image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  car.image!,
                                  height: 140,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Image.asset(
                                AppImageKeys.car501,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                      ),
                      const SizedBox(height: 20),

                      // Status row
                      CarDetailCustomRow(
                        label: 'حالة الاعتماد',
                        child: CompanyCarStatusBadge(
                          approvalStatus: car.approvalStatus ?? 2,
                          isActive: car.isActive ?? true,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Assigned Driver
                      CarDetailItemRow(
                        label: 'السائق المخصص',
                        value: (car.driver?.name != null &&
                                car.driver!.name!.isNotEmpty)
                            ? car.driver!.name!
                            : 'غير مخصص',
                      ),
                      const SizedBox(height: 12),

                      // Details grid
                      CarDetailItemRow(
                        label: LocaleKeys.cars,
                        value: carTitle.isNotEmpty ? carTitle : '-',
                      ),
                      const SizedBox(height: 12),
                      CarDetailItemRow(
                        label: LocaleKeys.plateNumber,
                        value: car.plateNo ?? '-',
                      ),
                      const SizedBox(height: 12),
                      CarDetailItemRow(
                        label: LocaleKeys.cars_chassisNumber,
                        value: car.chassisNo ?? '-',
                      ),
                      const SizedBox(height: 12),
                      CarDetailItemRow(
                        label: LocaleKeys.insurance,
                        value: car.insuranceNo ?? '-',
                      ),
                      if (car.releaseDate != null) ...[
                        const SizedBox(height: 12),
                        CarDetailItemRow(
                          label: LocaleKeys.releaseDate,
                          value: car.releaseDate.toString(),
                        ),
                      ],
                      if (car.licenceImage != null) ...[
                        const SizedBox(height: 16),
                        const TextInAppWidget(
                          text: LocaleKeys.licenseImage,
                          textSize: 14,
                          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                          textColor: AppColors.blackColor,
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            car.licenceImage!,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orangeColor,
                      foregroundColor: AppColors.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const TextInAppWidget(
                      text: LocaleKeys.cancel,
                      textSize: 13,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                      textColor: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarDetailItemRow extends StatelessWidget {
  final String label;
  final String value;

  const CarDetailItemRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInAppWidget(
            text: label,
            textSize: 13,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.darkGreyColor,
          ),
          TextInAppWidget(
            text: value,
            textSize: 13,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            textColor: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}

class CarDetailCustomRow extends StatelessWidget {
  final String label;
  final Widget child;

  const CarDetailCustomRow({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInAppWidget(
            text: label,
            textSize: 13,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.darkGreyColor,
          ),
          child,
        ],
      ),
    );
  }
}
