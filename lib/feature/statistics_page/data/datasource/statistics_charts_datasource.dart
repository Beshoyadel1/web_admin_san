import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/most_requested_service_model.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/sales_commission_model.dart';

class StatisticsChartsDatasource {
  static Future<AdminSalesAndCommissionModel?> getSalesAndCommission({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final Map<String, dynamic> params = {};
      if (startDate != null) {
        params['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        params['endDate'] = endDate.toIso8601String();
      }

      final response = await Network.getDataWithParams(
        params,
        ApiLink.getAdminSalesAndCommission,
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
        return AdminSalesAndCommissionModel.fromJson(dataMap);
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

  static Future<List<MostRequestedServiceModel>?> getMostRequestedServices({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final Map<String, dynamic> params = {};
      if (startDate != null) {
        params['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        params['endDate'] = endDate.toIso8601String();
      }

      final response = await Network.getDataWithParams(
        params,
        ApiLink.getAdminMostRequestedServices,
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
        final list = dataField as List? ?? [];
        return list
            .map((e) => MostRequestedServiceModel.fromJson(
                e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}))
            .toList();
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
}
