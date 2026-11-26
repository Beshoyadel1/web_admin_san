import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/feature/store_page/view_model/cars_model_cubit/car_model_cubit/car_model_cubit.dart';
import 'package:web_admin_san/feature/store_page/view_model/cars_model_cubit/car_model_cubit/car_model_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';
import '../../custom_add_button.dart';
import 'add_car_model_ui.dart';
import 'all_cars_models_ui.dart';
import 'services_setting_ui.dart';

class BodyCarModel extends StatelessWidget {
  const BodyCarModel({super.key, required this.state});

  final CarModelState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextInAppWidget(
                    text: state is CarModelAddingNew
                        ? LocaleKeys.carModelsKey
                        : LocaleKeys.defineModelsKey,
                    textSize: 22,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.darkColor,
                  ),
                  TextInAppWidget(
                    text: state is CarModelAddingNew
                        ? LocaleKeys.serviceSettingsDetailsKey
                        : LocaleKeys.multipleCarsKey,
                    textSize: 16,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.darkColor,
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (state is CarModelAddingNew)
              CustomAddButton(
                width: 186,
                text: LocaleKeys.addNewCarKey,
                onTap: () {},
              )
          ],
        ),
        const SizedBox(height: 5),
        BlocBuilder<CarModelCubit, CarModelState>(
          builder: (context, state) {
            if (state is CarModelInitial) {
              return const AllCarsModelsUi();
            } else if (state is CarModelAdded) {
              return const AddCarModelUi();
            } else if (state is CarModelAddingNew) {
              return const ServicesSettingUi();
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
