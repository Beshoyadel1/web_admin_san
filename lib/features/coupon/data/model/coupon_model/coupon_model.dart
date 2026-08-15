class CouponModel {
  final int? couponId;
  final String? couponCode;
  final int? discountType;
  final double? discountValue;
  final bool? isActive;
  final double? maxDiscountValue;
  final double? minValueToApply;
  final DateTime? couponStartDate;
  final DateTime? couponEndDate;
  final int? usersUseCount;
  final int? oneUserUseCount;

  const CouponModel({
    this.couponId,
    this.couponCode,
    this.discountType,
    this.discountValue,
    this.isActive,
    this.maxDiscountValue,
    this.minValueToApply,
    this.couponStartDate,
    this.couponEndDate,
    this.usersUseCount,
    this.oneUserUseCount,
  });

  factory CouponModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CouponModel(
      couponId: _toInt(json['couponid']),
      couponCode: json['couponcode']?.toString(),
      discountType: _toInt(json['discounttype']),
      discountValue: _toDouble(json['discountvalue']),
      isActive: json['isactive'] is bool
          ? json['isactive']
          : null,
      maxDiscountValue: _toDouble(
        json['maxdiscountvalue'],
      ),
      minValueToApply: _toDouble(
        json['minvaluetoapply'],
      ),
      couponStartDate: _toDateTime(
        json['couponstartdate'],
      ),
      couponEndDate: _toDateTime(
        json['couponenddate'],
      ),
      usersUseCount: _toInt(
        json['usersusecount'],
      ),
      oneUserUseCount: _toInt(
        json['oneuserusecount'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'couponid': couponId,
      'couponcode': couponCode,
      'discounttype': discountType,
      'discountvalue': discountValue,
      'isactive': isActive,
      'maxdiscountvalue': maxDiscountValue,
      'minvaluetoapply': minValueToApply,
      'couponstartdate':
      couponStartDate?.toIso8601String(),
      'couponenddate':
      couponEndDate?.toIso8601String(),
      'usersusecount': usersUseCount,
      'oneuserusecount': oneUserUseCount,
    };
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) return value;

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(
      value.toString(),
    );
  }
}
class CouponWithProviderModel {
  final CouponModel coupon;
  final List<int> providers;

  const CouponWithProviderModel({
    required this.coupon,
    required this.providers,
  });

  factory CouponWithProviderModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final couponJson = json['coupon'];
    final providerJson = json['provider'];

    return CouponWithProviderModel(
      coupon: CouponModel.fromJson(
        couponJson is Map<String, dynamic>
            ? couponJson
            : {},
      ),
      providers: providerJson is List
          ? providerJson
          .map(
            (e) => int.tryParse(
          e.toString(),
        ),
      )
          .whereType<int>()
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coupon': coupon.toJson(),
      'provider': providers,
    };
  }
}