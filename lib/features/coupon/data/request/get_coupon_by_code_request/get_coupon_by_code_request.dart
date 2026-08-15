class GetCouponByCodeRequest {
  final String couponCode;
  final int userId;

  const GetCouponByCodeRequest({
    required this.couponCode,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'couponCode': couponCode,
      'userId': userId,
    };
  }
}