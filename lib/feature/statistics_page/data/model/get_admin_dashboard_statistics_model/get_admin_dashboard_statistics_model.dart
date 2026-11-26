class DashboardData {
  final Summary summary;
  final MonthlySalesComparison monthlySalesComparison;
  final MaintenanceStats maintenanceStats;
  final List<RecentOrderItem> recentOrders;

  DashboardData({
    required this.summary,
    required this.monthlySalesComparison,
    required this.maintenanceStats,
    this.recentOrders = const [],
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final summaryRaw = json['summary'] ?? json['Summary'];
    final monthlyRaw =
        json['monthlySalesComparison'] ?? json['MonthlySalesComparison'];
    final maintRaw = json['maintenanceStats'] ?? json['MaintenanceStats'];
    final recentRaw = json['recentOrders'] ?? json['RecentOrders'];

    return DashboardData(
      summary: Summary.fromJson(
        summaryRaw is Map ? Map<String, dynamic>.from(summaryRaw) : {},
      ),
      monthlySalesComparison: MonthlySalesComparison.fromJson(
        monthlyRaw is Map ? Map<String, dynamic>.from(monthlyRaw) : {},
      ),
      maintenanceStats: MaintenanceStats.fromJson(
        maintRaw is Map ? Map<String, dynamic>.from(maintRaw) : {},
      ),
      recentOrders: (recentRaw as List? ?? [])
          .map((e) => RecentOrderItem.fromJson(
              e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}))
          .toList(),
    );
  }
}

class Summary {
  final int totalOrders;
  final int totalCustomers;
  final int totalCompanies;
  final int totalServiceProviders;
  final num totalOrderSales;
  final int totalCarInsurances;

  Summary({
    required this.totalOrders,
    required this.totalCustomers,
    required this.totalCompanies,
    required this.totalServiceProviders,
    required this.totalOrderSales,
    this.totalCarInsurances = 0,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalOrders: json['totalOrders'] ?? json['TotalOrders'] ?? 0,
      totalCustomers: json['totalCustomers'] ?? json['TotalCustomers'] ?? 0,
      totalCompanies: json['totalCompanies'] ?? json['TotalCompanies'] ?? 0,
      totalServiceProviders:
          json['totalServiceProviders'] ?? json['TotalServiceProviders'] ?? 0,
      totalOrderSales: json['totalOrderSales'] ?? json['TotalOrderSales'] ?? 0,
      totalCarInsurances:
          json['totalCarInsurances'] ?? json['TotalCarInsurances'] ?? 0,
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
          .map((e) => SalesItem.fromJson(
              e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}))
          .toList(),
      lastYearSales: (json['lastYearSales'] as List? ?? [])
          .map((e) => SalesItem.fromJson(
              e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}))
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

class RecentOrderItem {
  final int id;
  final String centerName;
  final String? centerImage;
  final String serviceCategory;
  final String serviceName;
  final String customerName;
  final String? customerImage;
  final int status;
  final String statusName;
  final DateTime? orderDate;
  final num servicePrice;

  RecentOrderItem({
    required this.id,
    required this.centerName,
    this.centerImage,
    required this.serviceCategory,
    required this.serviceName,
    required this.customerName,
    this.customerImage,
    required this.status,
    required this.statusName,
    this.orderDate,
    required this.servicePrice,
  });

  factory RecentOrderItem.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    final dateVal = json['orderDate'] ?? json['OrderDate'];
    if (dateVal != null) {
      parsedDate = DateTime.tryParse(dateVal.toString())?.toLocal();
    }
    return RecentOrderItem(
      id: json['id'] ?? json['Id'] ?? 0,
      centerName: json['centerName'] ?? json['CenterName'] ?? '',
      centerImage: json['centerImage'] ?? json['CenterImage'],
      serviceCategory:
          json['serviceCategory'] ?? json['ServiceCategory'] ?? 'خدمات داخلية',
      serviceName: json['serviceName'] ?? json['ServiceName'] ?? '',
      customerName: json['customerName'] ?? json['CustomerName'] ?? '',
      customerImage: json['customerImage'] ?? json['CustomerImage'],
      status: json['status'] ?? json['Status'] ?? 0,
      statusName: json['statusName'] ?? json['StatusName'] ?? '',
      orderDate: parsedDate,
      servicePrice: json['servicePrice'] ?? json['ServicePrice'] ?? 0,
    );
  }
}
