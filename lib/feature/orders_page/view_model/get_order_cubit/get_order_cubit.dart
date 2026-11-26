import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/orders_page/data/datasource/get_orders_datasource/get_orders_repository.dart';
import 'package:web_admin_san/feature/orders_page/data/request/get_orders_request/get_orders_request.dart';

import 'get_order_state.dart';

class GetOrderCubit extends Cubit<GetOrderState> {
  GetOrderCubit() : super(GetOrderInitial());

  int? currentOrderType;
  int? currentUserType;
  String? currentSearch;
  DateTime? currentStartDate;
  DateTime? currentEndDate;

  Future<void> getOrders({
    int? orderType,
    int? userType,
    int? pageNumber,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    bool updateFilters = false,
  }) async {
    if (updateFilters) {
      currentOrderType = orderType;
      currentUserType = userType;
      currentSearch = search;
      currentStartDate = startDate;
      currentEndDate = endDate;
    } else {
      currentOrderType = orderType ?? currentOrderType;
      currentUserType = userType ?? currentUserType;
      currentSearch = search ?? currentSearch;
      currentStartDate = startDate ?? currentStartDate;
      currentEndDate = endDate ?? currentEndDate;
    }

    if (!isClosed) {
      emit(GetOrderLoading());
    }
    try {
      final response = await getOrdersFunction(
        request: GetOrdersRequest(
          pageNumber: pageNumber ?? 1,
          orderType: currentOrderType,
          userType: currentUserType,
          search: currentSearch,
          startDate: currentStartDate,
          endDate: currentEndDate,
        ),
      );
      if (!isClosed) {
        emit(
          GetOrderSuccess(
            response.orders,
            currentPage: response.currentPage,
            pageCount: response.pageCount,
            totalCount: response.totalCount,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(GetOrderError(e.toString()));
      }
    }
  }
}
