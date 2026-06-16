import 'package:equatable/equatable.dart';
import 'package:web_admin_san/features/internal_services/data/model/get_provider_orders_model/order_model.dart';

abstract class GetOrderState extends Equatable {
  const GetOrderState();

  @override
  List<Object?> get props => [];
}

class GetOrderInitial extends GetOrderState {}

class GetOrderLoading extends GetOrderState {}

class GetOrderSuccess extends GetOrderState {
  final List<OrderModel> orders;
  final int currentPage;
  final int pageCount;
  final int totalCount;

  const GetOrderSuccess(
      this.orders, {
        this.currentPage = 1,
        this.pageCount = 1,
        this.totalCount = 0,
      });

  @override
  List<Object?> get props => [orders, currentPage, pageCount, totalCount];
}

class GetOrderError extends GetOrderState {
  final String message;

  const GetOrderError(this.message);

  @override
  List<Object?> get props => [message];
}