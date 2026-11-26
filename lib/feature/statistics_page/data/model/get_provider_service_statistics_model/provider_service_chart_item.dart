class ProviderServiceChartItem {
  final String? serviceName;
  final String? serviceLatinName;
  final double percentage;

  ProviderServiceChartItem({
    this.serviceName,
    this.serviceLatinName,
    required this.percentage,
  });

  factory ProviderServiceChartItem.fromJson(Map<String, dynamic> json) {
    return ProviderServiceChartItem(
      serviceName: json['serviceName'] ?? json['ServiceName'],
      serviceLatinName: json['serviceLatinName'] ?? json['ServiceLatinName'],
      percentage: (json['percentage'] ?? json['Percentage'] ?? 0).toDouble(),
    );
  }

  String getName(bool isArabic) {
    return isArabic ? (serviceName ?? '') : (serviceLatinName ?? '');
  }
}
