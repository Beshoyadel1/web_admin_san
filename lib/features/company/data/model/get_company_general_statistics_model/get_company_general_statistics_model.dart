class GetCompanyGeneralStatisticsModel {
  final OrdersSummary ordersSummary;
  final PetrolConsumption petrolConsumption;
  final List<ServiceChart> serviceChart;

  GetCompanyGeneralStatisticsModel({
    required this.ordersSummary,
    required this.petrolConsumption,
    required this.serviceChart,
  });

  factory GetCompanyGeneralStatisticsModel.fromJson(
      Map<String, dynamic> json) {
    return GetCompanyGeneralStatisticsModel(
      ordersSummary: OrdersSummary.fromJson(json["ordersSummary"]),
      petrolConsumption:
      PetrolConsumption.fromJson(json["petrolConsumption"]),
      serviceChart: (json["serviceChart"] as List)
          .map((e) => ServiceChart.fromJson(e))
          .toList(),
    );
  }
}

class OrdersSummary {
  final int newOrders;
  final int doneOrders;
  final int inServiceOrders;

  OrdersSummary({
    required this.newOrders,
    required this.doneOrders,
    required this.inServiceOrders,
  });

  factory OrdersSummary.fromJson(Map<String, dynamic> json) {
    return OrdersSummary(
      newOrders: json["newOrders"] ?? 0,
      doneOrders: json["doneOrders"] ?? 0,
      inServiceOrders: json["inServiceOrders"] ?? 0,
    );
  }
}

class PetrolConsumption {
  final num totalConsumption;
  final num expectedSpend;
  final num consumptionPercentage;

  PetrolConsumption({
    required this.totalConsumption,
    required this.expectedSpend,
    required this.consumptionPercentage,
  });

  factory PetrolConsumption.fromJson(Map<String, dynamic> json) {
    return PetrolConsumption(
      totalConsumption: json["totalConsumption"] ?? 0,
      expectedSpend: json["expectedSpend"] ?? 0,
      consumptionPercentage: json["consumptionPercentage"] ?? 0,
    );
  }
}

class ServiceChart {
  final String serviceName;
  final String serviceLatinName;
  final num value;
  final num percentage;

  ServiceChart({
    required this.serviceName,
    required this.serviceLatinName,
    required this.value,
    required this.percentage,
  });

  factory ServiceChart.fromJson(Map<String, dynamic> json) {
    return ServiceChart(
      serviceName: json["serviceName"] ?? "",
      serviceLatinName: json["serviceLatinName"] ?? "",
      value: json["value"] ?? 0,
      percentage: json["percentage"] ?? 0,
    );
  }
}