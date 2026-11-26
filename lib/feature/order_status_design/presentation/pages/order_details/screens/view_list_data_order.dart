import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/widgets/view_list_data_order_widget.dart';

class ViewListDataOrder extends StatelessWidget {
  final OrderDetailsModel orderDetailsModel;

  const ViewListDataOrder({
    super.key,
    required this.orderDetailsModel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final List<String> serviceTypes = orderDetailsModel.services
            ?.map(
              (service) =>
                  isArabic ? service.name ?? '' : service.latinname ?? '',
            )
            .where(
              (service) => service.isNotEmpty,
            )
            .toList() ??
        [];

    return ViewListDataOrderWidget(
      totalPrice: orderDetailsModel.totalprice?.toString(),
      appointment: OrderFunctions.formatDateFromDateTime(
        orderDetailsModel.appointment,
      ),
      date: OrderFunctions.formatDateFromDateTime(
        orderDetailsModel.date,
      ),
      serviceTypes: serviceTypes,
    );
  }
}
