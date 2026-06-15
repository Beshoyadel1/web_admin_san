import 'package:dio/dio.dart';
import 'package:web_admin_san/features/order_services/data/model/get_admin_dashboard_statistics_model/get_admin_dashboard_statistics_model.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';

Future<DashboardData?> getAdminDashboardStatisticsFunction() async {
  try {
    final response = await Network.getData(
      ApiLink.getAdminDashboardStatistics,
    );

    final json = response.data as Map<String, dynamic>;

    if (json['success'] == true && json['data'] != null) {
      return DashboardData.fromJson(json['data']);
    }

    return null;
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );

    return null;
  }
}