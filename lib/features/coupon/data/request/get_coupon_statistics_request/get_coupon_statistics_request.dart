class GetCouponStatisticsRequest {
  final int couponId;
  final String? date;

  const GetCouponStatisticsRequest({
    required this.couponId,
    this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'couponId': couponId,
      'date': date ?? '',
    };
  }
}