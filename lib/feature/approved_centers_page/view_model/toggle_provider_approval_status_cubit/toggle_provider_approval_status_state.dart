import 'package:web_admin_san/feature/approved_centers_page/data/model/toggle_provider_approval_status_model/toggle_provider_approval_status_model.dart';

abstract class ToggleProviderApprovalStatusState {
  const ToggleProviderApprovalStatusState();
}

class ToggleProviderApprovalStatusInitial
    extends ToggleProviderApprovalStatusState {}

class ToggleProviderApprovalStatusLoading
    extends ToggleProviderApprovalStatusState {}

class ToggleProviderApprovalStatusSuccess
    extends ToggleProviderApprovalStatusState {
  final ToggleProviderApprovalStatusModel result;
  final bool isApproved;

  const ToggleProviderApprovalStatusSuccess({
    required this.result,
    required this.isApproved,
  });
}

class ToggleProviderApprovalStatusError
    extends ToggleProviderApprovalStatusState {
  final String message;

  const ToggleProviderApprovalStatusError({
    required this.message,
  });
}
