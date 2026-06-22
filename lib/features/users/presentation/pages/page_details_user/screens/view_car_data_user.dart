import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/users/presentation/bloc/user_details_cubit/user_details_cubit.dart';
import 'package:web_admin_san/features/users/presentation/bloc/user_details_cubit/user_details_state.dart';
import 'package:web_admin_san/features/users/presentation/custom_widget/widget_design_car_user.dart';


class ViewCarDataUser extends StatelessWidget {
  const ViewCarDataUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.cars,
          textSize: 15,
          fontWeightIndex:
          FontSelectionData.mediumFontFamily,
          textColor: AppColors.orangeColor,
        ),

        const SizedBox(height: 20),
        BlocBuilder<UserDetailsCubit, UserDetailsState>(
          builder: (context, state) {

            if (state is UserDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UserDetailsFailure) {
              return Center(
                child: Text(
                  state.error,
                ),
              );
            }

            if (state is UserDetailsSuccess) {
              final cars = state.data.cars;

              if (cars.isEmpty) {
                return const TextEmptyViewData();
              }

              final width =
                  MediaQuery.of(context).size.width;

              int itemsPerRow = 3;

              if (width < 765) {
                itemsPerRow = 1;
              } else if (width < 1072) {
                itemsPerRow = 2;
              }

              const spacing = 10.0;

              return LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth =
                      (constraints.maxWidth -
                          ((itemsPerRow - 1) *
                              spacing)) /
                          itemsPerRow;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: cars.map((car) {
                      return SizedBox(
                        width: itemWidth,
                        child: WidgetDesignCarUser(
                          imageCar: car.brandImage,
                          name: car.name,
                          plateNo: car.plateNo,
                          isDefault:
                          car.isDefault,
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            }

            return const SizedBox();
          },
        )
      ],
    );
  }
}