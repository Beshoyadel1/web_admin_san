import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/features/admins/data/datasource/get_all_admins_datasource/get_all_admins_datasource.dart';
import 'package:web_admin_san/features/admins/data/request/get_all_admins_request/get_all_admins_request.dart';

import 'package:web_admin_san/features/auth_page/data/datasource/update_user_datasource/update_user_repository.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/admin_details_request.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/create_user_request.dart';

import 'admins_state.dart';

class AdminsCubit extends Cubit<AdminsState> {
  AdminsCubit() : super(const AdminsInitial());

  Future<void> createAdmin(
      CreateUserRequest request,
      ) async {
    if (isClosed) return;

    emit(const AdminsCreateLoading());

    try {
      final createRequest = CreateUserRequest(
        username: request.username,
        phone: request.phone,
        email: request.email,
        password: request.password,

        // Admin
        type: 6,

        adminDetails: const AdminDetailsRequest(),
        // Required by your signup logic
        fcmToken: request.fcmToken ?? '',
      );

      final result = await updateUserFunction(
        createUserRequest: createRequest,
      );

      if (isClosed) return;

      if (result.success) {
        emit(
          AdminsCreateSuccess(
            message: result.message,
          ),
        );
      } else {
        emit(
          AdminsCreateError(
            error: result.message,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;

      emit(
        AdminsCreateError(
          error: e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
  // ============================================================
  // GET ALL ADMINS
  // ============================================================

  Future<void> getAllAdmins({
    required int currentPage,
  }) async {
    if (isClosed) return;

    emit(const AdminsLoading());

    try {
      final result = await getAllAdminsFunction(
        request: GetAllAdminsRequest(
          pageNumber: currentPage,
        ),
      );

      if (isClosed) return;

      emit(
        AdminsSuccess(
          admins: result.admins,
          currentPage: result.currentPage ?? currentPage,
          pageCount: result.pageCount ?? 1,
          totalCount: result.totalCount ?? 0,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        AdminsError(
          error: e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  // ============================================================
  // UPDATE ADMIN
  // ============================================================

  Future<void> updateAdmin(
      CreateUserRequest request,
      ) async {
    if (isClosed) return;

    emit(const AdminsUpdateLoading());

    try {
      // ========================================================
      // ADMIN IS ALWAYS TYPE 6
      // ========================================================

      final updateRequest = CreateUserRequest(
        userid: request.userid,

        username: request.username,
        phone: request.phone,
        email: request.email,
        password: request.password,

        gender: request.gender,
        age: request.age,

        // Admin user type
        type: 6,

        nationality: request.nationality,
        isActive: request.isActive,
        joinDate: request.joinDate,
        referralCode: request.referralCode,
        image: request.image,
        fcmToken: request.fcmToken,
        currentCarId: request.currentCarId,

        // Admin data
        adminDetails: request.adminDetails,

        // Keep other existing details if they exist
        providerDetails: request.providerDetails,
        companyDetails: request.companyDetails,
        driverDetails: request.driverDetails,
      );

      // ========================================================
      // DEBUG
      // ========================================================

      print('========== UPDATE ADMIN ==========');
      print('Admin ID: ${updateRequest.userid}');
      print('User Type: ${updateRequest.type}');

      // ========================================================
      // API
      // ========================================================

      final result = await updateUserFunction(
        createUserRequest: updateRequest,
      );

      if (isClosed) return;

      if (result.success) {
        emit(
          AdminsUpdateSuccess(
            message: result.message,
          ),
        );

        return;
      }

      emit(
        AdminsUpdateError(
          error: result.message,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        AdminsUpdateError(
          error: e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
}