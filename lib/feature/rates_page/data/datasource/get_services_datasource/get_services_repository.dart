import 'package:dio/dio.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import '../../model/get_services_model/service_setting_model.dart';

Future<List<ServiceSettingModel>> getServicesFunction() async {
  try {
    final response = await Network.getData(ApiLink.getServices);

    final List data = response.data['data'] ?? [];

    return data
        .map((e) => ServiceSettingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
