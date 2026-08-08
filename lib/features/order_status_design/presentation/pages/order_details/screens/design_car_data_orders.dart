import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/features/internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import 'package:web_admin_san/features/order_status_design/presentation/custom_widget/design_car_data_orders_widget.dart';

import 'package:flutter/material.dart';

import 'package:web_admin_san/features/internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import 'package:web_admin_san/features/order_status_design/presentation/custom_widget/design_car_data_orders_widget.dart';

class DesignCarDataOrders extends StatelessWidget {
  final OrderDetailsModel orderDetailsModel;

  const DesignCarDataOrders({
    super.key,
    required this.orderDetailsModel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    final car = orderDetailsModel.cars?.isNotEmpty == true
        ? orderDetailsModel.cars!.first
        : null;

    if (car == null) {
      return const SizedBox.shrink();
    }

    final List<ProvService> provServices =
        car.provServices ?? [];

    return DesignCarDataOrdersWidget(
      plateNo: car.plateno,

      brandName: isArabic
          ? car.brand?.brandname
          : car.brand?.brandlatinname,

      totalPriceCar: car.totalprice?.toString(),

      provServices: provServices,

      isArabic: isArabic,
    );
  }
}