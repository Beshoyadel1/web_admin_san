import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/loading_dashboard/loading_dashboard_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/loading_dashboard/loading_dashboard_state.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_new_order_in_list_data_first_screen_internal_orders.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/container_image_title_with_sub_title/first_row_with_two_container_image_and_two_text.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_interior_services_statistics/container_interior_services_statistics.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_profits_from_ministry_of_interior_services/container_profits_from_ministry_of_interior_services.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_rate_service/container_rate_service.dart';

class ListDataFirstScreenInternalOrders extends StatelessWidget {
  const ListDataFirstScreenInternalOrders({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobileCustom = size.width <= 720;
    bool isMobile =
        size.width <= ValuesOfAllApp.mobileWidth + 200 && size.width > 720;
    return BlocBuilder<InternalOrdersCubit, InternalOrdersState>(
      builder: (context, state) {
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const FirstRowWithTwoContainerImageAndTwoText(),
            ContainerNewOrderInListDataFirstScreenInternalOrders(
              onTap: () {
                AppCubit.get(context)
                    .navigateToPage(PagesOfAllApp.internalOrdersPageNumber);
              },
            ),
            if ((isMobile && !isMobileCustom))
              const Column(
                spacing: 10,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                          child:
                              ContainerProfitsFromMinistryOfInteriorServices()),
                      Expanded(child: ContainerRateService())
                    ],
                  ),
                  ContainerInteriorServicesStatistics(),
                ],
              ),
            if ((!isMobile && isMobileCustom))
              const Column(
                spacing: 10,
                children: [
                  ContainerProfitsFromMinistryOfInteriorServices(),
                  ContainerRateService(),
                  ContainerInteriorServicesStatistics(),
                ],
              ),
          ],
        );
      },
    );
  }
}
