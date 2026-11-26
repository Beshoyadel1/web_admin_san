import 'package:dio/dio.dart';

import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import '../../model/get_car_brand_models_model/car_brand_data_model.dart';

Future<List<CarBrandDataModel>> getCarBrandFunction() async {
  try {
    final response = await Network.getData(ApiLink.getCarBrand);

    final List data = response.data['data'] ?? [];

    return data
        .map((e) => CarBrandDataModel.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (e) {
    throw e is DioException
        ? responseOfStatusCode(e.response?.statusCode)
        : e.toString();
  }
}
