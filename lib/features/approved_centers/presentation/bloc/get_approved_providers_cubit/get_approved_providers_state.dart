import 'package:web_admin_san/features/approved_centers/data/model/get_approved_providers_model/get_approved_providers_model.dart';

abstract class GetApprovedProvidersState {
  const GetApprovedProvidersState();
}

class GetApprovedProvidersInitial
    extends GetApprovedProvidersState {}

class GetApprovedProvidersLoading
    extends GetApprovedProvidersState {}

class GetApprovedProvidersSuccess
    extends GetApprovedProvidersState {
  final GetApprovedProvidersResponse data;

  const GetApprovedProvidersSuccess({
    required this.data,
  });
}

class GetApprovedProvidersError
    extends GetApprovedProvidersState {
  final String message;

  const GetApprovedProvidersError({
    required this.message,
  });
}