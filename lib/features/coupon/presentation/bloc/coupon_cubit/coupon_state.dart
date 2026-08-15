import 'package:web_admin_san/features/coupon/data/model/coupon_model/coupon_model.dart';
import 'package:web_admin_san/features/coupon/data/model/coupon_statistics_model/coupon_statistics_model.dart';

abstract class CouponState {
  const CouponState();
}

class CouponInitial extends CouponState {
  const CouponInitial();
}

class CouponLoading extends CouponState {
  const CouponLoading();
}

class CouponGetAllSuccess extends CouponState {
  final List<CouponWithProviderModel> coupons;

  const CouponGetAllSuccess({
    required this.coupons,
  });
}

class CouponGetByCodeSuccess
    extends CouponState {
  final CouponWithProviderModel coupon;

  const CouponGetByCodeSuccess({
    required this.coupon,
  });
}
class CouponUpdateSuccess extends CouponState {
  const CouponUpdateSuccess();
}
class CouponStatisticsSuccess extends CouponState {
  final List<CouponStatisticsModel> statistics;

  const CouponStatisticsSuccess({
    required this.statistics,
  });
}
class CouponCreateSuccess extends CouponState {
  final int couponId;

  const CouponCreateSuccess({
    required this.couponId,
  });
}
class CouponFailure extends CouponState {
  final String message;

  const CouponFailure({
    required this.message,
  });
}
