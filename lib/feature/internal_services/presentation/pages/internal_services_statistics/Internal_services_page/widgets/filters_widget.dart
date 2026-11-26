import 'package:flutter/material.dart';

import 'package:web_admin_san/feature/internal_services/view_model/new_orders_cubit/new_orders_cubit.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/filter_orders_model/filter_orders_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class FiltersOrdersWidget extends StatelessWidget {
  FiltersOrdersWidget({super.key, required this.filterOptions, this.cubit});

  final List<filterOrdersModel> filterOptions;
  final NewOrdersCubit? cubit;

  late final ValueNotifier<List<filterOrdersModel>> filterOptionsNotifier =
      ValueNotifier(filterOptions);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 10,
        runSpacing: 10,
        children: [
          Wrap(
              spacing: 15,
              runSpacing: 5,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                ...List.generate(filterOptions.length, (index) {
                  return ValueListenableBuilder<List<filterOrdersModel>>(
                    valueListenable: filterOptionsNotifier,
                    builder: (context, options, _) {
                      final option = options[index];
                      return CustomContainer(
                        containerWidth: 150,
                        isSelected: option.isSelected,
                        onTap: () {
                          for (var i = 0; i < options.length; i++) {
                            options[i].isSelected = i == index;
                          }
                          filterOptionsNotifier.value = [...options];
                        },
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        containerColor: option.isSelected
                            ? AppColors.orangeColor
                            : AppColors.greyColor,
                        border: const Border(),
                        typeWidget: Center(
                          child: TextInAppWidget(
                            text: option.text,
                            textSize: 16,
                            textColor: AppColors.whiteColor,
                          ),
                        ),
                      );
                    },
                  );
                })
              ]),
          const TextInAppWidget(
            text: LocaleKeys.priceKey,
            textSize: 20,
            textColor: AppColors.orangeColor,
          ),
        ],
      ),
    );
  }
}
