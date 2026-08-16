class DeleteCouponRequest {
  final int couponId;

  const DeleteCouponRequest({
    required this.couponId,
  });

  Map<String, dynamic> toJson() {
    return {
      'couponId': couponId,
    };
  }
}