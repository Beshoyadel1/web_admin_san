import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../model/delivery_order_model.dart';
import '../model/delivery_setting_model.dart';

class DeliverySettingDatasource {
  const DeliverySettingDatasource();

  /// Fetches delivery settings and total order counts
  Future<DeliveryInfoModel> getDeliveryInfo() async {
    try {
      final response = await Network.getData(ApiLink.getDeliveryInfo);
      final responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        final bool success = responseData['success'] ?? true;
        if (!success) {
          throw Exception(
              responseData['message'] ?? 'Failed to load delivery info');
        }
        final data = responseData['data'] ?? responseData;
        return DeliveryInfoModel.fromJson(
          data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data),
        );
      } else if (responseData is Map) {
        return DeliveryInfoModel.fromJson(
            Map<String, dynamic>.from(responseData));
      }

      throw Exception(LocaleKeys.invalidServerResponseFormat.tr());
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.message)
          : e.message;
      throw Exception(msg ?? 'Connection error');
    }
  }

  /// Updates delivery cost, price, and enabled status
  Future<String> updateDeliverySetting({
    required double deliveryCost,
    required double deliveryPrice,
    required bool isDeliveryEnabled,
    String lang = 'ar',
  }) async {
    try {
      final body = {
        'DELIVERYCOST': deliveryCost,
        'DELIVERYPRICE': deliveryPrice,
        'ISDELIVERYENABLED': isDeliveryEnabled,
      };

      final response = await Network.postDataWithBodyAndParams(
        body,
        {'lang': lang},
        ApiLink.updateDeliverySetting,
      );

      final responseData = response.data;
      if (responseData is Map) {
        final bool success = responseData['success'] ?? true;
        final String message = (responseData['message'] ?? '').toString();
        if (!success) {
          throw Exception(message.isNotEmpty
              ? message
              : 'Failed to update delivery settings');
        }
        return message;
      }
      return '';
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.message)
          : e.message;
      throw Exception(msg ?? 'Connection error');
    }
  }

  /// Fetches paginated delivery orders with optional status and search filters
  Future<DeliveryOrderPaginatedResponse> getDeliveryOrders({
    int pageNumber = 1,
    int pageSize = 10,
    String? status,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final response = await Network.getDataWithParams(
        queryParams,
        ApiLink.getDeliveryOrders,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final bool success = responseData['success'] ?? true;
        if (!success) {
          throw Exception(
              responseData['message'] ?? 'Failed to fetch delivery orders');
        }
        final data = responseData['data'] ?? responseData;
        return DeliveryOrderPaginatedResponse.fromJson(
          data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data),
        );
      } else if (responseData is Map) {
        return DeliveryOrderPaginatedResponse.fromJson(
          Map<String, dynamic>.from(responseData),
        );
      }

      throw Exception(LocaleKeys.invalidServerResponseFormat.tr());
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.message)
          : e.message;
      throw Exception(msg ?? 'Connection error');
    }
  }

  /// Cancels an active delivery order via MrMandoob
  Future<String> cancelDeliveryOrder({
    required int orderId,
    required String reason,
    String lang = 'ar',
  }) async {
    try {
      final queryParams = {
        'orderId': orderId,
        'reason': reason,
        'lang': lang,
      };

      final response = await Network.postDataWithQuery(
        queryParams,
        ApiLink.cancelDeliveryOrder,
      );

      final responseData = response.data;
      if (responseData is Map) {
        final bool success = responseData['success'] ?? true;
        final String message = (responseData['message'] ?? '').toString();
        if (!success) {
          throw Exception(
              message.isNotEmpty ? message : 'Failed to cancel delivery order');
        }
        return message;
      }
      return '';
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.message)
          : e.message;
      throw Exception(msg ?? 'Connection error');
    }
  }
}
