import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/settlement_datasource/settlement_datasource.dart';
import '../../data/model/settlement_model/settlement_model.dart';
import '../../data/request/create_settlement_request/create_settlement_request.dart';
import 'settlement_state.dart';

class SettlementCubit extends Cubit<SettlementState> {
  final SettlementDatasource datasource;
  List<SettlementModel> settlements = [];

  SettlementCubit({
    this.datasource = const SettlementDatasource(),
  }) : super(const SettlementInitial());

  /// Loads settlement history for a specific provider
  Future<void> loadProviderSettlements({required int providerId}) async {
    emit(const SettlementLoading());
    try {
      final list =
          await datasource.getProviderSettlements(providerId: providerId);
      settlements = list;
      if (isClosed) return;
      emit(SettlementSuccess(list));
    } catch (e) {
      if (isClosed) return;
      emit(SettlementError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  /// Creates and executes a settlement transaction
  Future<bool> createSettlement({
    required CreateSettlementRequest request,
    required int providerId,
  }) async {
    emit(const SettlementActionLoading());
    try {
      final message = await datasource.createSettlement(request: request);
      if (isClosed) return true;
      emit(SettlementActionSuccess(message));
      // Refresh the settlement list
      await loadProviderSettlements(providerId: providerId);
      return true;
    } catch (e) {
      if (isClosed) return false;
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      emit(SettlementActionError(errorMsg));
      return false;
    }
  }
}
