import 'package:web_admin_san/features/packages/data/model/get_packages_model/get_packages_model.dart';

abstract class PackagesState {
  const PackagesState();
}

class PackagesInitial extends PackagesState {
  const PackagesInitial();
}


class PackagesLoading extends PackagesState {
  const PackagesLoading();
}



class PackagesGetSuccess extends PackagesState {
  final List<PackageModel> packages;

  const PackagesGetSuccess({
    required this.packages,
  });
}


class PackageGetByIdSuccess extends PackagesState {
  final PackageModel package;

  const PackageGetByIdSuccess({
    required this.package,
  });
}
class PackagesCreateSuccess extends PackagesState {
  final PackageModel package;

  const PackagesCreateSuccess({
    required this.package,
  });
}
class PackagesDeleteSuccess extends PackagesState {
  final String message;

  const PackagesDeleteSuccess({
    required this.message,
  });
}
class PackagesUpdateSuccess extends PackagesState {
  final PackageModel package;

  const PackagesUpdateSuccess({
    required this.package,
  });
}

class PackagesFailure extends PackagesState {
  final String message;

  const PackagesFailure({
    required this.message,
  });
}