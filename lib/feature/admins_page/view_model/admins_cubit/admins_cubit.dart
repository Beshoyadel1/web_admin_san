import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/feature/admins_page/data/datasource/get_all_admins_datasource/get_all_admins_datasource.dart';
import 'package:web_admin_san/feature/admins_page/data/request/get_all_admins_request/get_all_admins_request.dart';
import 'package:web_admin_san/feature/auth_page/data/datasource/create_user_datasource/create_user_repository.dart';

import 'package:web_admin_san/feature/auth_page/data/datasource/update_user_datasource/update_user_repository.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/admin_details_request.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';

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
        gender: request.gender,
        birthDate: request.birthDate,
        nationality: request.nationality,
        type: 6,
        isActive: request.isActive ?? true,
        adminDetails: request.adminDetails ?? const AdminDetailsRequest(),
      );

      final result = await createUserFunction(
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

  String? _searchTerm;
  bool? _isActive;
  DateTime? _startDate;
  DateTime? _endDate;

  String? get searchTerm => _searchTerm;
  bool? get isActive => _isActive;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  Future<void> getAllAdmins({
    required int currentPage,
    String? searchTerm,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    bool updateFilters = false,
  }) async {
    if (isClosed) return;

    if (updateFilters) {
      _searchTerm = searchTerm;
      _isActive = isActive;
      _startDate = startDate;
      _endDate = endDate;
    }

    emit(const AdminsLoading());

    try {
      final result = await getAllAdminsFunction(
        request: GetAllAdminsRequest(
          pageNumber: currentPage,
          searchTerm: _searchTerm,
          isActive: _isActive,
          startDate: _startDate,
          endDate: _endDate,
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
        birthDate: request.birthDate,

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
