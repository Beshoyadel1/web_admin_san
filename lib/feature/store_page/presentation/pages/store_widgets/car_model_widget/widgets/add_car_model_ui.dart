import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/feature/store_page/view_model/cars_model_cubit/car_model_cubit/car_model_cubit.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../custom_add_button.dart';

class AddCarModelUi extends StatelessWidget {
  const AddCarModelUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        //   const CarsAdded(),
        CustomAddButton(
          width: 178,
          text: LocaleKeys.addCarModelKey,
          onTap: () {
            context.read<CarModelCubit>().startAddingNewCar();
          },
        ),
      ],
    );
  }
}
