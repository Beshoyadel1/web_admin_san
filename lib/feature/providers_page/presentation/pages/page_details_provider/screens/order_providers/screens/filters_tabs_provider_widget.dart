import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/order_providers/screens/filter_design_provider_orders.dart';
import '../../../../../../../../../core/networking/api_link.dart';
import '../../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/filter_orders_model/filter_orders_model.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/tabs_cubit/tabs_cubit.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_services_statistics/Internal_services_page/widgets/filter_design_internal_orders.dart';

class FiltersTabsProviderWidget extends StatefulWidget {
  final int providerId;
  const FiltersTabsProviderWidget(
      {super.key, required this.filterOptions, required this.providerId});

  final List<filterOrdersModel> filterOptions;

  @override
  State<FiltersTabsProviderWidget> createState() =>
      _FiltersTabsProviderWidgetState();
}

class _FiltersTabsProviderWidgetState extends State<FiltersTabsProviderWidget>
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

        context.read<GetProviderInternalOrderCubit>().loadInternalOrders(
            orderType: mapOrderType(tabIndex),
            pageNumber: 1,
            providerId: widget.providerId);
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
              dividerColor: AppColors.transparent,
              overlayColor: WidgetStateColor.transparent,
              tabs: List.generate(widget.filterOptions.length, (index) {
                final isSelected = selectedIndex == index;

                return Tab(
                  child: Container(
                    width: 150,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                );
              }),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  widget.filterOptions.length,
                  (index) => FilterDesignProviderOrders(
                    providerId: widget.providerId,
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
