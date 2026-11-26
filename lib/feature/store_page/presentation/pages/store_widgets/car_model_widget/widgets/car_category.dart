import 'package:web_admin_san/feature/store_page/view_model/cars_model_cubit/car_model_cubit/car_model_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/text_form_field_widget.dart';

class CarCategory extends StatelessWidget {
  const CarCategory({super.key, this.textController});

  final TextEditingController? textController;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SizedBox(
        width: 270,
        child: TextFormFieldWidget(
          textFormHeight: 35,
          contentPadding: const EdgeInsets.all(0),
          text: LocaleKeys.selectCarModelKey,
          textFormController: textController ?? TextEditingController(),
          hintText: LocaleKeys.searchCarModelKey,
          hintTextSize: 12,
          hintTextColor: AppColors.greyColor,
          //prefixIcon: AppImageKeys.searchIcon,
          prefixIconWidth: 19,
          prefixIconHeight: 19,
          textSize: 14,
          textColor: AppColors.darkGreyColor,
          isColumn: true,
          fillColor: AppColors.whiteColor,
          borderColor: AppColors.lightGreyColor,
          //borderRadius: 24,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          isValidator: true,
          onChanged: (value) {
            context.read<CarModelCubit>().changeCar(value);
          },
        ),
      );
    });
  }
}
