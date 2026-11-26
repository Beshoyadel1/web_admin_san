import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/filter_orders_model/filter_orders_model.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import 'package:web_admin_san/feature/internal_services/view_model/new_orders_cubit/new_orders_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/tabs_cubit/tabs_cubit.dart';
import 'package:web_admin_san/feature/orders_page/data/model/orders_filter_criteria.dart';
import 'package:web_admin_san/feature/orders_page/presentation/pages/orders_page_widgets/widgets/filters_tabs_widget_order_services_type.dart';
import 'package:web_admin_san/feature/orders_page/presentation/widgets/orders_filter_dialog.dart';
import 'package:web_admin_san/feature/orders_page/presentation/widgets/orders_filter_toolbar.dart';
import 'package:web_admin_san/feature/orders_page/view_model/get_order_cubit/get_order_cubit.dart';
import 'package:web_admin_san/feature/orders_page/view_model/get_order_cubit/get_order_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class OrdersPageMobileServicesStatistics extends StatefulWidget {
  final NewOrdersCubit cubit;

  const OrdersPageMobileServicesStatistics({
    super.key,
    required this.cubit,
  });

  @override
  State<OrdersPageMobileServicesStatistics> createState() =>
      _OrdersPageMobileServicesStatisticsState();
}

class _OrdersPageMobileServicesStatisticsState
    extends State<OrdersPageMobileServicesStatistics> {
  final TextEditingController _searchController = TextEditingController();
  OrdersFilterCriteria _criteria = OrdersFilterCriteria.empty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSearch({
    OrdersFilterCriteria? newCriteria,
    int page = 1,
  }) {
    if (newCriteria != null) {
      setState(() {
        _criteria = newCriteria;
      });
    }
    context.read<GetOrderCubit>().getOrders(
          pageNumber: page,
          orderType: _criteria.orderType,
          userType: _criteria.userType,
          startDate: _criteria.startDate,
          endDate: _criteria.endDate,
          search: _searchController.text.trim(),
          updateFilters: true,
        );
  }

  void _openFilterDialog() {
    OrdersFilterDialog.show(
      context,
      initialCriteria: _criteria,
      onApply: (newCriteria) {
        int targetTab = 0;
        if (newCriteria.orderType == 1) {
          targetTab = 1;
        } else if (newCriteria.orderType == 2) {
          targetTab = 2;
        } else if (newCriteria.orderType == 3) {
          targetTab = 3;
        }
        context.read<TabsCubit>().changeTab(targetTab);

        _applyFiltersAndSearch(newCriteria: newCriteria, page: 1);
      },
    );
  }

  void _clearDateFilter() {
    _applyFiltersAndSearch(
      newCriteria: _criteria.copyWith(
        clearStartDate: true,
        clearEndDate: true,
        clearDatePreset: true,
      ),
      page: 1,
    );
  }

  void _clearOrderStatusFilter() {
    context.read<TabsCubit>().changeTab(0);
    _applyFiltersAndSearch(
      newCriteria: _criteria.copyWith(clearOrderType: true),
      page: 1,
    );
  }

  void _clearUserTypeFilter() {
    _applyFiltersAndSearch(
      newCriteria: _criteria.copyWith(clearUserType: true),
      page: 1,
    );
  }

  void _clearAllFilters() {
    context.read<TabsCubit>().changeTab(0);
    _applyFiltersAndSearch(
      newCriteria: OrdersFilterCriteria.empty,
      page: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TabsCubit, int>(
      listener: (context, tabIndex) {
        final mapped = mapOrderType(tabIndex);
        if (_criteria.orderType != mapped) {
          setState(() {
            _criteria = _criteria.copyWith(
              orderType: mapped,
              clearOrderType: mapped == null,
            );
          });
        }
      },
      child: BlocBuilder<GetOrderCubit, GetOrderState>(
        builder: (context, state) {
          final totalCount = state is GetOrderSuccess ? state.totalCount : null;

          return CustomContainer(
            isSelected: false,
            onTap: () {},
            typeWidget: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runAlignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextInAppWidget(
                            text: LocaleKeys.allOrdersKey,
                            textSize: 20,
                            textColor: AppColors.darkColor,
                          ),
                          TextInAppWidget(
                            text: LocaleKeys.ordersListFromServicesKey,
                            textSize: 16,
                            textColor: AppColors.darkGreyColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OrdersFilterToolbar(
                    searchController: _searchController,
                    searchHint: 'البحث برقم الطلب، العميل، المركز...',
                    criteria: _criteria,
                    onOpenFilterDialog: _openFilterDialog,
                    onSearchChanged: (val) => _applyFiltersAndSearch(page: 1),
                    onSearchSubmitted: () => _applyFiltersAndSearch(page: 1),
                    onSearchCleared: () => _applyFiltersAndSearch(page: 1),
                    onClearDateFilter: _clearDateFilter,
                    onClearOrderStatusFilter: _clearOrderStatusFilter,
                    onClearUserTypeFilter: _clearUserTypeFilter,
                    onClearAllFilters: _clearAllFilters,
                    totalCount: totalCount,
                    countLabel: 'إجمالي الطلبات',
                  ),
                  Expanded(
                    child: FiltersTabsWidgetOrderServicesType(
                      filterOptions: filterOrders,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
