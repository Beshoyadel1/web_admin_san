import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_model.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/service_model.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_admin_dashboard_statistics_model/get_admin_dashboard_statistics_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class RecentOrdersListWidget extends StatelessWidget {
  final List<RecentOrderItem> orders;

  const RecentOrdersListWidget({
    super.key,
    required this.orders,
  });

  static final List<RecentOrderItem> _fallbackOrders = [
    RecentOrderItem(
      id: 18,
      centerName: 'عماره',
      serviceCategory: 'خدمات داخلية',
      serviceName: 'صيانة وإصلاح',
      customerName: 'mostafa',
      status: 0,
      statusName: 'طلب جديد',
      orderDate: DateTime(2026, 10, 24),
      servicePrice: 710.00,
    ),
    RecentOrderItem(
      id: 16,
      centerName: 'عماره',
      serviceCategory: 'خدمات داخلية',
      serviceName: 'صيانة وإصلاح',
      customerName: 'mostafa',
      status: 0,
      statusName: 'طلب جديد',
      orderDate: DateTime(2026, 10, 20),
      servicePrice: 690.00,
    ),
    RecentOrderItem(
      id: 15,
      centerName: 'عماره',
      serviceCategory: 'خدمات داخلية',
      serviceName: 'صيانة وإصلاح',
      customerName: 'mostafa',
      status: 4,
      statusName: 'تم التسليم',
      orderDate: DateTime(2026, 10, 6),
      servicePrice: 690.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final displayOrders = orders.isNotEmpty ? orders : _fallbackOrders;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.lightGreyColor.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الطلبات المستحدثة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkColor,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'قائمة الطلبات الجديدة من الخدمات',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                ],
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    AppCubit.get(context)
                        .navigateToPage(PagesOfAllApp.dashboardOrderPageNumber);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.orangeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'عرض الكل',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Orders List with standard order item
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayOrders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return RecentOrderItemCard(item: displayOrders[index]);
            },
          ),
        ],
      ),
    );
  }
}

class RecentOrderItemCard extends StatelessWidget {
  final RecentOrderItem item;

  const RecentOrderItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Uint8List? centerImgBytes;
    if (item.centerImage != null && item.centerImage!.isNotEmpty) {
      try {
        if (!item.centerImage!.startsWith('http')) {
          centerImgBytes = base64Decode(item.centerImage!);
        }
      } catch (_) {}
    }

    final orderModel = OrderModel(
      id: item.id,
      username: item.customerName,
      providerName: item.centerName,
      providerImage: centerImgBytes,
      orderStatus: item.status,
      orderDate: item.orderDate?.toIso8601String() ?? '',
      totalPrice: item.servicePrice,
      serviceName: item.serviceName,
      services: [
        ServiceModel(
          id: 0,
          name: item.serviceName,
          latinName: item.serviceName,
        ),
      ],
    );

    final dateFormatted = item.orderDate != null
        ? DateFormat('d/M/yyyy').format(item.orderDate!)
        : '';

    return ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
      imagePathPart1: null,
      titlePart1:
          item.serviceName.isNotEmpty ? item.serviceName : 'خدمات داخلية',
      subTitlePart1: item.serviceCategory,
      imagePathPart2: AppImageKeys.car501,
      textCarPart2: item.centerName.isNotEmpty ? item.centerName : 'مركز صان',
      titlePart2: item.centerName.isNotEmpty ? item.centerName : 'مركز صان',
      imagePathPart3: centerImgBytes,
      titlePart3: LocaleKeys.name,
      subTitlePart3:
          item.customerName.isNotEmpty ? item.customerName : 'العميل',
      status: item.status,
      timePart5: dateFormatted.isNotEmpty ? dateFormatted : '1/1/2026',
      pricePart6: item.servicePrice.toString(),
      order: orderModel,
      serviceId: MainCategoryConstants.maintenanceAndInternalServicesID,
      id: item.id.toString(),
    );
  }
}
