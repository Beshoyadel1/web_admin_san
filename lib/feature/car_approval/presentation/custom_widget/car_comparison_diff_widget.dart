import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/car_approval/data/model/car_approval_request_details_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'licence_image_preview_dialog.dart';

class CarComparisonDiffWidget extends StatelessWidget {
  final CarApprovalRequestDetailsModel details;

  const CarComparisonDiffWidget({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final activeCar = details.currentActiveCar;
    if (activeCar == null) {
      return const SizedBox.shrink();
    }

    final currentBrand = activeCar.brand?.brandName ?? '';
    final proposedBrand = details.brandName;
    final isBrandDiff =
        currentBrand != proposedBrand && proposedBrand.isNotEmpty;

    final currentModel = activeCar.model?.modelName ?? '';
    final proposedModel = details.modelName;
    final isModelDiff =
        currentModel != proposedModel && proposedModel.isNotEmpty;

    final currentYear = activeCar.releaseDate?.toString() ?? '—';
    final proposedYear = details.releaseDate?.toString() ?? '—';
    final isYearDiff =
        details.releaseDate != null && currentYear != proposedYear;

    final currentPlate = activeCar.plateNo ?? '—';
    final proposedPlate = details.plateNo ?? '—';
    final isPlateDiff =
        details.plateNo != null && currentPlate != proposedPlate;

    final currentChassis = activeCar.chassisNo ?? '—';
    final proposedChassis = details.chassisNo ?? '—';
    final isChassisDiff =
        details.chassisNo != null && currentChassis != proposedChassis;

    final currentInsurance = activeCar.insuranceNo ?? '—';
    final proposedInsurance = details.insuranceNo ?? '—';
    final isInsuranceDiff =
        details.insuranceNo != null && currentInsurance != proposedInsurance;

    final currentName = activeCar.name ?? '—';
    final proposedName = details.carName ?? '—';
    final isNameDiff = details.carName != null &&
        details.carName!.isNotEmpty &&
        currentName != proposedName;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.compare_arrows_rounded,
                color: AppColors.orangeColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.comparisonHeader.tr(),
                style: const TextStyle(
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightAmberColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.amberColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  LocaleKeys.pendingUpdateBadge.tr(),
                  style: const TextStyle(
                    color: AppColors.amberColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.veryLightGreyColor),
          const SizedBox(height: 12),

          // Header Row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  LocaleKeys.fieldOrProperty.tr(),
                  style: const TextStyle(
                    color: AppColors.darkGreyColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  LocaleKeys.currentActiveData.tr(),
                  style: const TextStyle(
                    color: AppColors.darkGreyColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  LocaleKeys.proposedModification.tr(),
                  style: const TextStyle(
                    color: AppColors.orangeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ComparisonDiffRow(
            label: LocaleKeys.brandLabel.tr(),
            currentValue: currentBrand.isEmpty ? '—' : currentBrand,
            proposedValue: proposedBrand.isEmpty ? '—' : proposedBrand,
            isChanged: isBrandDiff,
          ),
          ComparisonDiffRow(
            label: LocaleKeys.modelLabel.tr(),
            currentValue: currentModel.isEmpty ? '—' : currentModel,
            proposedValue: proposedModel.isEmpty ? '—' : proposedModel,
            isChanged: isModelDiff,
          ),
          ComparisonDiffRow(
            label: LocaleKeys.manufacturingYear.tr(),
            currentValue: currentYear,
            proposedValue: proposedYear,
            isChanged: isYearDiff,
          ),
          ComparisonDiffRow(
            label: LocaleKeys.plateNo.tr(),
            currentValue: currentPlate,
            proposedValue: proposedPlate,
            isChanged: isPlateDiff,
          ),
          ComparisonDiffRow(
            label: LocaleKeys.chassisNumber.tr(),
            currentValue: currentChassis,
            proposedValue: proposedChassis,
            isChanged: isChassisDiff,
          ),
          ComparisonDiffRow(
            label: LocaleKeys.insurancePolicyNumber.tr(),
            currentValue: currentInsurance,
            proposedValue: proposedInsurance,
            isChanged: isInsuranceDiff,
          ),
          ComparisonDiffRow(
            label: LocaleKeys.carNameAlias.tr(),
            currentValue: currentName,
            proposedValue: proposedName,
            isChanged: isNameDiff,
          ),

          // Licence image comparison row if both exist
          if (details.licenceImage != null || activeCar.licenceImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      LocaleKeys.licenceImage.tr(),
                      style: const TextStyle(
                        color: AppColors.darkGreyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: activeCar.licenceImage != null
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TextButton.icon(
                                icon: const Icon(Icons.image, size: 16),
                                label: Text(LocaleKeys.previousLicence.tr()),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.seaBlueColor,
                                ),
                                onPressed: () {
                                  LicenceImagePreviewDialog.show(
                                    context,
                                    imageBytes: activeCar.licenceImage!,
                                    title: LocaleKeys.previousLicenceImageTitle
                                        .tr(),
                                  );
                                },
                              ),
                            ),
                          )
                        : const Text('—',
                            style: TextStyle(color: AppColors.darkGreyColor)),
                  ),
                  Expanded(
                    flex: 4,
                    child: details.licenceImage != null
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TextButton.icon(
                                icon: const Icon(Icons.image, size: 16),
                                label: Text(LocaleKeys.newLicence.tr()),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.orangeColor,
                                ),
                                onPressed: () {
                                  LicenceImagePreviewDialog.show(
                                    context,
                                    imageBytes: details.licenceImage!,
                                    title: LocaleKeys.proposedLicenceImageTitle
                                        .tr(),
                                  );
                                },
                              ),
                            ),
                          )
                        : const Text('—',
                            style: TextStyle(color: AppColors.darkGreyColor)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ComparisonDiffRow extends StatelessWidget {
  final String label;
  final String currentValue;
  final String proposedValue;
  final bool isChanged;

  const ComparisonDiffRow({
    super.key,
    required this.label,
    required this.currentValue,
    required this.proposedValue,
    required this.isChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isChanged
            ? AppColors.lightAmberColor.withValues(alpha: 0.5)
            : AppColors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: isChanged
            ? Border.all(
                color: AppColors.amberColor.withValues(alpha: 0.4), width: 1)
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                if (isChanged) ...[
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 14,
                    color: AppColors.amberColor,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: isChanged
                        ? AppColors.darkColor
                        : AppColors.darkGreyColor,
                    fontSize: 12,
                    fontWeight: isChanged ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              currentValue,
              style: TextStyle(
                color:
                    isChanged ? AppColors.darkGreyColor : AppColors.darkColor,
                fontSize: 12,
                decoration: isChanged ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              proposedValue,
              style: TextStyle(
                color: isChanged ? AppColors.orangeColor : AppColors.darkColor,
                fontSize: 12,
                fontWeight: isChanged ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
