import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/feature/cars_haraj_page/data/request/get_all_harage_request/get_all_harage_request.dart';
import '../../data/datasource/get_all_harage_datasource/get_all_harage_repository.dart';
import 'get_all_harage_state.dart';

class GetAllHarageCubit extends Cubit<GetAllHarageState> {
  GetAllHarageCubit() : super(GetAllHarageInitial());

  Future<void> getAllHarage({int page = 1}) async {
    if (isClosed) return;

    emit(GetAllHarageLoading());

    try {
      final request = GetAllHarageRequest(
        pageNumber: page,
      );

      final result = await getAllHarageFunction(
        getAllHarageRequest: request,
      );

      if (isClosed) return;

      final currentPage = result.currentPage;
      final pageCount = result.pageCount;
      final totalCount = result.totalCount;

      emit(
        GetAllHarageSuccess(
          response: result,
          currentPage: currentPage,
          pageCount: pageCount,
          totalCount: totalCount,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(GetAllHarageError(e.toString()));
    }
  }
}
