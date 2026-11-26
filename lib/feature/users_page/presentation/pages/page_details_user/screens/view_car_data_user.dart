import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';
import 'package:web_admin_san/feature/users_page/view_model/user_details_cubit/user_details_cubit.dart';
import 'package:web_admin_san/feature/users_page/view_model/user_details_cubit/user_details_state.dart';
import 'package:web_admin_san/feature/users_page/presentation/widgets/widget_design_car_user.dart';

class ViewCarDataUser extends StatelessWidget {
  const ViewCarDataUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: LocaleKeys.cars,
          textSize: 15,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.orangeColor,
        ),
        const SizedBox(height: 20),
        BlocBuilder<UserDetailsCubit, UserDetailsState>(
          builder: (context, state) {
            if (state is UserDetailsSuccess) {
              final cars = state.data.cars;

              if (cars.isEmpty) {
                return const TextEmptyViewData();
              }

              final width = MediaQuery.of(context).size.width;

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
                      (constraints.maxWidth - ((itemsPerRow - 1) * spacing)) /
                          itemsPerRow;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: cars.map((car) {
                      return SizedBox(
                        width: itemWidth,
                        child: WidgetDesignCarUser(
                          car: car,
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
