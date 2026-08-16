import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/auth_page/data/datasource/get_user_info_datasource/get_user_info_datasource.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:web_admin_san/features/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/features/coupon/data/datasource/create_coupon_datasource/create_coupon_datasource.dart';
import 'package:web_admin_san/features/coupon/data/datasource/delete_coupon_datasource/delete_coupon_datasource.dart';
import 'package:web_admin_san/features/coupon/data/datasource/get_all_coupons_datasource/get_all_coupons_datasource.dart';
import 'package:web_admin_san/features/coupon/data/datasource/get_coupon_by_code_datasource/get_coupon_by_code_datasource.dart';
import 'package:web_admin_san/features/coupon/data/datasource/get_coupon_statistics_datasource/get_coupon_statistics_datasource.dart';
import 'package:web_admin_san/features/coupon/data/datasource/update_coupon_datasource/update_coupon_datasource.dart';
import 'package:web_admin_san/features/coupon/data/model/coupon_model/coupon_model.dart';
import 'package:web_admin_san/features/coupon/data/request/delete_coupon_request/delete_coupon_request.dart';
import 'package:web_admin_san/features/coupon/data/request/get_coupon_by_code_request/get_coupon_by_code_request.dart';
import 'package:web_admin_san/features/coupon/data/request/get_coupon_statistics_request/get_coupon_statistics_request.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  CouponCubit()
      : super(
    const CouponInitial(),
  );
  CouponWithProviderModel? currentCoupon;

  final Map<int, CreateUserRequest> providerUsers = {};

  List<CouponWithProviderModel> coupons = [];

  Future<void> getCouponStatistics({
    required GetCouponStatisticsRequest request,
  }) async {
    if (isClosed) return;

    if (request.couponId <= 0) {
      emit(
        const CouponStatisticsFailure(
          message: 'Coupon ID is required',
        ),
      );
      return;
    }

    emit(
      const CouponStatisticsLoading(),
    );

    try {
      final result = await getCouponStatisticsFunction(
        request: request,
      );

      if (isClosed) return;

      emit(
        CouponStatisticsSuccess(
          statistics: result,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        CouponStatisticsFailure(
          message: e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  Future<void> deleteCoupon({
    required int couponId,
  }) async {
    if (isClosed) return;

    if (couponId <= 0) {
      emit(
        const CouponFailure(
          message: 'Coupon ID is required for delete',
        ),
      );
      return;
    }

    emit(const CouponLoading());

    try {
      await deleteCouponFunction(
        request: DeleteCouponRequest(
          couponId: couponId,
        ),
      );

      if (isClosed) return;

      if (currentCoupon?.coupon.couponId == couponId) {
        currentCoupon = null;
      }

      // Get fresh list
      final result = await getAllCouponsFunction();

      if (isClosed) return;

      coupons = List<CouponWithProviderModel>.from(
        result,
      );

      emit(
        CouponGetAllSuccess(
          coupons: coupons,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        CouponFailure(
          message: e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
  // =========================================
  Future<void> updateCoupon({
    required CouponWithProviderModel couponData,
  }) async {
    if (isClosed) return;

    final couponId = couponData.coupon.couponId;

    if (couponId == null || couponId <= 0) {
      emit(
        const CouponFailure(
          message: 'Coupon ID is required for update',
        ),
      );
      return;
    }

    final updateRequest = CouponWithProviderModel(
      coupon: CouponModel(
        couponId: couponId,
        couponCode: couponData.coupon.couponCode,
        discountType: couponData.coupon.discountType,
        discountValue: couponData.coupon.discountValue,
        isActive: couponData.coupon.isActive,
        maxDiscountValue:
        couponData.coupon.maxDiscountValue,
        minValueToApply:
        couponData.coupon.minValueToApply,
        couponStartDate:
        couponData.coupon.couponStartDate,
        couponEndDate:
        couponData.coupon.couponEndDate,
        usersUseCount:
        couponData.coupon.usersUseCount,
        oneUserUseCount:
        couponData.coupon.oneUserUseCount,
      ),
      providers: couponData.providers,
    );

    emit(
      const CouponLoading(),
    );

    try {
      await updateCouponFunction(
        request: updateRequest,
      );

      if (isClosed) return;

      emit(
        const CouponUpdateSuccess(),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        CouponFailure(
          message: e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }


  Future<void> getAllCoupons() async {
    if (isClosed) return;

    emit(const CouponLoading());

    try {
      final result = await getAllCouponsFunction();

      if (isClosed) return;

      coupons = List<CouponWithProviderModel>.from(result);

      emit(
        CouponGetAllSuccess(
          coupons: coupons,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        CouponFailure(
          message: e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  Future<void> createCoupon({
    required CouponModel coupon,
    required List<int> providers,
  }) async {
    if (isClosed) return;

    emit(
      const CouponLoading(),
    );

    try {
      final couponId =
      await createCouponFunction(
        request: CouponWithProviderModel(
          coupon: coupon,
          providers: providers,
        ),
      );

      if (isClosed) return;

      emit(
        CouponCreateSuccess(
          couponId: couponId,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        CouponFailure(
          message: e.toString()
              .replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
  Future<void> getCouponByCode({
    required String couponCode,
    required int userId,
  }) async {
    if (isClosed) return;

    emit(
      const CouponLoading(),
    );

    try {
      final result = await getCouponByCodeFunction(
        request: GetCouponByCodeRequest(
          couponCode: couponCode,
          userId: userId,
        ),
      );

      if (isClosed) return;

      currentCoupon = result;

// =========================================
// COUPON DATA
// =========================================

      emit(
        CouponGetByCodeSuccess(
          coupon: result,
        ),
      );

      if (isClosed) return;

// =========================================
// STATISTICS
// =========================================

      final couponId = result.coupon.couponId;

      if (couponId != null && couponId > 0) {
        await getCouponStatistics(
          request: GetCouponStatisticsRequest(
            couponId: couponId,
          ),
        );
      }

      if (isClosed) return;

// =========================================
// PROVIDERS
// =========================================

      await getProvidersInfo(
        providerIds: result.providers,
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        CouponFailure(
          message: e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  Future<void> getProvidersInfo({
    required List<int> providerIds,
  }) async {
    if (isClosed) return;

    try {
      for (final providerId in providerIds) {
        if (providerId <= 0) continue;

        if (providerUsers.containsKey(providerId)) {
          continue;
        }

        final provider = await getUserInfoFunction(
          request: GetUserInfoRequest(
            userId: providerId,
            userType: 4,
          ),
        );

        if (isClosed) return;

        providerUsers[providerId] = provider;
      }

      if (isClosed) return;

      emit(
        CouponProvidersLoaded(
          providers: Map<int, CreateUserRequest>.from(
            providerUsers,
          ),
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        CouponFailure(
          message: e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
}