import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/title_with_sub_title.dart';

import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_model.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/Column_date_order_with_time_widget.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/column_price_order_widget.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/container_details_widget.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/row_image_with_title_widget.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_with_container_status.dart';

import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/delivery_order_badge_widget.dart';

class TabSecondPartDataContainerInListDataFirstScreenInternalOrders
    extends StatelessWidget {
  final String titlePart1,
      subTitlePart1,
      imagePathPart2,
      textCarPart2,
      titlePart2,
      titlePart3,
      subTitlePart3,
      timePart5,
      pricePart6,
      id;
  final int? status, serviceId;
  final Uint8List? imagePathPart1, imagePathPart3;
  final OrderModel order;

  const TabSecondPartDataContainerInListDataFirstScreenInternalOrders(
      {super.key,
      required this.imagePathPart1,
      required this.titlePart1,
      required this.subTitlePart1,
      required this.imagePathPart2,
      required this.textCarPart2,
      required this.titlePart2,
      required this.imagePathPart3,
      required this.titlePart3,
      required this.subTitlePart3,
      this.status,
      required this.timePart5,
      required this.pricePart6,
      required this.order,
      required this.serviceId,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleWithSubTitle(
                title: LocaleKeys.identity,
                textSizeTitle: 12,
                subTitleColor: AppColors.greyColor,
                titleColor: AppColors.greyColor,
                subTitle: id,
                textSizeSubTitle: 10,
              ),
              if (order.isDeliveryOrder) ...[
                const SizedBox(height: 4),
                const DeliveryOrderBadgeWidget(),
              ],
            ],
          ),
        ),
        Expanded(
          child: RowImageWithTitleWidget(
            imagePath: imagePathPart1,
            title: titlePart1,
            // textSizeTitle: 12,
            subTitle: subTitlePart1,
          ),
        ),
        Expanded(
          child: RowImageWithTitleWidget(
            isJob: true,
            imagePath: imagePathPart3,
            title: titlePart3,
            subTitle: subTitlePart3,
          ),
        ),
        Expanded(
            child: TextWithContainerStatus(
          status: status ?? 0,
        )),
        Expanded(child: ColumnDateOrderWithTimeWidget(time: timePart5)),
        Expanded(child: ColumnPriceOrderWidget(price: pricePart6)),
        Expanded(
            child: ContainerDetailsWidget(
          status: status ?? 0,
          order: order,
          serviceId: serviceId ?? 5,
        ))
      ],
    );
  }
}
