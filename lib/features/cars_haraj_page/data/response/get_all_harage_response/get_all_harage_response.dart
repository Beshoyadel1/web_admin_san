import 'package:web_admin_san/features/cars_haraj_page/data/model/get_all_harage_model/harage_data.dart';

class GetAllHarageResponse {
  final List<HarageData> data;
  final int pageCount;
  final int totalCount;
  final int currentPage;

  GetAllHarageResponse({
    required this.data,
    required this.pageCount,
    required this.totalCount,
    required this.currentPage,
  });

  factory GetAllHarageResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    final responseData =
        json['data'] as Map<String, dynamic>? ?? {};

    return GetAllHarageResponse(
      data: (responseData['data'] as List<dynamic>? ?? [])
          .map(
            (e) => HarageData.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList(),

      pageCount:
      (responseData['pageCount'] ?? 0).toInt(),

      totalCount:
      (responseData['totalCount'] ?? 0).toInt(),

      currentPage:
      (responseData['currentPage'] ?? 1).toInt(),
    );
  }
}