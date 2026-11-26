import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_admin_dashboard_statistics_model/get_admin_dashboard_statistics_model.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';

Future<DashboardData?> getAdminDashboardStatisticsFunction() async {
  try {
    final response = await Network.getData(
      ApiLink.getAdminDashboardStatistics,
    );

    dynamic raw = response.data;
    if (raw is String) {
      try {
        raw = jsonDecode(raw);
      } catch (_) {}
    }

    final json =
        raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    final success = json['success'] == true || json['Success'] == true;
    final dataField = json['data'] ?? json['Data'];

    if (success && dataField != null) {
      final dataMap = dataField is Map
          ? Map<String, dynamic>.from(dataField)
          : <String, dynamic>{};
      return DashboardData.fromJson(dataMap);
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
