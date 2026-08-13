import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/approved_centers/presentation/bloc/toggle_provider_approval_status_cubit/toggle_provider_approval_status_cubit.dart';
import 'package:web_admin_san/features/approved_centers/presentation/bloc/toggle_provider_approval_status_cubit/toggle_provider_approval_status_state.dart';

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
    final cubit =
    context.read<
        ToggleProviderApprovalStatusCubit>();

    // Set initial value from API
    cubit.setInitialStatus(isApproved);

    return BlocConsumer<
        ToggleProviderApprovalStatusCubit,
        ToggleProviderApprovalStatusState>(
      listener: (context, state) {

        // =========================
        // SUCCESS
        // =========================

        if (state
        is ToggleProviderApprovalStatusSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.result.message ??
                    'تم تحديث حالة الاعتماد بنجاح',
              ),
            ),
          );
        }

        // =========================
        // ERROR
        // =========================

        if (state
        is ToggleProviderApprovalStatusError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },

      builder: (context, state) {

        final bool currentValue =
            cubit.currentApprovalStatus ??
                isApproved;

        final bool isLoading =
        state
        is ToggleProviderApprovalStatusLoading;

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
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            else
              Switch(
                value: currentValue,

                activeColor:
                AppColors.greenColor,

                onChanged: (newValue) {

                  cubit
                      .toggleProviderApprovalStatus(
                    providerId:
                    providerId,
                    isActive:
                    newValue,
                  );
                },
              ),

            TextInAppWidget(
              text: currentValue
                  ? AppLanguageKeys.approved
                  : AppLanguageKeys.notApproved,
              textSize: 14,
              fontWeightIndex:
              FontSelectionData
                  .mediumFontFamily,
              textColor: currentValue
                  ? AppColors.greenColor
                  : AppColors.greyColor,
            ),
          ],
        );
      },
    );
  }
}