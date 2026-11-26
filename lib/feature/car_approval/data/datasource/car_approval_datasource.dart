import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../model/car_approval_request_details_model.dart';
import '../model/paginated_car_approvals_response.dart';
import '../request/reject_car_request_dto.dart';

class CarApprovalDatasource {
  const CarApprovalDatasource();

  /// Fetches paginated car approval requests with optional status, type, and search filters.
  Future<PaginatedCarApprovalsResponse> getPendingRequests({
    int? status,
    int? requestType,
    String? searchTerm,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };

      if (status != null) {
        queryParams['status'] = status;
      }
      if (requestType != null) {
        queryParams['requestType'] = requestType;
      }
      if (searchTerm != null && searchTerm.trim().isNotEmpty) {
        queryParams['searchTerm'] = searchTerm.trim();
      }

      final response = await Network.getDataWithParams(
        queryParams,
        ApiLink.getPendingCarRequests,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final bool success = responseData['success'] ?? true;
        if (!success) {
          throw Exception(responseData['message'] ??
              LocaleKeys.failedToFetchCarApprovals.tr());
        }
        final data = responseData['data'] ?? responseData;
        return PaginatedCarApprovalsResponse.fromJson(
          data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data),
        );
      } else if (responseData is Map) {
        return PaginatedCarApprovalsResponse.fromJson(
            Map<String, dynamic>.from(responseData));
      }

      throw Exception(LocaleKeys.invalidServerResponseFormat.tr());
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.message)
          : e.message;
      throw Exception(msg ?? LocaleKeys.errorConnectingToServer.tr());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Fetches comprehensive request details including owner, licence image, and live car for comparison.
  Future<CarApprovalRequestDetailsModel> getRequestDetails({
    required int requestId,
    String lang = 'ar',
  }) async {
    try {
      final response = await Network.getDataWithParams(
        {
          'requestId': requestId,
          'lang': lang,
        },
        ApiLink.getCarRequestDetails,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final bool success = responseData['success'] ?? true;
        if (!success) {
          throw Exception(responseData['message'] ??
              LocaleKeys.failedToFetchRequestDetails.tr());
        }
        final data = responseData['data'] ?? responseData;
        return CarApprovalRequestDetailsModel.fromJson(
          data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data),
        );
      } else if (responseData is Map) {
        return CarApprovalRequestDetailsModel.fromJson(
            Map<String, dynamic>.from(responseData));
      }

      throw Exception(LocaleKeys.invalidServerResponseFormat.tr());
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.message)
          : e.message;
      throw Exception(msg ?? LocaleKeys.errorConnectingToServer.tr());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Approves a pending car creation or update request.
  Future<String> approveRequest({
    required int requestId,
    int? adminId,
    String lang = 'ar',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'requestId': requestId,
        'lang': lang,
      };
      if (adminId != null && adminId > 0) {
        queryParams['adminId'] = adminId;
      }

      final response = await Network.postDataWithQuery(
        queryParams,
        ApiLink.approveCarRequest,
      );

      final responseData = response.data;
      if (responseData is Map) {
        final bool success = responseData['success'] ?? true;
        final message = responseData['message']?.toString() ??
            LocaleKeys.requestApprovedSuccessfully.tr();
        if (!success) {
          throw Exception(message);
        }
        return message;
      }

      return LocaleKeys.requestApprovedSuccessfully.tr();
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.message)
          : e.message;
      throw Exception(msg ?? LocaleKeys.failedToApproveRequest.tr());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Rejects a pending car request with a mandatory rejection reason.
  Future<String> rejectRequest({
    required RejectCarRequestDto request,
    String lang = 'ar',
  }) async {
    try {
      final response = await Network.postDataWithBodyAndParams(
        request.toJson(),
        {'lang': lang},
        ApiLink.rejectCarRequest,
      );

      final responseData = response.data;
      if (responseData is Map) {
        final bool success = responseData['success'] ?? true;
        final message = responseData['message']?.toString() ??
            LocaleKeys.requestRejectedSuccessfully.tr();
        if (!success) {
          throw Exception(message);
        }
        return message;
      }

      return LocaleKeys.requestRejectedSuccessfully.tr();
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.message)
          : e.message;
      throw Exception(msg ?? LocaleKeys.failedToRejectRequest.tr());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
