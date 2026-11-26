import 'package:web_admin_san/generated/locale_keys.g.dart';

class filterOrdersModel {
  final String text;
  bool isSelected;
  filterOrdersModel({required this.text, this.isSelected = false});
}

final List<filterOrdersModel> filterOrders = [
  filterOrdersModel(text: LocaleKeys.allOrdersKey, isSelected: true),
  filterOrdersModel(text: LocaleKeys.newOrdersKey),
  filterOrdersModel(text: LocaleKeys.underServiceKey),
  filterOrdersModel(text: LocaleKeys.completedOrders),
];

final List<filterOrdersModel> filterOptionsCars = [
  filterOrdersModel(text: LocaleKeys.allCars, isSelected: true),
  filterOrdersModel(text: LocaleKeys.newCars),
  filterOrdersModel(text: LocaleKeys.usedCars),
  filterOrdersModel(text: LocaleKeys.soldCars),
];
