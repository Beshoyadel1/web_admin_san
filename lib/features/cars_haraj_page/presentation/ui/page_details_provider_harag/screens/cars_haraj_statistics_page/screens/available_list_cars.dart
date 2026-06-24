import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/bloc/get_all_harage_cubit/get_all_harage_state.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/bloc/get_user_harages_cubit/get_user_harages_cubit.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/bloc/get_user_harages_cubit/get_user_harages_state.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/ui/page_details_provider_harag/screens/details_harag_page/details_harag_page.dart';
import 'available_cars.dart';


class AvailableListCars extends StatelessWidget {
  final int providerID;
  const AvailableListCars({super.key,required this.providerID});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserHaragesCubit, GetUserHaragesState>(
      builder: (context, state) {

        if (state is GetUserHaragesError) {
          return Center(child: Text(state.error));
        }

        List cars = [];

        if (state is GetUserHaragesSuccess) {
          cars = state.data ;
        }
        if (state is GetAllHarageLoading) {
          const Center(
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...List.generate(
              cars.length,
                  (index) {
                final car = cars[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 19),
                  child: AvailableCars(
                    id: car.id.toString(),
                    releaseDate: car.releaseDate,
                    carImage: car.car?.carImage,
                    brandImage: car.car?.brandImage,
                    addresstext: car.addressText,
                    isSold: car.isSold ?? false,
                    isNew: car.isNew ?? false,
                    brandName: car.car?.getBrand(context),
                    price: car.price.toString(),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        NavigateToPageWidget(
                          DetailsHaragPage(car: car),
                        ),
                      );

                      if (result == true && context.mounted) {
                        context.read<GetUserHaragesCubit>()
                            .getUserHarages(pageNumber: 1,userId: providerID);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}