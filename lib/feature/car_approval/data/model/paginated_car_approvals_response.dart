import 'car_approval_request_item_model.dart';

class PaginatedCarApprovalsResponse {
  final List<CarApprovalRequestItemModel> data;
  final int totalCount;
  final int pageCount;
  final int currentPage;

  const PaginatedCarApprovalsResponse({
    required this.data,
    required this.totalCount,
    required this.pageCount,
    required this.currentPage,
  });

  factory PaginatedCarApprovalsResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] ?? json['Data'] ?? [];
    final items = <CarApprovalRequestItemModel>[];
    if (rawList is List) {
      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          items.add(CarApprovalRequestItemModel.fromJson(item));
        } else if (item is Map) {
          items.add(CarApprovalRequestItemModel.fromJson(
              Map<String, dynamic>.from(item)));
        }
      }
    }

    int parseInt(dynamic val, [int fallback = 0]) {
      if (val == null) return fallback;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString()) ?? fallback;
    }

    return PaginatedCarApprovalsResponse(
      data: items,
      totalCount: parseInt(json['totalCount'] ?? json['TotalCount']),
      pageCount: parseInt(json['pageCount'] ?? json['PageCount']),
      currentPage: parseInt(json['currentPage'] ?? json['CurrentPage'], 1),
    );
  }
}
