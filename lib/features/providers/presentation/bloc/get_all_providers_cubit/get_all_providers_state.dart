import 'package:web_admin_san/features/providers/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';

abstract class GetAllProvidersState {}

class GetAllProvidersInitial
    extends GetAllProvidersState {}

class GetAllProvidersLoading
    extends GetAllProvidersState {}

class GetAllProvidersSuccess
    extends GetAllProvidersState {
  final List<GetAllProvidersModels> providers;
  final int currentPage;
  final int pageCount;
  final int totalCount;

  GetAllProvidersSuccess({
    required this.providers,
    required this.currentPage,
    required this.pageCount,
    required this.totalCount,
  });
}

class GetAllProvidersError
    extends GetAllProvidersState {
  final String error;

  GetAllProvidersError(this.error);
}