import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/providers/data/datasource/facility_provider_datasource/add_branch_datasource/add_branch_repository.dart';
import 'package:web_admin_san/features/providers/data/datasource/facility_provider_datasource/get_provider_branches_datasource/get_provider_branches_repository.dart';
import 'package:web_admin_san/features/providers/data/datasource/facility_provider_datasource/update_branch_datasource/update_branch_repository.dart';
import 'package:web_admin_san/features/providers/data/model/facility_provider_model/get_provider_branches_model/provider_branch_model.dart';
import 'package:web_admin_san/features/providers/data/request/facility_provider_request/add_branch_request/add_branch_request.dart';
import 'package:web_admin_san/features/providers/data/request/facility_provider_request/get_provider_branches_request/get_provider_branches_request.dart';
import '../../../../../../../../features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'branch_state.dart';

class BranchCubit extends Cubit<BranchState> {
  BranchCubit() : super(BranchInitial());

  List<ProviderBranchModel> branches = [];

  Future<void> getProviderBranches({
     required int providerId,
  }) async {
    emit(BranchLoading());

    try {
      branches = await getProviderBranchesFunction(
        getProviderBranchesRequest: GetProviderBranchesRequest(
          providerId: providerId,
        ),
      );

      emit(
        BranchSuccess(
          branches: branches,
        ),
      );
    } catch (e) {
      final error = e.toString().replaceAll("Exception: ", "");

      if (error.contains("غير موجود")) {
        emit(
          BranchSuccess(
            branches: [],
          ),
        );
        return;
      }

      emit(BranchError(error));
    }
  }

  void goToAdd() {
    final current = state as BranchSuccess;

    emit(
      current.copyWith(
        isAdding: true,
        editingBranchId: null,
        fromSubmit: false,
      ),
    );
  }

  void edit(int branchId) {
    final current = state as BranchSuccess;

    emit(
      current.copyWith(
        isAdding: true,
        editingBranchId: branchId,
        fromSubmit: false,
      ),
    );
  }

  void back() {
    final current = state as BranchSuccess;

    emit(
      current.copyWith(
        isAdding: false,
        editingBranchId: null,
        fromSubmit: false,
      ),
    );
  }

  Future<void> addBranch(
      AddBranchRequest request, {
         required int providerId,
      }) async {
    try {
      final body = request.toJson(providerId);

      final response = await addBranchFunction(
        body: body,
      );

      final responseData = response.data;

      if (!(responseData["success"] ?? false)) {
        throw Exception(
          responseData["message"] ?? "Something went wrong",
        );
      }

      await getProviderBranches(
        providerId: providerId,
      );
    } catch (e) {
      emit(
        BranchError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updateBranch(
      AddBranchRequest request, {
         required int providerId,
      }) async {
    try {
      final body = request.toJson(providerId);

      final response = await updateBranchFunction(
        body: body,
      );

      final responseData = response.data;

      if (!(responseData["success"] ?? false)) {
        throw Exception(
          responseData["message"] ?? "Something went wrong",
        );
      }

      await getProviderBranches(
        providerId: providerId,
      );
    } catch (e) {
      emit(
        BranchError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> deleteBranch(
      int branchId, {
         required int providerId,
      }) async {
    try {
      final request = AddBranchRequest(
        branchId: branchId,
        isActive: false,
      );

      final response = await updateBranchFunction(
        body: request.toJson(providerId),
      );

      final responseData = response.data;

      if (!(responseData["success"] ?? false)) {
        throw Exception(
          responseData["message"] ?? "Delete failed",
        );
      }

      await getProviderBranches(
        providerId: providerId,
      );
    } catch (e) {
      emit(
        BranchError(
          e.toString(),
        ),
      );
    }
  }
}
