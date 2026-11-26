import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/auth_page/data/datasource/get_user_info_datasource/get_user_info_datasource.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:web_admin_san/feature/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/feature/coupons_page/data/datasource/create_coupon_datasource/create_coupon_datasource.dart';
import 'package:web_admin_san/feature/coupons_page/data/datasource/delete_coupon_datasource/delete_coupon_datasource.dart';
import 'package:web_admin_san/feature/coupons_page/data/datasource/get_all_coupons_datasource/get_all_coupons_datasource.dart';
import 'package:web_admin_san/feature/coupons_page/data/datasource/get_coupon_by_code_datasource/get_coupon_by_code_datasource.dart';
import 'package:web_admin_san/feature/coupons_page/data/datasource/get_coupon_details_datasource/get_coupon_details_datasource.dart';
import 'package:web_admin_san/feature/coupons_page/data/datasource/get_coupon_statistics_datasource/get_coupon_statistics_datasource.dart';
import 'package:web_admin_san/feature/coupons_page/data/datasource/update_coupon_datasource/update_coupon_datasource.dart';
import 'package:web_admin_san/feature/coupons_page/data/model/coupon_model/coupon_model.dart';
import 'package:web_admin_san/feature/coupons_page/data/request/delete_coupon_request/delete_coupon_request.dart';
import 'package:web_admin_san/feature/coupons_page/data/request/get_coupon_by_code_request/get_coupon_by_code_request.dart';
import 'package:web_admin_san/feature/coupons_page/data/request/get_coupon_details_request/get_coupon_details_request.dart';
import 'package:web_admin_san/feature/coupons_page/data/request/get_coupon_statistics_request/get_coupon_statistics_request.dart';
import 'package:web_admin_san/feature/coupons_page/view_model/coupon_cubit/coupon_state.dart';
import 'package:web_admin_san/feature/providers_page/data/datasource/get_all_providers_datasource/get_all_providers_datasource.dart';
import 'package:web_admin_san/feature/providers_page/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';
import 'package:web_admin_san/feature/providers_page/data/request/get_all_providers_request/get_all_providers_request.dart';

import 'package:web_admin_san/feature/coupons_page/data/model/coupons_filter_criteria.dart';

class CouponCubit extends Cubit<CouponState> {
  CouponCubit()
      : super(
          const CouponInitial(),
        );
  CouponWithProviderModel? currentCoupon;

  final Map<int, CreateUserRequest> providerUsers = {};

  List<CouponWithProviderModel> coupons = [];
  String _searchQuery = '';
  CouponsFilterCriteria _criteria = CouponsFilterCriteria.empty;
  CouponsFilterCriteria get currentCriteria => _criteria;

  List<CouponWithProviderModel> get filteredCoupons {
    return coupons.where((c) {
      final code = (c.coupon.couponCode ?? '').toLowerCase();
      final matchesSearch = _searchQuery.isEmpty || code.contains(_searchQuery);
      final matchesActive =
          _criteria.isActive == null || c.coupon.isActive == _criteria.isActive;

      bool matchesDate = true;
      if (_criteria.startDate != null || _criteria.endDate != null) {
        final cStart = c.coupon.couponStartDate;
        final cEnd = c.coupon.couponEndDate;

        if (_criteria.startDate != null) {
          final startDay = DateTime(
            _criteria.startDate!.year,
            _criteria.startDate!.month,
            _criteria.startDate!.day,
          );
          if (cStart != null && cStart.isBefore(startDay)) {
            matchesDate = false;
          }
        }
        if (_criteria.endDate != null) {
          final endOfDay = DateTime(
            _criteria.endDate!.year,
            _criteria.endDate!.month,
            _criteria.endDate!.day,
            23,
            59,
            59,
          );
          if (cEnd != null && cEnd.isAfter(endOfDay)) {
            matchesDate = false;
          }
        }
      }

      return matchesSearch && matchesActive && matchesDate;
    }).toList();
  }

  void filterCoupons({
    String? search,
    CouponsFilterCriteria? criteria,
    bool? isActive,
    bool clearFilter = false,
  }) {
    if (search != null) _searchQuery = search.trim().toLowerCase();
    if (clearFilter) {
      _criteria = CouponsFilterCriteria.empty;
    } else if (criteria != null) {
      _criteria = criteria;
    } else if (isActive != null) {
      _criteria = _criteria.copyWith(isActive: isActive);
    }
    emit(CouponGetAllSuccess(coupons: filteredCoupons));
  }

  List<GetAllProvidersModels> availableProviders = [];
  bool isLoadingProviders = false;

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

  Future<void> getCouponDetails({
    required int couponId,
  }) async {
    if (isClosed) return;

    if (couponId <= 0) {
      emit(
        const CouponFailure(
          message: 'Coupon ID is required',
        ),
      );
      return;
    }

    emit(
      const CouponLoading(),
    );

    try {
      // =========================================
      // COUPON DETAILS
      // =========================================

      final result = await getCouponDetailsFunction(
        request: GetCouponDetailsRequest(
          couponId: couponId,
        ),
      );

      if (isClosed) return;

      currentCoupon = result;

      emit(
        CouponGetDetailsSuccess(
          coupon: result,
        ),
      );

      if (isClosed) return;

      // =========================================
      // STATISTICS
      // =========================================

      await getCouponStatistics(
        request: GetCouponStatisticsRequest(
          couponId: couponId,
        ),
      );

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
        maxDiscountValue: couponData.coupon.maxDiscountValue,
        minValueToApply: couponData.coupon.minValueToApply,
        couponStartDate: couponData.coupon.couponStartDate,
        couponEndDate: couponData.coupon.couponEndDate,
        usersUseCount: couponData.coupon.usersUseCount,
        oneUserUseCount: couponData.coupon.oneUserUseCount,
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
      final couponId = await createCouponFunction(
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
          message: e.toString().replaceFirst(
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

  Future<void> loadAllProviders() async {
    if (availableProviders.isNotEmpty) return;
    isLoadingProviders = true;
    try {
      final response = await getAllProvidersFunction(
        request: GetAllProvidersRequest(pageNumber: 1),
      );
      availableProviders = List<GetAllProvidersModels>.from(response.providers);

      if (response.pageCount > 1) {
        for (int p = 2; p <= response.pageCount; p++) {
          final nextRes = await getAllProvidersFunction(
            request: GetAllProvidersRequest(pageNumber: p),
          );
          availableProviders.addAll(nextRes.providers);
        }
      }

      isLoadingProviders = false;
      if (!isClosed) {
        emit(CouponProvidersAvailableLoaded(providers: availableProviders));
      }
    } catch (_) {
      isLoadingProviders = false;
    }
  }

  Future<void> toggleCouponStatus({
    required CouponWithProviderModel couponData,
  }) async {
    if (isClosed) return;

    final currentStatus = couponData.coupon.isActive ?? false;
    final newStatus = !currentStatus;

    final updatedCoupon = CouponWithProviderModel(
      coupon: CouponModel(
        couponId: couponData.coupon.couponId,
        couponCode: couponData.coupon.couponCode,
        discountType: couponData.coupon.discountType,
        discountValue: couponData.coupon.discountValue,
        isActive: newStatus,
        maxDiscountValue: couponData.coupon.maxDiscountValue,
        minValueToApply: couponData.coupon.minValueToApply,
        couponStartDate: couponData.coupon.couponStartDate,
        couponEndDate: couponData.coupon.couponEndDate,
        usersUseCount: couponData.coupon.usersUseCount,
        oneUserUseCount: couponData.coupon.oneUserUseCount,
      ),
      providers: couponData.providers,
    );

    // Optimistic UI update
    final index = coupons.indexWhere(
      (c) => c.coupon.couponId == couponData.coupon.couponId,
    );
    if (index != -1) {
      coupons[index] = updatedCoupon;
      emit(CouponGetAllSuccess(
          coupons: List<CouponWithProviderModel>.from(coupons)));
    }

    try {
      await updateCouponFunction(request: updatedCoupon);
    } catch (e) {
      // Revert if failed
      if (index != -1) {
        coupons[index] = couponData;
        emit(CouponGetAllSuccess(
            coupons: List<CouponWithProviderModel>.from(coupons)));
      }
      if (isClosed) return;
      emit(
        CouponFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
