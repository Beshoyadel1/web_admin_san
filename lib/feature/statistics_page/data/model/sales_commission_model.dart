class AdminSalesAndCommissionModel {
  final num totalSales;
  final num totalCommission;
  final List<SalesCommissionPoint> chartPoints;

  AdminSalesAndCommissionModel({
    required this.totalSales,
    required this.totalCommission,
    required this.chartPoints,
  });

  factory AdminSalesAndCommissionModel.fromJson(Map<String, dynamic> json) {
    return AdminSalesAndCommissionModel(
      totalSales: json['totalSales'] ?? json['TotalSales'] ?? 0,
      totalCommission: json['totalCommission'] ?? json['TotalCommission'] ?? 0,
      chartPoints: (json['chartPoints'] as List? ??
              json['ChartPoints'] as List? ??
              [])
          .map((e) => SalesCommissionPoint.fromJson(
              e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}))
          .toList(),
    );
  }
}

class SalesCommissionPoint {
  final String label;
  final num sales;
  final num commission;

  SalesCommissionPoint({
    required this.label,
    required this.sales,
    required this.commission,
  });

  factory SalesCommissionPoint.fromJson(Map<String, dynamic> json) {
    return SalesCommissionPoint(
      label: json['label'] ?? json['Label'] ?? '',
      sales: json['sales'] ?? json['Sales'] ?? 0,
      commission: json['commission'] ?? json['Commission'] ?? 0,
    );
  }
}
