import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/approved_centers_page/view_model/toggle_provider_approval_status_cubit/toggle_provider_approval_status_cubit.dart';
import 'package:web_admin_san/feature/approved_centers_page/view_model/toggle_provider_approval_status_cubit/toggle_provider_approval_status_state.dart';

class ProviderApprovalSwitch extends StatelessWidget {
  final int providerId;
  final bool isApproved;

  const ProviderApprovalSwitch({
    super.key,
    required this.providerId,
    required this.isApproved,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ToggleProviderApprovalStatusCubit>();

    // Set initial value from API
    cubit.setInitialStatus(isApproved);

    return BlocConsumer<ToggleProviderApprovalStatusCubit,
        ToggleProviderApprovalStatusState>(
      listener: (context, state) {
        // =========================
        // SUCCESS
        // =========================

        if (state is ToggleProviderApprovalStatusSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.result.message ??
                    LocaleKeys.providerApprovalUpdatedSuccess.tr(),
              ),
            ),
          );
        }

        // =========================
        // ERROR
        // =========================

        if (state is ToggleProviderApprovalStatusError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        final bool currentValue = cubit.currentApprovalStatus ?? isApproved;

        final bool isLoading = state is ToggleProviderApprovalStatusLoading;

        return Wrap(
          spacing: 5,
          runSpacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.start,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            else
              Switch(
                value: currentValue,
                activeColor: AppColors.greenColor,
                onChanged: (newValue) {
                  cubit.toggleProviderApprovalStatus(
                    providerId: providerId,
                    isActive: newValue,
                  );
                },
              ),
            TextInAppWidget(
              text: currentValue ? LocaleKeys.approved : LocaleKeys.notApproved,
              textSize: 14,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor:
                  currentValue ? AppColors.greenColor : AppColors.greyColor,
            ),
          ],
        );
      },
    );
  }
}
