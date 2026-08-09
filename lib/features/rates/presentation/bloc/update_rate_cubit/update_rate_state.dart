part of 'update_rate_cubit.dart';

abstract class UpdateRateState {}

class UpdateRateInitial extends UpdateRateState {}

class UpdateRateLoading extends UpdateRateState {}

class UpdateRateSuccess extends UpdateRateState {
  final String message;

  UpdateRateSuccess({
    required this.message,
  });
}

class UpdateRateError extends UpdateRateState {
  final String message;

  UpdateRateError({
    required this.message,
  });
}