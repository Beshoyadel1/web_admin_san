import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/approved_centers/data/datasource/get_approved_providers_datasource/get_approved_providers_datasource.dart';
import 'package:web_admin_san/features/approved_centers/data/model/get_approved_providers_model/get_approved_providers_model.dart';
import 'package:web_admin_san/features/approved_centers/data/request/get_approved_providers_request/get_approved_providers_request.dart';

import 'get_approved_providers_state.dart';

class GetApprovedProvidersCubit
    extends Cubit<GetApprovedProvidersState> {
  GetApprovedProvidersCubit()
      : super(GetApprovedProvidersInitial());

  int currentPage = 1;

  Future<void> getApprovedProviders({
    int pageNumber = 1,
  }) async {
    if (isClosed) return;

    emit(GetApprovedProvidersLoading());

    try {
      final request = GetApprovedProvidersRequest(
        pageNumber: pageNumber,
      );

      final result =
      await getApprovedProvidersFunction(
        request: request,
      );

      if (isClosed) return;

      currentPage = pageNumber;

      emit(
        GetApprovedProvidersSuccess(
          data: result,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        GetApprovedProvidersError(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> getNextPage() async {
    await getApprovedProviders(
      pageNumber: currentPage + 1,
    );
  }

  Future<void> refresh() async {
    currentPage = 1;

    await getApprovedProviders(
      pageNumber: 1,
    );
  }
}