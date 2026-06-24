import '../../../data/model/get_all_harage_model/harage_data.dart';

abstract class GetUserHaragesState {}

class GetUserHaragesInitial extends GetUserHaragesState {}

class GetUserHaragesLoading extends GetUserHaragesState {}

class GetUserHaragesSuccess extends GetUserHaragesState {
  final List<HarageData> data;
  final int currentPage;
  final int pageCount;
  final int totalCount;

  GetUserHaragesSuccess(
      this.data, {
        required this.currentPage,
        required this.pageCount,
        required this.totalCount,
      });
}

class GetUserHaragesError extends GetUserHaragesState {
  final String error;

  GetUserHaragesError(this.error);
}