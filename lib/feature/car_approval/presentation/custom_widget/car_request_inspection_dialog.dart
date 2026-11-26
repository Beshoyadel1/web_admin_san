import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../view_model/car_approval_cubit.dart';
import '../../view_model/car_approval_state.dart';
import 'car_approval_status_badge.dart';
import 'car_approval_type_badge.dart';
import 'car_comparison_diff_widget.dart';
import 'car_request_rejection_dialog.dart';
import 'licence_image_preview_dialog.dart';

class CarRequestInspectionDialog extends StatelessWidget {
  final int requestId;

  const CarRequestInspectionDialog({
    super.key,
    required this.requestId,
  });

  static Future<void> show(
    BuildContext context, {
    required int requestId,
    required CarApprovalCubit cubit,
  }) {
    cubit.loadRequestDetails(requestId);

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: CarRequestInspectionDialog(requestId: requestId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarApprovalCubit, CarApprovalState>(
      listener: (context, state) {
        if (state.actionSuccessMessage != null &&
            state.actionSuccessMessage!.isNotEmpty) {
          AppSnackBar.showSuccess(state.actionSuccessMessage!);
          context.read<CarApprovalCubit>().clearActionMessages();
          Navigator.of(context).pop();
        }
        if (state.actionErrorMessage != null &&
            state.actionErrorMessage!.isNotEmpty) {
          AppSnackBar.showError(state.actionErrorMessage!);
          context.read<CarApprovalCubit>().clearActionMessages();
        }
      },
      builder: (context, state) {
        final details = state.selectedDetails;
        final isLoading = state.isLoadingDetails;
        final hasError = state.detailsErrorMessage != null &&
            state.detailsErrorMessage!.isNotEmpty;

        return Dialog(
          backgroundColor: AppColors.whiteColor,
          surfaceTintColor: AppColors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 960,
              maxHeight: 750,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                InspectionDialogHeader(
                  requestId: requestId,
                  details: details,
                ),
                const Divider(height: 1, color: AppColors.veryLightGreyColor),

                // Body
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (isLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                  color: AppColors.orangeColor),
                              const SizedBox(height: 12),
                              Text(
                                LocaleKeys.loadingRequestDetailsAndLicence.tr(),
                                style: const TextStyle(
                                    color: AppColors.darkGreyColor),
                              ),
                            ],
                          ),
                        );
                      }

                      if (hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: AppColors.redColor, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                state.detailsErrorMessage!,
                                style:
                                    const TextStyle(color: AppColors.darkColor),
                              ),
                              const SizedBox(height: 16),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.orangeColor,
                                    foregroundColor: AppColors.whiteColor,
                                  ),
                                  onPressed: () => context
                                      .read<CarApprovalCubit>()
                                      .loadRequestDetails(requestId),
                                  child: Text(LocaleKeys.retry.tr()),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (details == null) {
                        return Center(
                          child: Text(LocaleKeys.noDataAvailable.tr()),
                        );
                      }

                      return InspectionDialogContent(details: details);
                    },
                  ),
                ),
                const Divider(height: 1, color: AppColors.veryLightGreyColor),

                // Actions Footer
                if (details != null) InspectionDialogFooter(details: details),
              ],
            ),
          ),
        );
      },
    );
  }
}

class InspectionDialogHeader extends StatelessWidget {
  final int requestId;
  final dynamic details;

  const InspectionDialogHeader({
    super.key,
    required this.requestId,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightOrangeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              color: AppColors.orangeColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.carApprovalRequestTitle
                    .tr(args: [requestId.toString()]),
                style: const TextStyle(
                  color: AppColors.darkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (details != null) ...[
                const SizedBox(height: 2),
                Text(
                  details.displayName,
                  style: const TextStyle(
                    color: AppColors.darkGreyColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          const Spacer(),
          if (details != null) ...[
            CarApprovalTypeBadge(requestType: details.requestType),
            const SizedBox(width: 8),
            CarApprovalStatusBadge(status: details.status),
            const SizedBox(width: 12),
          ],
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColors.darkGreyColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class InspectionDialogContent extends StatelessWidget {
  final dynamic details;

  const InspectionDialogContent({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Owner info card
            OwnerInfoCard(details: details),
            const SizedBox(height: 16),

            // 2. Diff comparison or specs
            if (details.isUpdate && details.currentActiveCar != null) ...[
              CarComparisonDiffWidget(details: details),
              const SizedBox(height: 16),
            ] else ...[
              CarSpecificationsCard(details: details),
              const SizedBox(height: 16),
            ],

            // 3. Licence Image preview card
            LicenceImageSectionCard(details: details),

            // 4. If previously rejected, show reason banner
            if (details.isRejected &&
                details.rejectionReason != null &&
                details.rejectionReason.toString().isNotEmpty) ...[
              const SizedBox(height: 16),
              RejectionReasonBanner(reason: details.rejectionReason.toString()),
            ],
          ],
        ),
      ),
    );
  }
}

class OwnerInfoCard extends StatelessWidget {
  final dynamic details;

  const OwnerInfoCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline_rounded,
                  color: AppColors.orangeColor, size: 18),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.carOwnerApplicantDetails.tr(),
                style: const TextStyle(
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              InfoItem(
                label: LocaleKeys.userName.tr(),
                value: details.ownerName.isEmpty ? '—' : details.ownerName,
                icon: Icons.badge_outlined,
              ),
              InfoItem(
                label: LocaleKeys.phoneNumber.tr(),
                value: details.ownerPhone.isEmpty ? '—' : details.ownerPhone,
                icon: Icons.phone_outlined,
              ),
              if (details.ownerEmail != null &&
                  details.ownerEmail.toString().isNotEmpty)
                InfoItem(
                  label: LocaleKeys.email.tr(),
                  value: details.ownerEmail.toString(),
                  icon: Icons.email_outlined,
                ),
              InfoItem(
                label: LocaleKeys.userId.tr(),
                value: '#${details.ownerId}',
                icon: Icons.tag_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CarSpecificationsCard extends StatelessWidget {
  final dynamic details;

  const CarSpecificationsCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.commute_rounded,
                  color: AppColors.seaBlueColor, size: 18),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.requestedCarSpecifications.tr(),
                style: const TextStyle(
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              InfoItem(
                label: LocaleKeys.brandLabel.tr(),
                value: details.brandName.isEmpty ? '—' : details.brandName,
                icon: Icons.branding_watermark_outlined,
              ),
              InfoItem(
                label: LocaleKeys.modelLabel.tr(),
                value: details.modelName.isEmpty ? '—' : details.modelName,
                icon: Icons.directions_car_filled_outlined,
              ),
              InfoItem(
                label: LocaleKeys.manufacturingYear.tr(),
                value: details.releaseDate?.toString() ?? '—',
                icon: Icons.calendar_today_outlined,
              ),
              InfoItem(
                label: LocaleKeys.plateNo.tr(),
                value: details.plateNo ?? '—',
                icon: Icons.subtitles_outlined,
              ),
              InfoItem(
                label: LocaleKeys.chassisNumber.tr(),
                value: details.chassisNo ?? '—',
                icon: Icons.pin_outlined,
              ),
              InfoItem(
                label: LocaleKeys.insurancePolicyNumber.tr(),
                value: details.insuranceNo ?? '—',
                icon: Icons.security_outlined,
              ),
              if (details.carName != null &&
                  details.carName.toString().isNotEmpty)
                InfoItem(
                  label: LocaleKeys.carNameAlias.tr(),
                  value: details.carName.toString(),
                  icon: Icons.label_outline_rounded,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class LicenceImageSectionCard extends StatelessWidget {
  final dynamic details;

  const LicenceImageSectionCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final imageBytes = details.licenceImage;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.photo_outlined,
                  color: AppColors.orangeColor, size: 18),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.drivingLicenceOwnershipImage.tr(),
                style: const TextStyle(
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              if (imageBytes != null)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: TextButton.icon(
                    onPressed: () {
                      LicenceImagePreviewDialog.show(
                        context,
                        imageBytes: imageBytes,
                        title: LocaleKeys.previewCarLicenceTitle
                            .tr(args: [details.displayName.toString()]),
                      );
                    },
                    icon: const Icon(Icons.fullscreen_rounded, size: 16),
                    label: Text(LocaleKeys.zoomAndPreviewFull.tr()),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.orangeColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (imageBytes != null)
            Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    LicenceImagePreviewDialog.show(
                      context,
                      imageBytes: imageBytes,
                      title: LocaleKeys.previewCarLicenceTitle
                          .tr(args: [details.displayName.toString()]),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 180,
                      color: AppColors.scaffoldColor,
                      child: Image.memory(
                        imageBytes,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.no_photography_outlined,
                    size: 36,
                    color: AppColors.darkGreyColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.noLicenceImageAttached.tr(),
                    style: const TextStyle(
                        color: AppColors.darkGreyColor, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class RejectionReasonBanner extends StatelessWidget {
  final String reason;

  const RejectionReasonBanner({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.pinkColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.redColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.report_problem_outlined,
              color: AppColors.redColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.recordedRejectionReason.tr(),
                  style: const TextStyle(
                    color: AppColors.redColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: const TextStyle(
                    color: AppColors.darkColor,
                    fontSize: 12,
                    height: 1.4,
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

class InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.darkGreyColor),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.darkGreyColor,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.darkColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class InspectionDialogFooter extends StatelessWidget {
  final dynamic details;

  const InspectionDialogFooter({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final bool isPending = details.isPending;
    final cubit = context.read<CarApprovalCubit>();
    final isActionLoading =
        context.watch<CarApprovalCubit>().state.isActionLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isPending) ...[
            // Reject Button
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.redColor,
                  side: const BorderSide(color: AppColors.redColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: isActionLoading
                    ? null
                    : () {
                        CarRequestRejectionDialog.show(
                          context,
                          requestId: details.requestId,
                          carName: details.displayName,
                          onConfirm: (reason) => cubit.rejectRequest(
                            requestId: details.requestId,
                            rejectionReason: reason,
                          ),
                        );
                      },
                icon: const Icon(Icons.close_rounded, size: 18),
                label: Text(LocaleKeys.rejectRequestButton.tr()),
              ),
            ),
            const SizedBox(width: 12),

            // Approve Button
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenColor,
                  foregroundColor: AppColors.whiteColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: isActionLoading
                    ? null
                    : () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppColors.whiteColor,
                            title: Text(LocaleKeys.confirmApprovalTitle.tr()),
                            content: Text(
                              LocaleKeys.confirmApprovalPrompt
                                  .tr(args: [details.displayName.toString()]),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: Text(LocaleKeys.cancel.tr()),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.greenColor,
                                  foregroundColor: AppColors.whiteColor,
                                ),
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: Text(LocaleKeys.confirmAcceptance.tr()),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await cubit.approveRequest(details.requestId);
                        }
                      },
                icon: isActionLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.whiteColor,
                        ),
                      )
                    : const Icon(Icons.check_rounded, size: 18),
                label: Text(isActionLoading
                    ? LocaleKeys.approvingProgress.tr()
                    : LocaleKeys.acceptAndApprove.tr()),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                details.isApproved
                    ? LocaleKeys.requestApprovedSuccessfully.tr()
                    : LocaleKeys.requestRejectedNotice.tr(),
                style: const TextStyle(
                    color: AppColors.darkGreyColor, fontSize: 12),
              ),
            ),
            const Spacer(),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreyColor,
                  foregroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(LocaleKeys.close.tr()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
