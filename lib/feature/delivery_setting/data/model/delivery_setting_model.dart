class DeliverySettingModel {
  final int id;
  final double deliveryCost;
  final double deliveryPrice;
  final bool isDeliveryEnabled;

  const DeliverySettingModel({
    required this.id,
    required this.deliveryCost,
    required this.deliveryPrice,
    required this.isDeliveryEnabled,
  });

  factory DeliverySettingModel.fromJson(Map<String, dynamic> json) {
    return DeliverySettingModel(
      id: (json['id'] ?? json['Id'] ?? json['ID'] ?? 0) as int,
      deliveryCost: (json['deliverycost'] ??
              json['deliveryCost'] ??
              json['DELIVERYCOST'] ??
              0.0)
          .toDouble(),
      deliveryPrice: (json['deliveryprice'] ??
              json['deliveryPrice'] ??
              json['DELIVERYPRICE'] ??
              0.0)
          .toDouble(),
      isDeliveryEnabled: (json['isdeliveryenabled'] ??
              json['isDeliveryEnabled'] ??
              json['ISDELIVERYENABLED'] ??
              false) ==
          true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deliverycost': deliveryCost,
      'deliveryprice': deliveryPrice,
      'isdeliveryenabled': isDeliveryEnabled,
    };
  }

  DeliverySettingModel copyWith({
    int? id,
    double? deliveryCost,
    double? deliveryPrice,
    bool? isDeliveryEnabled,
  }) {
    return DeliverySettingModel(
      id: id ?? this.id,
      deliveryCost: deliveryCost ?? this.deliveryCost,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      isDeliveryEnabled: isDeliveryEnabled ?? this.isDeliveryEnabled,
    );
  }
}

class DeliveryInfoModel {
  final int totalDeliveryOrdersCount;
  final DeliverySettingModel? deliverySetting;

  const DeliveryInfoModel({
    required this.totalDeliveryOrdersCount,
    this.deliverySetting,
  });

  factory DeliveryInfoModel.fromJson(Map<String, dynamic> json) {
    final rawSetting = json['deliverySetting'] ??
        json['deliverysetting'] ??
        json['DeliverySetting'] ??
        json['DELIVERYSETTING'];

    return DeliveryInfoModel(
      totalDeliveryOrdersCount: (json['totalDeliveryOrdersCount'] ??
          json['totaldeliveryorderscount'] ??
          json['TotalDeliveryOrdersCount'] ??
          0) as int,
      deliverySetting: rawSetting is Map<String, dynamic>
          ? DeliverySettingModel.fromJson(rawSetting)
          : (rawSetting is Map
              ? DeliverySettingModel.fromJson(
                  Map<String, dynamic>.from(rawSetting))
              : null),
    );
  }
}
