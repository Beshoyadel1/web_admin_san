import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';

class OrderCarServicesTableCard extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderCarServicesTableCard({
    super.key,
    required this.orderDetails,
  });

  void _showLicenceDialog(BuildContext context, Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (ctx) => OrderLicenceDialog(imageBytes: imageBytes),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cars = orderDetails?.cars ?? [];
    final fallbackServices = orderDetails?.services ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.orangeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.directions_car_filled_rounded,
                color: AppColors.orangeColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const TextInAppWidget(
              text: LocaleKeys.vehiclesAndServicesRequested,
              textSize: 16,
              textColor: AppColors.darkColor,
              fontWeightIndex: FontSelectionData.boldFontFamily,
            ),
            if (cars.isNotEmpty) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.orangeColor.withValues(alpha: 0.25),
                  ),
                ),
                child: TextInAppWidget(
                  text: '${cars.length} ${LocaleKeys.vehicleUnit.tr()}',
                  textSize: 11,
                  textColor: AppColors.orangeColor,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        if (cars.isNotEmpty) ...[
          for (int i = 0; i < cars.length; i++) ...[
            OrderCarCard(
              car: cars[i],
              index: i + 1,
              onViewLicence: (bytes) => _showLicenceDialog(context, bytes),
            ),
            if (i < cars.length - 1) const SizedBox(height: 14),
          ],
        ] else if (fallbackServices.isNotEmpty) ...[
          OrderFallbackServicesCard(services: fallbackServices),
        ] else ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.veryLightGreyColor),
            ),
            child: const Center(
              child: TextInAppWidget(
                text: LocaleKeys.noVehiclesOrServicesInOrder,
                textSize: 13,
                textColor: AppColors.darkGreyColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class OrderCarCard extends StatelessWidget {
  final Car car;
  final int index;
  final void Function(Uint8List bytes) onViewLicence;

  const OrderCarCard({
    super.key,
    required this.car,
    required this.index,
    required this.onViewLicence,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final brandName = isArabic
        ? (car.brand?.brandname ?? car.brand?.brandlatinname ?? '')
        : (car.brand?.brandlatinname ?? car.brand?.brandname ?? '');
    final modelName = car.model?.modelname ?? '';
    final carTitle = [brandName, modelName]
        .where((s) => s.trim().isNotEmpty)
        .join(' ')
        .trim();
    final displayName = carTitle.isNotEmpty
        ? carTitle
        : (car.name?.isNotEmpty == true
            ? car.name!
            : LocaleKeys.vehicleNumbered.tr(args: ['$index']));

    final provServices = car.provServices ?? [];
    final hasLicence = car.licenceimage != null && car.licenceimage!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.veryLightGreyColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: TextInAppWidget(
                              text: displayName,
                              textSize: 15,
                              textColor: AppColors.darkColor,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                              maxLines: 1,
                              isEllipsisTextOverflow: true,
                            ),
                          ),
                          if (car.releasedate != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.scaffoldColor,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppColors.veryLightGreyColor,
                                ),
                              ),
                              child: TextInAppWidget(
                                text: '${car.releasedate}',
                                textSize: 11,
                                textColor: AppColors.darkGreyColor,
                                fontWeightIndex:
                                    FontSelectionData.mediumFontFamily,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (car.chassisno != null &&
                          car.chassisno!.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const TextInAppWidget(
                              text: LocaleKeys.chassisNumberLabel,
                              textSize: 11,
                              textColor: AppColors.darkGreyColor,
                            ),
                            TextInAppWidget(
                              text: car.chassisno!,
                              textSize: 11,
                              textColor: AppColors.darkColor,
                              fontWeightIndex:
                                  FontSelectionData.mediumFontFamily,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (car.plateno != null && car.plateno!.trim().isNotEmpty)
                  CarPlateBadge(plateNo: car.plateno!),
                if (hasLicence) ...[
                  const SizedBox(width: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Tooltip(
                      message: LocaleKeys.viewVehicleRegistration.tr(),
                      child: InkWell(
                        onTap: () => onViewLicence(car.licenceimage!),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.orangeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  AppColors.orangeColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(
                            Icons.featured_play_list_outlined,
                            size: 18,
                            color: AppColors.orangeColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: AppColors.veryLightGreyColor,
          ),

          // Services Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.scaffoldColor,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextInAppWidget(
                    text: LocaleKeys.serviceOrPackage.tr(),
                    textSize: 12,
                    textColor: AppColors.darkGreyColor,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: TextInAppWidget(
                      text: LocaleKeys.quantity.tr(),
                      textSize: 12,
                      textColor: AppColors.darkGreyColor,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextInAppWidget(
                      text: LocaleKeys.price.tr(),
                      textSize: 12,
                      textColor: AppColors.darkGreyColor,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextInAppWidget(
                      text: LocaleKeys.subtotal.tr(),
                      textSize: 12,
                      textColor: AppColors.darkGreyColor,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Services Rows
          if (provServices.isNotEmpty)
            for (final service in provServices)
              OrderServiceTableRow(
                title: service.name ??
                    service.latinname ??
                    LocaleKeys.serviceDefault.tr(),
                quantity: service.quantity ?? 1,
                unitPrice: (service.price ?? 0).toDouble(),
                totalPrice: (service.totalprice ??
                        ((service.price ?? 0) * (service.quantity ?? 1)))
                    .toDouble(),
              )
          else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: TextInAppWidget(
                  text: LocaleKeys.noSpecificServicesForVehicle,
                  textSize: 12,
                  textColor: AppColors.darkGreyColor,
                ),
              ),
            ),

          // Car subtotal if available
          if (car.totalprice != null && car.totalprice! > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextInAppWidget(
                    text: LocaleKeys.vehicleTotal.tr(),
                    textSize: 12,
                    textColor: AppColors.darkGreyColor,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                  ),
                  TextInAppWidget(
                    text: '${car.totalprice} ${LocaleKeys.sarCurrency.tr()}',
                    textSize: 13,
                    textColor: AppColors.orangeColor,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CarPlateBadge extends StatelessWidget {
  final String plateNo;

  const CarPlateBadge({
    super.key,
    required this.plateNo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.darkColor,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.pin_outlined,
            size: 14,
            color: AppColors.darkColor,
          ),
          const SizedBox(width: 4),
          TextInAppWidget(
            text: plateNo,
            textSize: 12,
            textColor: AppColors.darkColor,
            fontWeightIndex: FontSelectionData.boldFontFamily,
          ),
        ],
      ),
    );
  }
}

class OrderServiceTableRow extends StatelessWidget {
  final String title;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const OrderServiceTableRow({
    super.key,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.veryLightGreyColor,
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: TextInAppWidget(
              text: title,
              textSize: 13,
              textColor: AppColors.darkColor,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              maxLines: 2,
              isEllipsisTextOverflow: true,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: TextInAppWidget(
                text: '$quantity',
                textSize: 13,
                textColor: AppColors.darkColor,
                fontWeightIndex: FontSelectionData.boldFontFamily,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextInAppWidget(
                text:
                    '${unitPrice.toStringAsFixed(0)} ${LocaleKeys.sarCurrency.tr()}',
                textSize: 12,
                textColor: AppColors.darkGreyColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextInAppWidget(
                text:
                    '${totalPrice.toStringAsFixed(0)} ${LocaleKeys.sarCurrency.tr()}',
                textSize: 13,
                textColor: AppColors.darkColor,
                fontWeightIndex: FontSelectionData.boldFontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderFallbackServicesCard extends StatelessWidget {
  final List<Service> services;

  const OrderFallbackServicesCard({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.veryLightGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final service in services)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.orangeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.build_circle_outlined,
                      color: AppColors.orangeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextInAppWidget(
                      text: service.name ??
                          service.latinname ??
                          LocaleKeys.serviceDefault.tr(),
                      textSize: 13,
                      textColor: AppColors.darkColor,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class OrderLicenceDialog extends StatelessWidget {
  final Uint8List imageBytes;

  const OrderLicenceDialog({
    super.key,
    required this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextInAppWidget(
                    text: LocaleKeys.vehicleRegistrationDoc.tr(),
                    textSize: 16,
                    textColor: AppColors.darkColor,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.veryLightGreyColor),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
