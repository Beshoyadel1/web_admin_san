import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../../features/order_services/presentation/custom_widget/app_pagination.dart';
import '../../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../../features/cars_haraj_page/data/model/car_filter/car_filter.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/bloc/get_all_harage_cubit/get_all_harage_state.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/bloc/get_user_harages_cubit/get_user_harages_cubit.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/bloc/get_user_harages_cubit/get_user_harages_state.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/ui/page_details_provider_harag/screens/details_harag_page/details_harag_page.dart';
import '../../cars_haraj_statistics_page/screens/available_cars.dart';
import '../../../../../../../../../features/internal_services/presentation/cubit/tabs_cubit/tabs_cubit.dart';

class FilterDesignCarList extends StatelessWidget {
  final int providerID;
  const FilterDesignCarList({super.key,required this.providerID});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserHaragesCubit, GetUserHaragesState>(
      builder: (context, state) {

        if (state is GetUserHaragesError) {
          return Center(child: Text(state.error));
        }

        List cars = [];
        int currentPage = 1;
        int totalPages = 1;

        if (state is GetUserHaragesSuccess) {
          final selectedTab = context.watch<TabsCubit>().state;

          final allCars = state.data;

          cars = CarFilter.filterCars(
            allCars,
            selectedTab,
          );

          currentPage = state.currentPage;
          totalPages = state.pageCount;
        }
        if (state is GetAllHarageLoading) {
          const  Center(
            child: CircularProgressIndicator(),
          );
        }
        if (cars.isEmpty) {
          return const Center(
            child:  TextInAppWidget(
              text: AppLanguageKeys.empty,
              textSize: 15,
              textColor: AppColors.greyColor,
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: cars.length,
                itemBuilder: (context, index) {

                  final car = cars[index];

                  final isEnglish =
                      Localizations.localeOf(context).languageCode == 'en';

                  final brandNameTitle = isEnglish
                      ? (car.car?.brandLatinName ?? "")
                      : (car.car?.brandName ?? "");

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AvailableCars(
                      id: car.id.toString(),
                      carImage: car.car?.carImage,
                      brandImage: car.car?.brandImage,
                      releaseDate: car.releaseDate,
                      addresstext: car.addressText,
                      isSold: car.isSold ?? false,
                      isNew: car.isNew ?? false,
                      brandName: brandNameTitle,
                      price: car.price?.toString() ?? "",
                      onTap: () async {

                        final result = await Navigator.push(
                          context,
                          NavigateToPageWidget(
                            DetailsHaragPage(car: car),
                          ),
                        );

                        if (result == true && context.mounted) {
                          context.read<GetUserHaragesCubit>()
                              .getUserHarages(pageNumber: currentPage,userId: providerID);
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            AppPagination(
              currentPage: currentPage,
              totalPages: totalPages,
              onPageChanged: (page) {
                context
                    .read<GetUserHaragesCubit>()
                    .getUserHarages(pageNumber: page,userId: providerID);
              },
            ),
          ],
        );
      },
    );
  }
}