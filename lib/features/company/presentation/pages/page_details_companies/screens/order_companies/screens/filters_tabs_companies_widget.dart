import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/order_companies/screens/filter_design_companies_orders.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/order_providers/screens/filter_design_provider_orders.dart';
import '../../../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../../features/cars_haraj_page/data/model/filter_orders_model/filter_orders_model.dart';
import '../../../../../../../../../features/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import '../../../../../../../../../features/internal_services/presentation/cubit/get_provider_internal_order/get_provider_internal_order_state.dart';
import '../../../../../../../../../features/internal_services/presentation/cubit/tabs_cubit/tabs_cubit.dart';
import '../../../../../../../../../features/internal_services/presentation/pages/internal_services_statistics/Internal_services_page/widgets/filter_design_internal_orders.dart';

class FiltersTabsCompaniesWidget extends StatefulWidget {
  final int companyId;
  const FiltersTabsCompaniesWidget({
    super.key,
    required this.filterOptions,
    required this.companyId
  });

  final List<filterOrdersModel> filterOptions;

  @override
  State<FiltersTabsCompaniesWidget> createState() => _FiltersTabsCompaniesWidgetState();
}

class _FiltersTabsCompaniesWidgetState extends State<FiltersTabsCompaniesWidget>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController =
        TabController(length: widget.filterOptions.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final tabIndex = _tabController.index;

        context.read<TabsCubit>().changeTab(tabIndex);

        context.read<GetProviderInternalOrderCubit>().getCompanyOrders(
          orderType: mapOrderType(tabIndex),
          pageNumber: 1,
          companyId:widget.companyId
        );
      }
    });
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
              dividerColor: Colors.transparent,
              tabs: List.generate(widget.filterOptions.length, (index) {

                final isSelected = selectedIndex == index;

                return Tab(
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.orangeColor
                          : AppColors.greyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: TextInAppWidget(
                        text: widget.filterOptions[index].text,
                        textSize: 16,
                        textColor: AppColors.whiteColor,
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
                      (index) =>  FilterDesignCompaniesOrders(
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
    _tabController.dispose();
    super.dispose();
  }
}