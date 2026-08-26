import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../features/cars_haraj_page/data/datasource/get_all_harages_datasource/get_all_harages_datasource.dart';
import '../../../../../../../features/cars_haraj_page/data/datasource/get_car_details_datasource/get_car_details_datasource.dart';
import '../../../../../../../features/cars_haraj_page/data/model/get_car_details_model/get_car_details_model.dart';
import '../../../../../../../features/cars_haraj_page/data/request/get_all_harages_request/get_all_harages_request.dart';
import '../../../../../../../features/cars_haraj_page/data/request/get_car_details_request/get_car_details_request.dart';
import '../../../../../../../features/cars_haraj_page/data/response/get_all_harage_response/get_all_harage_response.dart';
import '../../../../../../../features/cars_haraj_page/presentation/bloc/harag_cubit/harag_state.dart';
import '../../../../../../../features/cars_haraj_page/data/request/get_harage_details_request/get_harage_details_request.dart';
import '../../../../../../../features/cars_haraj_page/data/response/get_harage_details_response/get_harage_details_response.dart';
import '../../../../../../../features/cars_haraj_page/data/datasource/get_harage_details_datasource/get_harage_details_datasource.dart';


class HaragCubit extends Cubit<HaragState> {
  HaragCubit()
      : super(
    const HaragInitial(),
  );

  GetAllHarageResponse? haragesResponse;

  GetHarageDetailsResponse? harageDetailsResponse;
  GetCarDetailsModel? carDetailsResponse;

  // ============================================================
// GET CAR DETAILS
// ============================================================

  Future<void> getCarDetails({
    required int carId,
  }) async {
    try {
      emit(
        const CarDetailsLoading(),
      );

      final response = await getCarDetailsFunction(
        request: GetCarDetailsRequest(
          carId: carId,
        ),
      );

      carDetailsResponse = response;

      emit(
        CarDetailsSuccess(
          response: response,
        ),
      );
    } catch (e) {
      carDetailsResponse = null;

      emit(
        CarDetailsError(
          message: e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
  // ============================================================
  // GET ALL HARAGES
  // ============================================================

  Future<void> getAllHarages({
    required int currentPage,
  }) async {
    final previousPageCount = state.pageCount;

    emit(
      HaragLoading(
        currentPage: currentPage,
        pageCount: previousPageCount,
      ),
    );

    try {
      final response = await getAllHaragesFunction(
        request: GetAllHaragesRequest(
          pageNumber: currentPage,
        ),
      );

      haragesResponse = response;

      emit(
        HaragSuccess(
          response: response,
          currentPage: response.currentPage,
          pageCount: response.pageCount,
        ),
      );
    } catch (e) {
      emit(
        HaragError(
          message: e
              .toString()
              .replaceFirst(
            'Exception: ',
            '',
          ),
          currentPage: currentPage,
          pageCount: previousPageCount,
        ),
      );
    }
  }

  // ============================================================
  // GET HARAGE DETAILS
  // ============================================================

  Future<void> getHarageDetails({
    required int harageId,
  }) async {
    try {
      emit(
        HaragDetailsLoading(
          currentPage: state.currentPage,
          pageCount: state.pageCount,
        ),
      );

      final response = await getHarageDetailsFunction(
        getHarageDetailsRequest: GetHarageDetailsRequest(
          harageId: harageId,
        ),
      );

      harageDetailsResponse = response;

      // ==========================================
      // GET CAR DETAILS
      // ==========================================

      final car = response?.data?.car;

      if (car != null && car.id != null) {
        await getCarDetails(
          carId: car.id!,
        );
      }

      // await getCarDetails(
      //   carId:1,
      // );
      emit(
        HaragDetailsSuccess(
          response: response,
          currentPage: state.currentPage,
          pageCount: state.pageCount,
        ),
      );
    } catch (e) {
      emit(
        HaragDetailsError(
          message: e
              .toString()
              .replaceFirst(
            'Exception: ',
            '',
          ),
          currentPage: state.currentPage,
          pageCount: state.pageCount,
        ),
      );
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refresh() async {
    await getAllHarages(
      currentPage: state.currentPage,
    );
  }
}