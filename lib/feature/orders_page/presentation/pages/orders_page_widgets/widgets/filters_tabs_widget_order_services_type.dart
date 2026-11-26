import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/orders_page/view_model/get_order_cubit/get_order_cubit.dart';

import 'package:web_admin_san/feature/cars_haraj_page/data/model/filter_orders_model/filter_orders_model.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import 'package:web_admin_san/feature/internal_services/view_model/tabs_cubit/tabs_cubit.dart';
import 'package:web_admin_san/feature/orders_page/presentation/pages/orders_page_widgets/widgets/filter_design_order_services_type.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class FiltersTabsWidgetOrderServicesType extends StatefulWidget {
  final List<filterOrdersModel> filterOptions;

  const FiltersTabsWidgetOrderServicesType({
    super.key,
    required this.filterOptions,
  });

  @override
  State<FiltersTabsWidgetOrderServicesType> createState() =>
      _FiltersTabsWidgetOrderServicesTypeState();
}

class _FiltersTabsWidgetOrderServicesTypeState
    extends State<FiltersTabsWidgetOrderServicesType>
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
        if (context.read<TabsCubit>().state != tabIndex) {
          context.read<TabsCubit>().changeTab(tabIndex);
          context.read<GetOrderCubit>().getOrders(
                orderType: mapOrderType(tabIndex),
                pageNumber: 1,
              );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TabsCubit, int>(
      listener: (context, selectedIndex) {
        if (_tabController.index != selectedIndex &&
            selectedIndex < widget.filterOptions.length) {
          _tabController.animateTo(selectedIndex);
        }
      },
      child: BlocBuilder<TabsCubit, int>(
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
                overlayColor: WidgetStateColor.transparent,
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
                    (index) => const FilterDesignOrderServicesType(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
