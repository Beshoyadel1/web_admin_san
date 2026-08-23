import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/features/warranty/data/datasource/create_approval_info_datasource/create_approval_info_datasource.dart';
import 'package:web_admin_san/features/warranty/data/datasource/get_approval_info_by_id_datasource/get_approval_info_by_id_datasource.dart';
import 'package:web_admin_san/features/warranty/data/datasource/get_approvals_datasource/get_approvals_datasource.dart';
import 'package:web_admin_san/features/warranty/data/datasource/update_approval_info_datasource/update_approval_info_datasource.dart';

import 'package:web_admin_san/features/warranty/data/model/warranty_model/warranty_model.dart';

import 'package:web_admin_san/features/warranty/data/request/get_approval_info_by_id_request/get_approval_info_by_id_request.dart';

import 'warranty_state.dart';

class WarrantyCubit extends Cubit<WarrantyState> {
  WarrantyCubit() : super(const WarrantyInitial());

  List<WarrantyModel> warranties = [];

  WarrantyModel? warranty;

  // =========================================================
  // GET ALL
  // =========================================================

  Future<void> getApprovals() async {
    if (isClosed) return;

    emit(
      const WarrantyLoading(),
    );

    try {
      final result = await getApprovalsFunction();

      if (isClosed) return;

      if (result != null) {
        warranties = result;

        emit(
          WarrantySuccess(
            warranties,
          ),
        );
      } else {
        emit(
          const WarrantyError(
            'Failed to get warranties',
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;

      emit(
        WarrantyError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  // =========================================================
  // GET BY ID
  // =========================================================

  Future<void> getApprovalInfoById({
    required int id,
  }) async {
    if (isClosed) return;

    emit(
      const WarrantyLoading(),
    );

    try {
      final result = await getApprovalInfoByIdFunction(
        request: GetApprovalInfoByIdRequest(
          id: id,
        ),
      );

      if (isClosed) return;

      warranty = result;

      emit(
        WarrantyDetailsSuccess(
          result,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        WarrantyError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  // =========================================================
  // CREATE
  // =========================================================

  Future<void> createWarranty({
    required WarrantyModel warrantyModel,
  }) async {
    if (isClosed) return;

    emit(const WarrantyCreateLoading());

    try {
      final result = await createApprovalInfoFunction(
        warrantyModel: warrantyModel,
      );

      if (isClosed) return;

      warranty = result;

      emit(
        WarrantyCreateSuccess(
          result,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        WarrantyCreateError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  // =========================================================
  // UPDATE
  // =========================================================

  Future<void> updateWarranty({
    required WarrantyModel warrantyModel,
  }) async {
    if (isClosed) return;

    final id = warrantyModel.id;

    if (id == null || id <= 0) {
      emit(
        const WarrantyUpdateError(
          'Warranty ID is required for update',
        ),
      );

      return;
    }

    emit(
      const  WarrantyUpdateLoading(),
    );

    try {
      final result = await updateApprovalInfoFunction(
        warrantyModel: warrantyModel,
      );

      if (isClosed) return;

      warranty = result;

      emit(
        WarrantyUpdateSuccess(
          result,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        WarrantyUpdateError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
}