import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/delivery_setting_datasource.dart';
import '../../data/model/delivery_order_model.dart';
import 'delivery_setting_state.dart';

class DeliverySettingCubit extends Cubit<DeliverySettingState> {
  final DeliverySettingDatasource datasource;

  DeliverySettingCubit({required this.datasource})
      : super(const DeliverySettingState());

  /// Loads delivery info and paginated orders
  Future<void> loadData({bool isRefresh = false}) async {
    if (isClosed) return;
    if (!isRefresh && state.viewStatus != DeliveryViewStatus.success) {
      emit(state.copyWith(
        viewStatus: DeliveryViewStatus.loading,
        clearActionMessages: true,
      ));
    }

    try {
      final info = await datasource.getDeliveryInfo();

      DeliveryOrderPaginatedResponse? orders;
      try {
        orders = await datasource.getDeliveryOrders(
          pageNumber: state.currentPage,
          pageSize: 10,
          status: state.selectedStatusFilter,
          search: state.searchQuery,
        );
      } catch (_) {
        orders = state.ordersResponse ??
            const DeliveryOrderPaginatedResponse(
              data: [],
              totalCount: 0,
              pageCount: 1,
              currentPage: 1,
            );
      }

      if (isClosed) return;

      emit(state.copyWith(
        viewStatus: DeliveryViewStatus.success,
        deliveryInfo: info,
        ordersResponse: orders,
        isLoadingOrders: false,
        clearActionMessages: true,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        viewStatus: DeliveryViewStatus.error,
        isLoadingOrders: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Fetches orders specifically for pagination, status filter, and search
  Future<void> fetchOrders({
    int? page,
    String? status,
    String? search,
  }) async {
    if (isClosed) return;

    final targetPage = page ?? state.currentPage;
    final targetStatus = status ?? state.selectedStatusFilter;
    final targetSearch = search ?? state.searchQuery;

    emit(state.copyWith(
      isLoadingOrders: true,
      currentPage: targetPage,
      clearActionMessages: true,
    ));

    try {
      final orders = await datasource.getDeliveryOrders(
        pageNumber: targetPage,
        pageSize: 10,
        status: targetStatus,
        search: targetSearch,
      );

      if (isClosed) return;
      emit(state.copyWith(
        isLoadingOrders: false,
        ordersResponse: orders,
        currentPage: targetPage,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        isLoadingOrders: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Updates settings and refreshes metrics
  Future<void> updateSettings({
    required double deliveryCost,
    required double deliveryPrice,
    required bool isDeliveryEnabled,
    String lang = 'ar',
  }) async {
    if (isClosed) return;
    emit(state.copyWith(
      isUpdatingSettings: true,
      clearActionMessages: true,
    ));

    try {
      final message = await datasource.updateDeliverySetting(
        deliveryCost: deliveryCost,
        deliveryPrice: deliveryPrice,
        isDeliveryEnabled: isDeliveryEnabled,
        lang: lang,
      );

      final updatedInfo = await datasource.getDeliveryInfo();
      if (isClosed) return;

      emit(state.copyWith(
        isUpdatingSettings: false,
        deliveryInfo: updatedInfo,
        successActionMessage: message,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        isUpdatingSettings: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Changes search filter and reloads orders from page 1
  void setSearchQuery(String query) {
    if (state.searchQuery == query) return;
    emit(state.copyWith(
      searchQuery: query,
      currentPage: 1,
      clearActionMessages: true,
    ));
    fetchOrders(page: 1, search: query);
  }

  /// Filters orders by status and reloads orders from page 1
  void setStatusFilter(String? status) {
    if (status == null || status.isEmpty) {
      emit(state.copyWith(
        clearStatusFilter: true,
        currentPage: 1,
        clearActionMessages: true,
      ));
      fetchOrders(page: 1, status: '');
    } else {
      emit(state.copyWith(
        selectedStatusFilter: status,
        currentPage: 1,
        clearActionMessages: true,
      ));
      fetchOrders(page: 1, status: status);
    }
  }

  /// Changes pagination page
  void changePage(int page) {
    if (state.currentPage == page && !state.isLoadingOrders) return;
    fetchOrders(page: page);
  }

  /// Cancels an active delivery order
  Future<void> cancelOrder({
    required int orderId,
    required String reason,
    String lang = 'ar',
  }) async {
    if (isClosed) return;
    emit(state.copyWith(
      isCancellingOrder: true,
      clearActionMessages: true,
    ));

    try {
      final message = await datasource.cancelDeliveryOrder(
        orderId: orderId,
        reason: reason,
        lang: lang,
      );

      if (isClosed) return;
      emit(state.copyWith(
        isCancellingOrder: false,
        successActionMessage: message,
      ));
      loadData(isRefresh: true);
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        isCancellingOrder: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void clearActionMessages() {
    if (isClosed) return;
    emit(state.copyWith(clearActionMessages: true));
  }
}
