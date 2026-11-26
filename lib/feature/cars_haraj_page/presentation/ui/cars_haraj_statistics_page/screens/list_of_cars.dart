import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'available_list_cars.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class ListOfCars extends StatefulWidget {
  final int providerId;
  const ListOfCars({super.key, required this.providerId});

  @override
  State<ListOfCars> createState() => _ListOfCarsState();
}

class _ListOfCarsState extends State<ListOfCars> {
  late final HaragCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = HaragCubit()
      ..getUserHarages(currentPage: 1, userId: widget.providerId);
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return BlocProvider.value(
      value: cubit,
      child: CustomContainer(
        containerWidth: isMobile ? double.infinity : 860,
        isSelected: false,
        onTap: () {},
        typeWidget: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInAppWidget(
                          text: LocaleKeys.carList,
                          textSize: 20,
                        ),
                        TextInAppWidget(
                          text: LocaleKeys.availableCarsShortList,
                          textSize: 16,
                        ),
                      ],
                    ),
                    ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders(
                      onTap: () {
                        AppCubit.get(context).navigateToPage(
                          PagesOfAllApp.carHarajOrdersPageNumber,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            AvailableListCars(
              providerId: widget.providerId,
            ),
          ],
        ),
      ),
    );
  }
}
