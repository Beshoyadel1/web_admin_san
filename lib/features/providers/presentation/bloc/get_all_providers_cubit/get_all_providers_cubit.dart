import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/providers/data/datasource/get_all_providers_datasource/get_all_providers_datasource.dart';
import 'package:web_admin_san/features/providers/data/request/get_all_providers_request/get_all_providers_request.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/get_all_providers_cubit/get_all_providers_state.dart';

class GetAllProvidersCubit extends Cubit<GetAllProvidersState> {
  GetAllProvidersCubit() : super(GetAllProvidersInitial());

  Future<void> getAllProviders({
    required int currentPage,
  }) async {
    if (isClosed) return;

    emit(GetAllProvidersLoading());

    try {
      final result = await getAllProvidersFunction(
        request: GetAllProvidersRequest(
          pageNumber: currentPage,
        ),
      );

      if (isClosed) return;

      emit(
        GetAllProvidersSuccess(
          providers: result.providers,
          currentPage: result.currentPage,
          pageCount: result.pageCount,
          totalCount: result.totalCount,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        GetAllProvidersError(
          e.toString(),
        ),
      );
    }
  }
}