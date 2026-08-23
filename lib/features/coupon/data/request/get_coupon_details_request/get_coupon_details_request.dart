class GetCouponDetailsRequest {
  final int couponId;

  GetCouponDetailsRequest({
    required this.couponId,
  });

  Map<String, dynamic> toJson() {
    return {
      'couponId': couponId,
    };
  }
}