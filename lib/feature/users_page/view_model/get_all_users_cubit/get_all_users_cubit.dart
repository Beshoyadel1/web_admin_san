import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/users_page/data/datasource/get_all_users_datasource/get_all_users_datasource.dart';
import 'package:web_admin_san/feature/users_page/data/request/get_all_user_request/get_all_user_request.dart';

import 'get_all_users_state.dart';

class GetAllUsersCubit extends Cubit<GetAllUsersState> {
  GetAllUsersCubit() : super(GetAllUsersInitial());

  String? currentSearch;
  bool? currentIsActive;
  DateTime? currentStartDate;
  DateTime? currentEndDate;

  Future<void> getAllUsers({
    required int currentPage,
    String? searchTerm,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    bool updateFilters = false,
  }) async {
    if (updateFilters) {
      currentSearch = searchTerm;
      currentIsActive = isActive;
      currentStartDate = startDate;
      currentEndDate = endDate;
    } else {
      currentSearch = searchTerm ?? currentSearch;
      currentIsActive = isActive ?? currentIsActive;
      currentStartDate = startDate ?? currentStartDate;
      currentEndDate = endDate ?? currentEndDate;
    }

    if (isClosed) return;
    emit(GetAllUsersLoading());

    try {
      final result = await getAllUsersFunction(
        request: GetAllUserRequest(
          pageNumber: currentPage,
          searchTerm: currentSearch,
          isActive: currentIsActive,
          startDate: currentStartDate,
          endDate: currentEndDate,
        ),
      );

      if (isClosed) return;
      emit(
        GetAllUsersSuccess(
          users: result.users,
          currentPage: result.currentPage,
          pageCount: result.pageCount,
          totalCount: result.totalCount,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        GetAllUsersError(
          e.toString(),
        ),
      );
    }
  }
}
