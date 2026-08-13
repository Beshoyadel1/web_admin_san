import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/features/approved_centers/data/datasource/toggle_provider_approval_status_datasource/toggle_provider_approval_status_datasource.dart';
import 'package:web_admin_san/features/approved_centers/data/request/toggle_provider_approval_status_request/toggle_provider_approval_status_request.dart';
import 'package:web_admin_san/features/approved_centers/presentation/bloc/toggle_provider_approval_status_cubit/toggle_provider_approval_status_state.dart';

class ToggleProviderApprovalStatusCubit
    extends Cubit<ToggleProviderApprovalStatusState> {
  ToggleProviderApprovalStatusCubit()
      : super(ToggleProviderApprovalStatusInitial());

  bool? currentApprovalStatus;

  void setInitialStatus(bool value) {
    currentApprovalStatus ??= value;
  }

  Future<void> toggleProviderApprovalStatus({
    required int providerId,
    required bool isActive,
    String lang = 'ar',
  }) async {
    if (isClosed) return;

    emit(
      ToggleProviderApprovalStatusLoading(),
    );

    try {
      final request =
      ToggleProviderApprovalStatusRequest(
        providerId: providerId,
        isActive: isActive,
        lang: lang,
      );

      final result =
      await toggleProviderApprovalStatusFunction(
        request: request,
      );

      if (isClosed) return;

      // =========================
      // SUCCESS
      // =========================

      if (result?.success == true) {
        currentApprovalStatus = isActive;

        emit(
          ToggleProviderApprovalStatusSuccess(
            result: result!,
            isApproved: isActive,
          ),
        );

        return;
      }

      // =========================
      // API FAILED
      // =========================

      emit(
        ToggleProviderApprovalStatusError(
          message: result?.message ??
              'Something went wrong',
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        ToggleProviderApprovalStatusError(
          message: e.toString(),
        ),
      );
    }
  }
}