import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/users/data/datasource/get_user_details_datasource/get_user_details_datasource.dart';
import 'package:web_admin_san/features/users/data/model/user_details_model/user_details_model.dart';
import 'package:web_admin_san/features/users/data/request/get_user_details_request/get_user_details_request.dart';

import 'user_details_state.dart';

class UserDetailsCubit
    extends Cubit<UserDetailsState> {
  UserDetailsCubit()
      : super(UserDetailsInitial());

  UserDetailsResponse? userDetails;

  Future<void> getUserDetails({
    required int userId,
  }) async {
    emit(UserDetailsLoading());

    try {
      userDetails =
      await getUserDetailsFunction(
        request: GetUserDetailsRequest(
          userId: userId,
        ),
      );

      emit(
        UserDetailsSuccess(
          userDetails!,
        ),
      );
    } catch (e) {
      emit(
        UserDetailsFailure(
          e.toString(),
        ),
      );
    }
  }
}