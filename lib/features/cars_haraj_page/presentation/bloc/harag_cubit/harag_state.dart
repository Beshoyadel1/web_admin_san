import 'package:equatable/equatable.dart';
import '../../../../../../../features/cars_haraj_page/data/model/get_car_details_model/get_car_details_model.dart';
import '../../../../../../../features/cars_haraj_page/data/response/get_all_harage_response/get_all_harage_response.dart';
import '../../../../../../../features/cars_haraj_page/data/response/get_harage_details_response/get_harage_details_response.dart';

abstract class HaragState extends Equatable {
  final int currentPage;
  final int pageCount;

  const HaragState({
    this.currentPage = 1,
    this.pageCount = 0,
  });

  @override
  List<Object?> get props => [
    currentPage,
    pageCount,
  ];
}

class HaragInitial extends HaragState {
  const HaragInitial();
}

class HaragLoading extends HaragState {
  const HaragLoading({
    required super.currentPage,
    required super.pageCount,
  });
}

class HaragSuccess extends HaragState {
  final GetAllHarageResponse response;

  const HaragSuccess({
    required this.response,
    required super.currentPage,
    required super.pageCount,
  });

  @override
  List<Object?> get props => [
    response,
    currentPage,
    pageCount,
  ];
}

class HaragError extends HaragState {
  final String message;

  const HaragError({
    required this.message,
    required super.currentPage,
    required super.pageCount,
  });

  @override
  List<Object?> get props => [
    message,
    currentPage,
    pageCount,
  ];
}

class HaragDetailsLoading extends HaragState {
  const HaragDetailsLoading({
    required super.currentPage,
    required super.pageCount,
  });
}

class HaragDetailsSuccess extends HaragState {
  final GetHarageDetailsResponse? response;

  const HaragDetailsSuccess({
    required this.response,
    required super.currentPage,
    required super.pageCount,
  });
}

class HaragDetailsError extends HaragState {
  final String message;

  const HaragDetailsError({
    required this.message,
    required super.currentPage,
    required super.pageCount,
  });
}
class CarDetailsLoading extends HaragState {
  const CarDetailsLoading();
}

class CarDetailsSuccess extends HaragState {
  final GetCarDetailsModel response;

  const CarDetailsSuccess({
    required this.response,
  });

  @override
  List<Object?> get props => [
    response,
  ];
}

class CarDetailsError extends HaragState {
  final String message;

  const CarDetailsError({
    required this.message,
  });

  @override
  List<Object?> get props => [
    message,
  ];
}