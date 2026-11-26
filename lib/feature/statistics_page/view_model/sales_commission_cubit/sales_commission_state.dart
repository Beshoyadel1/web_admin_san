import 'package:equatable/equatable.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/sales_commission_model.dart';

abstract class SalesCommissionState extends Equatable {
  const SalesCommissionState();

  @override
  List<Object?> get props => [];
}

class SalesCommissionInitial extends SalesCommissionState {}

class SalesCommissionLoading extends SalesCommissionState {}

class SalesCommissionSuccess extends SalesCommissionState {
  final AdminSalesAndCommissionModel data;
  final DateTime? startDate;
  final DateTime? endDate;

  const SalesCommissionSuccess({
    required this.data,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [data, startDate, endDate];
}

class SalesCommissionError extends SalesCommissionState {
  final String message;

  const SalesCommissionError(this.message);

  @override
  List<Object?> get props => [message];
}
