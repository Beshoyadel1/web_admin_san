import 'package:equatable/equatable.dart';
import '../../data/model/settlement_model/settlement_model.dart';

abstract class SettlementState extends Equatable {
  const SettlementState();

  @override
  List<Object?> get props => [];
}

class SettlementInitial extends SettlementState {
  const SettlementInitial();
}

class SettlementLoading extends SettlementState {
  const SettlementLoading();
}

class SettlementSuccess extends SettlementState {
  final List<SettlementModel> settlements;

  const SettlementSuccess(this.settlements);

  @override
  List<Object?> get props => [settlements];
}

class SettlementError extends SettlementState {
  final String message;

  const SettlementError(this.message);

  @override
  List<Object?> get props => [message];
}

class SettlementActionLoading extends SettlementState {
  const SettlementActionLoading();
}

class SettlementActionSuccess extends SettlementState {
  final String message;

  const SettlementActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SettlementActionError extends SettlementState {
  final String message;

  const SettlementActionError(this.message);

  @override
  List<Object?> get props => [message];
}
