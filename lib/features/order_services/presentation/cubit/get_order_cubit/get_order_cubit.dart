import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/order_services/data/datasource/get_orders_datasource/get_orders_repository.dart';
import 'package:web_admin_san/features/order_services/data/request/get_orders_request/get_orders_request.dart';
import 'get_order_state.dart';

class GetOrderCubit extends Cubit<GetOrderState> {
  GetOrderCubit() : super(GetOrderInitial());

  Future<void> getOrders({
    int? orderType,
    int? pageNumber,
  }) async {

    if (!isClosed) {
      emit(GetOrderLoading());
    }
    try {

      final response = await getOrdersFunction(
        request: GetOrdersRequest(
          pageNumber: pageNumber,
          orderType: orderType
        ),
      );
      if (!isClosed) {
        emit(
          GetOrderSuccess(
            response.orders ?? [],
            currentPage: response.currentPage ?? 1,
            pageCount: response.pageCount ?? 1,
            totalCount: response.totalCount ?? 1,
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


