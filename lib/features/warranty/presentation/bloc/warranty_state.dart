import '../../../../../../../../features/warranty/data/model/warranty_model/warranty_model.dart';

abstract class WarrantyState {
  const WarrantyState();
}

class WarrantyInitial extends WarrantyState {
  const WarrantyInitial();
}

class WarrantyLoading extends WarrantyState {
  const WarrantyLoading();
}

class WarrantySuccess extends WarrantyState {
  final List<WarrantyModel> warranties;

  const WarrantySuccess(
      this.warranties,
      );
}

class WarrantyDetailsSuccess extends WarrantyState {
  final WarrantyModel warranty;

  const WarrantyDetailsSuccess(
      this.warranty,
      );
}


class WarrantyError extends WarrantyState {
  final String message;

  const WarrantyError(
      this.message,
      );
}

class WarrantyCreateLoading extends WarrantyState {
  const WarrantyCreateLoading();
}

class WarrantyCreateSuccess extends WarrantyState {
  final WarrantyModel? warranty;

  const WarrantyCreateSuccess(
      this.warranty,
      );
}

class WarrantyCreateError extends WarrantyState {
  final String message;

  const WarrantyCreateError(
      this.message,
      );
}


class WarrantyUpdateLoading extends WarrantyState {
  const WarrantyUpdateLoading();
}

class WarrantyUpdateSuccess extends WarrantyState {
  final WarrantyModel warranty;

  const WarrantyUpdateSuccess(
      this.warranty,
      );
}

class WarrantyUpdateError extends WarrantyState {
  final String message;

  const WarrantyUpdateError(
      this.message,
      );
}