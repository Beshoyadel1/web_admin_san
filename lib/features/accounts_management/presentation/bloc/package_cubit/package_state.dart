import 'package:web_admin_san/features/packages/data/model/get_packages_model/get_packages_model.dart';

abstract class PackageState {
  const PackageState();
}


class PackageInitial extends PackageState {
  const PackageInitial();
}


class PackageLoading extends PackageState {
  const PackageLoading();
}


class PackageSuccess extends PackageState {
  final PackageModel package;
  final DateTime? startDate;
  final DateTime? endDate;

  const PackageSuccess({
    required this.package,
    required this.startDate,
    required this.endDate,
  });
}


class PackageError extends PackageState {
  final String message;

  const PackageError(this.message);
}