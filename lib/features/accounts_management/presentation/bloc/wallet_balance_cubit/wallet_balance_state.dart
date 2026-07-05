abstract class WalletBalanceState {}

class WalletBalanceInitial extends WalletBalanceState {}

class WalletBalanceLoading extends WalletBalanceState {}

class WalletBalanceSuccess extends WalletBalanceState {
  final double balance;

  WalletBalanceSuccess(this.balance);
}

class WalletBalanceError extends WalletBalanceState {
  final String message;

  WalletBalanceError(this.message);
}