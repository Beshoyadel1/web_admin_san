import 'package:web_admin_san/features/banner/data/model/get_banners_models/banner_model.dart';

abstract class BannerState {}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerImageSelected extends BannerState {}

class BannerCreateLoading extends BannerState {}

class BannerCreateSuccess extends BannerState {}

class BannerSuccess extends BannerState {
  final List<BannerModel> banners;

  BannerSuccess(this.banners);
}
class BannerUpdateLoading extends BannerState {}

class BannerUpdateSuccess extends BannerState {}
class BannerDeleteLoading extends BannerState {}

class BannerDeleteSuccess extends BannerState {}
class BannerError extends BannerState {
  final String message;

  BannerError(this.message);
}