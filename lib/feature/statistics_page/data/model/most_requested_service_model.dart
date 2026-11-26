class MostRequestedServiceModel {
  final String serviceName;
  final String serviceLatinName;
  final num value;
  final num percentage;

  MostRequestedServiceModel({
    required this.serviceName,
    required this.serviceLatinName,
    required this.value,
    required this.percentage,
  });

  factory MostRequestedServiceModel.fromJson(Map<String, dynamic> json) {
    return MostRequestedServiceModel(
      serviceName: json['serviceName'] ?? json['ServiceName'] ?? '',
      serviceLatinName:
          json['serviceLatinName'] ?? json['ServiceLatinName'] ?? '',
      value: json['value'] ?? json['Value'] ?? 0,
      percentage: json['percentage'] ?? json['Percentage'] ?? 0,
    );
  }
}
