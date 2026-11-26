import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class HaragStatusDropdownWidget extends StatelessWidget {
  final int harageId;
  final int currentStatus;

  const HaragStatusDropdownWidget({
    super.key,
    required this.harageId,
    required this.currentStatus,
  });

  static const List<int> adminChangeableStatuses = [1, 2];
  static const List<int> supportedStatuses = [1, 2, 3, 4];

  List<int> get _displayedStatuses {
    final list = List<int>.from(adminChangeableStatuses);
    if (!list.contains(currentStatus) &&
        supportedStatuses.contains(currentStatus)) {
      list.add(currentStatus);
    }
    return list;
  }

  static String getStatusName(int status) {
    switch (status) {
      case 1:
        return LocaleKeys.active.tr();
      case 2:
        return LocaleKeys.pending.tr();
      case 3:
        return LocaleKeys.sold.tr();
      case 4:
        return LocaleKeys.deleted.tr();
      default:
        return LocaleKeys.active.tr();
    }
  }

  static const Map<int, IconData> statusIcons = {
    1: Icons.inventory_2_outlined,
    2: Icons.pause_circle_outline,
    3: Icons.sell_outlined,
    4: Icons.delete_outline,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HaragCubit, HaragState>(
      builder: (context, state) {
        final isLoading = state is ChangeHarageStatusLoading;

        if (isLoading) {
          return Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 10),
                TextInAppWidget(
                  text: LocaleKeys.loading,
                  textSize: 13,
                  textColor: AppColors.darkGreyColor,
                ),
              ],
            ),
          );
        }

        final statuses = _displayedStatuses;

        return Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.orangeColor.withOpacity(0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkColor.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: statuses.contains(currentStatus) ? currentStatus : 1,
              icon: const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.orangeColor,
                  size: 22,
                ),
              ),
              borderRadius: BorderRadius.circular(12),
              items: statuses.map((statusKey) {
                final icon = statusIcons[statusKey] ?? Icons.circle;
                return DropdownMenuItem<int>(
                  value: statusKey,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 16,
                        color: _getStatusColor(statusKey),
                      ),
                      const SizedBox(width: 8),
                      TextInAppWidget(
                        text: getStatusName(statusKey),
                        textSize: 14,
                        fontWeightIndex: FontSelectionData.mediumFontFamily,
                        textColor: AppColors.darkColor,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newStatus) async {
                if (newStatus == null ||
                    newStatus == currentStatus ||
                    !adminChangeableStatuses.contains(newStatus)) {
                  return;
                }

                String? notes;
                if (newStatus == 2) {
                  // Status 2 is Suspended: requires reason/notes
                  final reason = await showDialog<String>(
                    context: context,
                    builder: (ctx) => const _HaragSuspendReasonDialog(),
                  );
                  if (reason == null ||
                      reason.trim().isEmpty ||
                      !context.mounted) {
                    return;
                  }
                  notes = reason.trim();
                } else {
                  final statusName = getStatusName(newStatus);
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => _HaragStatusConfirmationDialog(
                      newStatusName: statusName,
                    ),
                  );

                  if (confirmed != true || !context.mounted) return;
                }

                final cubit = context.read<HaragCubit>();
                await cubit.changeHarageStatus(
                  harageId: harageId,
                  status: newStatus,
                  notes: notes,
                );

                if (!context.mounted) return;
                AppSnackBar.showSuccess(
                    LocaleKeys.harageStatusChangedSuccessfully.tr());
                await cubit.getHarageDetails(harageId: harageId);
              },
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 2:
        return AppColors.amberColor;
      case 3:
        return AppColors.redColor;
      case 4:
        return AppColors.greyColor;
      case 1:
      default:
        return AppColors.blueAccentColor;
    }
  }
}

class _HaragStatusConfirmationDialog extends StatelessWidget {
  final String newStatusName;

  const _HaragStatusConfirmationDialog({
    required this.newStatusName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: TextInAppWidget(
        text: LocaleKeys.confirmChangeStatusTitle.tr(),
        textSize: 17,
        fontWeightIndex: FontSelectionData.boldFontFamily,
        textColor: AppColors.darkColor,
      ),
      content: TextInAppWidget(
        text: LocaleKeys.confirmChangeStatusPrompt.tr(args: [newStatusName]),
        textSize: 14,
        textColor: AppColors.darkGreyColor,
      ),
      actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: TextInAppWidget(
            text: LocaleKeys.cancel.tr(),
            textSize: 14,
            textColor: AppColors.greyColor,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orangeColor,
            foregroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: TextInAppWidget(
            text: LocaleKeys.confirm.tr(),
            textSize: 14,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.whiteColor,
          ),
        ),
      ],
    );
  }
}

class _HaragSuspendReasonDialog extends StatefulWidget {
  const _HaragSuspendReasonDialog();

  @override
  State<_HaragSuspendReasonDialog> createState() =>
      _HaragSuspendReasonDialogState();
}

class _HaragSuspendReasonDialogState extends State<_HaragSuspendReasonDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.pause_circle_outline,
            color: AppColors.amberColor,
            size: 24,
          ),
          const SizedBox(width: 8),
          TextInAppWidget(
            text: LocaleKeys.suspendListingTitle.tr(),
            textSize: 17,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            textColor: AppColors.darkColor,
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInAppWidget(
                text: LocaleKeys.suspendReasonPrompt.tr(),
                textSize: 14,
                textColor: AppColors.darkGreyColor,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _controller,
                maxLines: 4,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: LocaleKeys.suspendReasonHint.tr(),
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.greyColor,
                  ),
                  filled: true,
                  fillColor: AppColors.whiteGreyColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.greyColor.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.greyColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.orangeColor,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocaleKeys.suspendReasonRequired.tr();
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: TextInAppWidget(
            text: LocaleKeys.cancel.tr(),
            textSize: 14,
            textColor: AppColors.greyColor,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orangeColor,
            foregroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              Navigator.pop(context, _controller.text.trim());
            }
          },
          child: TextInAppWidget(
            text: LocaleKeys.confirmSuspend.tr(),
            textSize: 14,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.whiteColor,
          ),
        ),
      ],
    );
  }
}
