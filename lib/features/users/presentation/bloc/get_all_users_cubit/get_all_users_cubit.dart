import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/users/data/datasource/get_all_users_datasource/get_all_users_datasource.dart';
import 'package:web_admin_san/features/users/data/request/get_all_user_request/get_all_user_request.dart';
import 'get_all_users_state.dart';

class GetAllUsersCubit extends Cubit<GetAllUsersState> {
  GetAllUsersCubit() : super(GetAllUsersInitial());

  Future<void> getAllUsers({
    required int currentPage,
  }) async {
    emit(GetAllUsersLoading());

    try {
      final result = await getAllUsersFunction(
        request: GetAllUserRequest(
          pageNumber: currentPage,
        ),
      );

      emit(
        GetAllUsersSuccess(
          users: result.users,
          currentPage: result.currentPage,
          pageCount: result.pageCount,
          totalCount: result.totalCount,
        ),
      );
    } catch (e) {
      print("ERROR = $e");

      emit(
        GetAllUsersError(
          e.toString(),
        ),
      );
    }
  }
}