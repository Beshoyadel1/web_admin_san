import 'package:equatable/equatable.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/most_requested_service_model.dart';

abstract class MostRequestedServicesState extends Equatable {
  const MostRequestedServicesState();

  @override
  List<Object?> get props => [];
}

class MostRequestedServicesInitial extends MostRequestedServicesState {}

class MostRequestedServicesLoading extends MostRequestedServicesState {}

class MostRequestedServicesSuccess extends MostRequestedServicesState {
  final List<MostRequestedServiceModel> services;
  final DateTime? startDate;
  final DateTime? endDate;

  const MostRequestedServicesSuccess({
    required this.services,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [services, startDate, endDate];
}

class MostRequestedServicesError extends MostRequestedServicesState {
  final String message;

  const MostRequestedServicesError(this.message);

  @override
  List<Object?> get props => [message];
}
