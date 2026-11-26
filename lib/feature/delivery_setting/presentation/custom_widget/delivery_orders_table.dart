import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/app_pagination.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../data/model/delivery_order_model.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'delivery_orders_filter_tabs.dart';

class DeliveryOrdersTable extends StatefulWidget {
  final DeliveryOrderPaginatedResponse? ordersResponse;
  final String? selectedStatus;
  final String searchQuery;
  final int currentPage;
  final bool isLoading;
  final bool isCancelling;
  final void Function(String query) onSearchChanged;
  final void Function(String? status) onStatusChanged;
  final void Function(int page) onPageChanged;
  final void Function(int orderId, String reason) onCancelOrder;

  const DeliveryOrdersTable({
    super.key,
    required this.ordersResponse,
    required this.selectedStatus,
    required this.searchQuery,
    required this.currentPage,
    this.isLoading = false,
    required this.isCancelling,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onPageChanged,
    required this.onCancelOrder,
  });

  @override
  State<DeliveryOrdersTable> createState() => _DeliveryOrdersTableState();
}

class _DeliveryOrdersTableState extends State<DeliveryOrdersTable> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
  }

  @override
  void didUpdateWidget(covariant DeliveryOrdersTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery &&
        _searchController.text != widget.searchQuery) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = widget.ordersResponse?.data ?? [];
    final totalCount = widget.ordersResponse?.totalCount ?? 0;
    final pageCount = widget.ordersResponse?.pageCount ?? 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardStroke, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Toolbar: Header Title & Search Field
              Padding(
                padding: EdgeInsets.all(isMobile ? 14 : 20),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.blueColor100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.list_alt_outlined,
                                  color: AppColors.seaBlueColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.deliveryOrdersList.tr(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.darkColor,
                                    ),
                                  ),
                                  Text(
                                    '${LocaleKeys.totalDeliveryOrders.tr()}: $totalCount',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.darkGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Search field
                          SizedBox(
                            height: 40,
                            child: TextField(
                              controller: _searchController,
                              onSubmitted: widget.onSearchChanged,
                              style: const TextStyle(fontSize: 12.5),
                              decoration: InputDecoration(
                                hintText:
                                    LocaleKeys.searchDeliveryOrdersHint.tr(),
                                hintStyle: const TextStyle(fontSize: 12),
                                prefixIcon: const Icon(Icons.search, size: 18),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 16),
                                        onPressed: () {
                                          _searchController.clear();
                                          widget.onSearchChanged('');
                                        },
                                      )
                                    : null,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                filled: true,
                                fillColor: AppColors.whiteGreyColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.cardStroke),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.cardStroke),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.orangeColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Horizontal Filter Tabs
                          DeliveryOrdersFilterTabs(
                            selectedStatus: widget.selectedStatus,
                            onStatusChanged: widget.onStatusChanged,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.blueColor100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.list_alt_outlined,
                                      color: AppColors.seaBlueColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.deliveryOrdersList.tr(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.darkColor,
                                        ),
                                      ),
                                      Text(
                                        '${LocaleKeys.totalDeliveryOrders.tr()}: $totalCount',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.darkGreyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Search field
                              SizedBox(
                                width: 280,
                                height: 42,
                                child: TextField(
                                  controller: _searchController,
                                  onSubmitted: widget.onSearchChanged,
                                  decoration: InputDecoration(
                                    hintText: LocaleKeys
                                        .searchDeliveryOrdersHint
                                        .tr(),
                                    hintStyle: const TextStyle(fontSize: 12),
                                    prefixIcon:
                                        const Icon(Icons.search, size: 18),
                                    suffixIcon:
                                        _searchController.text.isNotEmpty
                                            ? IconButton(
                                                icon: const Icon(Icons.clear,
                                                    size: 16),
                                                onPressed: () {
                                                  _searchController.clear();
                                                  widget.onSearchChanged('');
                                                },
                                              )
                                            : null,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    filled: true,
                                    fillColor: AppColors.whiteGreyColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: AppColors.cardStroke),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: AppColors.cardStroke),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: AppColors.orangeColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Horizontal Filter Tabs matching Orders Page
                          DeliveryOrdersFilterTabs(
                            selectedStatus: widget.selectedStatus,
                            onStatusChanged: widget.onStatusChanged,
                          ),
                        ],
                      ),
              ),
              const Divider(color: AppColors.cardStroke, height: 1),

              // Loading progress indicator
              if (widget.isLoading)
                const LinearProgressIndicator(
                  minHeight: 2.5,
                  color: AppColors.orangeColor,
                  backgroundColor: AppColors.CircleLightorangeColor,
                ),

              // Content: List of Standard Order Cards, Loading State, or Empty State
              if (orders.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: widget.isLoading
                        ? Column(
                            children: [
                              const CircularProgressIndicator(
                                  color: AppColors.orangeColor),
                              const SizedBox(height: 12),
                              Text(
                                LocaleKeys.loadingDeliverySettings.tr(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.darkGreyColor,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: AppColors.lightGreyColor,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                LocaleKeys.noDeliveryOrders.tr(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.darkGreyColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                )
              else
                AnimatedOpacity(
                  opacity: widget.isLoading ? 0.6 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    child: Column(
                      children: orders.map((order) {
                        final service = (order.services != null &&
                                order.services!.isNotEmpty)
                            ? order.services!.first
                            : null;
                        final serviceTitle = OrderFunctions.getServiceTitle(
                          context: context,
                          service: service,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child:
                              ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
                            imagePathPart1: service?.image,
                            titlePart1: serviceTitle,
                            subTitlePart1: '',
                            imagePathPart2: AppImageKeys.car501,
                            textCarPart2: order.branchName ?? "",
                            titlePart2: order.providerName ?? "",
                            imagePathPart3: order.providerImage,
                            titlePart3: LocaleKeys.name,
                            subTitlePart3: order.username ?? "",
                            status: order.orderStatus,
                            timePart5:
                                OrderFunctions.formatDate(order.orderDate),
                            pricePart6: order.totalPrice?.toString() ?? "0",
                            order: order,
                            serviceId: 5,
                            id: order.id?.toString() ?? "",
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              // Pagination bar
              if (orders.isNotEmpty) ...[
                const Divider(color: AppColors.cardStroke, height: 1),
                AppPagination(
                  currentPage: widget.currentPage,
                  totalPages: pageCount,
                  onPageChanged: widget.onPageChanged,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
