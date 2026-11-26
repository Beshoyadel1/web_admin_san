import 'package:dio/dio.dart';

import 'package:web_admin_san/feature/internal_services/data/response/get_provider_main_service_statistics_response/statistics_response.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../model/get_provider_main_service_statistics_model/data_points_model.dart';
import '../../model/get_provider_main_service_statistics_model/sub_service_summaries_model.dart';
import '../../request/get_provider_main_service_statistics_request/get_provider_main_service_statistics_request.dart';

Future<StatisticsResponse> getProviderMainServiceStatisticsFunction({
  GetProviderMainServiceStatisticsRequest? request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request?.toJson() ?? {},
      ApiLink.getProviderMainServiceStatistics,
    );

    final data = response.data["data"] ?? {};

    final List servicesJson = data["subServiceSummaries"] ?? [];

    final services =
        servicesJson.map((e) => SubServiceSummariesModel.fromJson(e)).toList();

    final averageRate = (data["averageRate"] ?? 0).toDouble();

    final chartJson = data["salesChart"]?["dataPoints"] ?? [];

    final chartPoints =
        (chartJson as List).map((e) => DataPointsModel.fromJson(e)).toList();

    return StatisticsResponse(
      services: services,
      averageRate: averageRate,
      chartPoints: chartPoints,
    );
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );

    return StatisticsResponse(
      services: [],
      averageRate: 0,
      chartPoints: [],
    );
  }
}
