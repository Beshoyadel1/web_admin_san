import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../features/cars_haraj_page/data/datasource/get_user_harages_datasource/get_user_harages_datasource.dart';
import '../../../../../../../features/cars_haraj_page/data/request/get_user_harages_request/get_user_harages_request.dart';

import '../../../../../core/api/dio_function/failures.dart';
import '../../../../auth_page/data/datasource/login_datasource/login_repository.dart';

import 'get_user_harages_state.dart';

class GetUserHaragesCubit extends Cubit<GetUserHaragesState> {
  GetUserHaragesCubit()
      : super(GetUserHaragesInitial());

  Future<void> getUserHarages({
    required int userId,
    int? userType,
    int pageNumber = 1,
  }) async {
    if (isClosed) return;

    emit(GetUserHaragesLoading());

    try {
      final response = await getUserHaragesFunction(
        request: GetUserHaragesRequest(
          userId: userId,
          userType: 4,
          pageNumber: pageNumber,
        ),
      );

      if (isClosed) return;

      emit(
        GetUserHaragesSuccess(
          response.data,
          currentPage: response.currentPage,
          pageCount: response.pageCount,
          totalCount: response.totalCount,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        GetUserHaragesError(
          e is DioException
              ? responseOfStatusCode(e.response?.statusCode)
              : e.toString(),
        ),
      );
    }
  }
}