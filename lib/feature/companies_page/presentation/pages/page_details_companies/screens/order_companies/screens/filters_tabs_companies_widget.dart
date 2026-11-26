import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/order_companies/screens/filter_design_companies_orders.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/filter_orders_model/filter_orders_model.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/tabs_cubit/tabs_cubit.dart';

class FiltersTabsCompaniesWidget extends StatefulWidget {
  final int companyId;
  const FiltersTabsCompaniesWidget(
      {super.key, required this.filterOptions, required this.companyId});

  final List<filterOrdersModel> filterOptions;

  @override
  State<FiltersTabsCompaniesWidget> createState() =>
      _FiltersTabsCompaniesWidgetState();
}

class _FiltersTabsCompaniesWidgetState extends State<FiltersTabsCompaniesWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController =
        TabController(length: widget.filterOptions.length, vsync: this);

    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging ||
        _tabController.animation?.value == _tabController.index) {
      final tabIndex = _tabController.index;
      if (context.read<TabsCubit>().state != tabIndex) {
        context.read<TabsCubit>().changeTab(tabIndex);

        context.read<GetProviderInternalOrderCubit>().getCompanyOrders(
            orderType: mapOrderType(tabIndex),
            pageNumber: 1,
            companyId: widget.companyId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsCubit, int>(
      builder: (context, selectedIndex) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              isScrollable: true,
              indicator: const BoxDecoration(),
              dividerColor: AppColors.transparent,
              overlayColor: WidgetStateColor.transparent,
              onTap: (index) {
                if (selectedIndex != index) {
                  context.read<TabsCubit>().changeTab(index);
                  context
                      .read<GetProviderInternalOrderCubit>()
                      .getCompanyOrders(
                          orderType: mapOrderType(index),
                          pageNumber: 1,
                          companyId: widget.companyId);
                }
              },
              tabs: List.generate(widget.filterOptions.length, (index) {
                final isSelected = selectedIndex == index;

                return Tab(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.orangeColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.orangeColor
                              : AppColors.lightGreyColor,
                        ),
                      ),
                      child: Center(
                        child: TextInAppWidget(
                          text: widget.filterOptions[index].text,
                          textSize: 15,
                          textColor: isSelected
                              ? AppColors.whiteColor
                              : AppColors.darkGreyColor,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  widget.filterOptions.length,
                  (index) => FilterDesignCompaniesOrders(
                    companyId: widget.companyId,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }
}
