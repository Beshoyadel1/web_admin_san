class CouponStatisticsModel {
  final int totalOrders;
  final double totalSales;
  final int uniqueUsersCount;

  const CouponStatisticsModel({
    required this.totalOrders,
    required this.totalSales,
    required this.uniqueUsersCount,
  });

  factory CouponStatisticsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CouponStatisticsModel(
      totalOrders: _toInt(
        json['totalOrders'],
      ),
      totalSales: _toDouble(
        json['totalSales'],
      ),
      uniqueUsersCount: _toInt(
        json['uniqueUsersCount'],
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;

    if (value is double) return value;

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    ) ??
        0;
  }
}