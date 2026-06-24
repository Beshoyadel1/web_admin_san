import 'package:web_admin_san/features/cars_haraj_page/data/model/get_harage_providers_models/get_harage_providers_models.dart';

abstract class GetHarageProvidersState {}

class GetHarageProvidersInitial extends GetHarageProvidersState {}

class GetHarageProvidersLoading extends GetHarageProvidersState {}

class GetHarageProvidersSuccess extends GetHarageProvidersState {
  final List<GetAllProviderHarag> providers;
  final int currentPage;
  final int pageCount;
  final int totalCount;

  GetHarageProvidersSuccess({
    required this.providers,
    required this.currentPage,
    required this.pageCount,
    required this.totalCount,
  });
}

class GetHarageProvidersError extends GetHarageProvidersState {
  final String error;

  GetHarageProvidersError(this.error);
}