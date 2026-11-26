import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_model.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/Column_date_order_with_time_widget.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/column_price_order_widget.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/row_image_with_title_widget.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_with_container_status.dart';
import '../../../../../../../core/widgets/custom_container.dart';

class CustomContainerOrder extends StatelessWidget {
  final OrderModel order;

  const CustomContainerOrder({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    // final service =
    // order.services?.isNotEmpty == true ? order.services!.first : null;
    //
    // final serviceTitle = OrderFunctions.getServiceTitle(
    //   context: context,
    //   service: service,
    // );

    return CustomContainer(
      isSelected: false,
      containerWidth: double.infinity,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      // typeWidget: Wrap(
      //   spacing: 35,
      //   runSpacing: 10,
      //   crossAxisAlignment: WrapCrossAlignment.center,
      //   alignment: WrapAlignment.spaceBetween,
      //   children: [
      //     ColumnDateOrderWithTimeWidget(
      //       title: LocaleKeys.identity,
      //       time: order.id.toString()
      //     ),
      //     RowImageWithTitleWidget(
      //       isWrap: true,
      //       imagePath: service?.image,
      //       title: serviceTitle,
      //       subTitle: '',
      //     ),
      //     RowImageWithTitleWidget(
      //       isWrap: true,
      //       isJob: true,
      //       imagePath: order.providerImage,
      //       title: LocaleKeys.name,
      //       subTitle: order.providerName ?? "",
      //     ),
      //     TextWithContainerStatus(
      //       status: order.orderStatus ?? 0,
      //     ),
      //     ColumnDateOrderWithTimeWidget(
      //       time: OrderFunctions.formatDate(order.orderDate),
      //     ),
      //     ColumnPriceOrderWidget(
      //       price: order.totalPrice?.toString() ?? "20",
      //     ),
      //   ],
      // ),
    );
  }
}
