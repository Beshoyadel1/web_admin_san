import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../../core/cubit/app_cubit/app_cubit.dart';
import '../../../../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/bloc/get_user_harages_cubit/get_user_harages_cubit.dart';
import 'available_list_cars.dart';
import '../../../../../../../../../features/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import '../../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../../../../core/theming/text_styles.dart';

class ListOfCars extends StatefulWidget {
  final int providerID;
  const ListOfCars({super.key,required this.providerID});

  @override
  State<ListOfCars> createState() => _ListOfCarsState();
}

class _ListOfCarsState extends State<ListOfCars> {

  late final GetUserHaragesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = GetUserHaragesCubit()
      ..getUserHarages(pageNumber: 1,userId: widget.providerID);
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return BlocProvider.value(
      value: cubit,
      child: CustomContainer(
        containerWidth:double.infinity,
        isSelected: false,
        onTap: () {},
        typeWidget: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const  Padding(
              padding:  EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInAppWidget(
                          text: AppLanguageKeys.carList,
                          textSize: 20,
                        ),
                        TextInAppWidget(
                          text: AppLanguageKeys.availableCarsShortList,
                          textSize: 16,
                        ),
                      ],
                    ),
                    // ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders(
                    //   onTap: () {
                    //     AppCubit.get(context).navigateToPage(
                    //       PagesOfAllApp.carHarajOrdersPageNumber,
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),

             AvailableListCars(
                providerID:widget.providerID
            ),
          ],
        ),
      ),
    );
  }
}