import 'dart:ui';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_provider_harage_sold_cars_by_type_model/get_provider_harage_sold_cars_by_type_model.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';

class ChartDataModel {
  final String label;
  final int percentage;
  final Color color;

  ChartDataModel({
    required this.label,
    required this.percentage,
    required this.color,
  });
}

final List<ChartDataModel> data = [
  ChartDataModel(
    label: LocaleKeys.newCars,
    percentage: 60,
    color: AppColors.orangeColor,
  ),
  ChartDataModel(
    label: LocaleKeys.usedCars,
    percentage: 30,
    color: AppColors.lightBlueColor,
  ),
];

List<ChartDataModel> mapSoldCarsToChartData(
  GetProviderHarageSoldCarsByTypeModel model,
) {
  final total = model.newCarsCount + model.usedCarsCount;

  if (total == 0) {
    return [
      ChartDataModel(
        label: LocaleKeys.newCars,
        percentage: 0,
        color: AppColors.orangeColor,
      ),
      ChartDataModel(
        label: LocaleKeys.usedCars,
        percentage: 0,
        color: AppColors.lightBlueColor,
      ),
    ];
  }

  return [
    ChartDataModel(
      label: LocaleKeys.newCars,
      percentage: ((model.newCarsCount / total) * 100).round(),
      color: AppColors.orangeColor,
    ),
    ChartDataModel(
      label: LocaleKeys.usedCars,
      percentage: ((model.usedCarsCount / total) * 100).round(),
      color: AppColors.lightBlueColor,
    ),
  ];
}
