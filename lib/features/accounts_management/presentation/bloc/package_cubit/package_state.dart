
abstract class PackageState {}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageSuccess extends PackageState {
  final List packages;
  final DateTime? startDate;
  final DateTime? endDate;

  PackageSuccess({
    required this.packages,
    required this.startDate,
    required this.endDate,
  });
}

class PackageError extends PackageState {
  final String message;
  PackageError(this.message);
}

