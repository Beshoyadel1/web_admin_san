import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/core/networking/network.dart';
import '../../model/settlement_model/settlement_model.dart';
import '../../request/create_settlement_request/create_settlement_request.dart';

class SettlementDatasource {
  const SettlementDatasource();

  /// Fetches previous settlements for a specific service provider.
  Future<List<SettlementModel>> getProviderSettlements({
    required int providerId,
  }) async {
    try {
      final response = await Network.getDataWithParams(
        {'providerId': providerId},
        ApiLink.getProviderSettlements,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final bool success = responseData['success'] ?? true;
        if (!success) {
          throw Exception(responseData['message'] ?? 'فشل جلب سجل التسويات');
        }
        final list = responseData['data'] as List? ?? [];
        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => SettlementModel.fromJson(e))
            .toList();
      } else if (responseData is List) {
        return responseData
            .whereType<Map<String, dynamic>>()
            .map((e) => SettlementModel.fromJson(e))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        throw Exception(data['message'].toString());
      }
      throw Exception(responseOfStatusCode(e.response?.statusCode));
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Creates and executes a new settlement with the provider.
  Future<String> createSettlement({
    required CreateSettlementRequest request,
  }) async {
    try {
      final response = await Network.postDataWithBodyAndParams(
        {},
        request.toJson(),
        ApiLink.createSettlement,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final bool success = responseData['success'] ?? true;
        if (!success) {
          throw Exception(responseData['message'] ?? 'فشل تنفيذ عملية التسوية');
        }
        return responseData['message']?.toString() ?? 'تمت التسوية بنجاح';
      }

      return 'تمت التسوية بنجاح';
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        throw Exception(data['message'].toString());
      }
      if (data is Map && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          throw Exception(firstError.first.toString());
        }
      }
      throw Exception(responseOfStatusCode(e.response?.statusCode));
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
