class DashboardData {
  final Summary summary;
  final MonthlySalesComparison monthlySalesComparison;
  final MaintenanceStats maintenanceStats;

  DashboardData({
    required this.summary,
    required this.monthlySalesComparison,
    required this.maintenanceStats,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      summary: Summary.fromJson(json['summary'] ?? {}),
      monthlySalesComparison: MonthlySalesComparison.fromJson(
        json['monthlySalesComparison'] ?? {},
      ),
      maintenanceStats: MaintenanceStats.fromJson(
        json['maintenanceStats'] ?? {},
      ),
    );
  }
}

class Summary {
  final int totalOrders;
  final int totalCustomers;
  final int totalCompanies;
  final int totalServiceProviders;
  final num totalOrderSales;

  Summary({
    required this.totalOrders,
    required this.totalCustomers,
    required this.totalCompanies,
    required this.totalServiceProviders,
    required this.totalOrderSales,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalOrders: json['totalOrders'] ?? 0,
      totalCustomers: json['totalCustomers'] ?? 0,
      totalCompanies: json['totalCompanies'] ?? 0,
      totalServiceProviders: json['totalServiceProviders'] ?? 0,
      totalOrderSales: json['totalOrderSales'] ?? 0,
    );
  }
}

class MonthlySalesComparison {
  final List<SalesItem> currentYearSales;
  final List<SalesItem> lastYearSales;

  MonthlySalesComparison({
    required this.currentYearSales,
    required this.lastYearSales,
  });

  factory MonthlySalesComparison.fromJson(Map<String, dynamic> json) {
    return MonthlySalesComparison(
      currentYearSales: (json['currentYearSales'] as List? ?? [])
          .map((e) => SalesItem.fromJson(e))
          .toList(),
      lastYearSales: (json['lastYearSales'] as List? ?? [])
          .map((e) => SalesItem.fromJson(e))
          .toList(),
    );
  }
}

class SalesItem {
  final String label;
  final num value;

  SalesItem({
    required this.label,
    required this.value,
  });

  factory SalesItem.fromJson(Map<String, dynamic> json) {
    return SalesItem(
      label: json['label'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}

class MaintenanceStats {
  final int userCarsCount;
  final int companyCarsCount;

  MaintenanceStats({
    required this.userCarsCount,
    required this.companyCarsCount,
  });

  factory MaintenanceStats.fromJson(Map<String, dynamic> json) {
    return MaintenanceStats(
      userCarsCount: json['userCarsCount'] ?? 0,
      companyCarsCount: json['companyCarsCount'] ?? 0,
    );
  }
}