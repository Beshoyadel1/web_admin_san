import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/cars_haraj_page/data/datasource/get_harage_providers_datasource/get_harage_providers_datasource.dart';
import 'package:web_admin_san/features/cars_haraj_page/data/request/get_harage_providers_request/get_harage_providers_request.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/bloc/get_harage_providers_cubit/get_harage_providers_state.dart';

class GetHarageProvidersCubit extends Cubit<GetHarageProvidersState> {
  GetHarageProvidersCubit() : super(GetHarageProvidersInitial());

  Future<void> getAllHarahProviders({
    required int currentPage,
  }) async {
    emit(GetHarageProvidersLoading());

    try {
      final result = await getHarageProviders(
        request: GetHarageProvidersRequest(
          pageNumber: currentPage,
        ),
      );

      emit(
        GetHarageProvidersSuccess(
          providers: result.providers,
          currentPage: result.currentPage,
          pageCount: result.pageCount,
          totalCount: result.totalCount,
        ),
      );
    } catch (e) {
      print("ERROR = $e");

      emit(
        GetHarageProvidersError(
          e.toString(),
        ),
      );
    }
  }
}