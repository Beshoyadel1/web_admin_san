import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/feature/rates_page/data/model/get_provider_details_rates_model/rate_item.dart';

class ServiceRates {
  final int? id;
  final int? parentId;
  final String? name;
  final String? latinName;
  final String? image;
  final List<RateItem> rates;

  ServiceRates({
    this.id,
    this.parentId,
    this.name,
    this.latinName,
    this.image,
    required this.rates,
  });

  factory ServiceRates.fromJson(Map<String, dynamic> json) {
    return ServiceRates(
      id: json['id'],
      parentId: json['parentid'],
      name: json['name'] ?? '',
      latinName: json['latinname'] ?? '',
      image: json['image'],
      rates: (json['rates'] as List? ?? [])
          .map((e) => RateItem.fromJson(e))
          .toList(),
    );
  }

  String getTitle(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return isArabic ? (name ?? "") : (latinName ?? "");
  }
}
