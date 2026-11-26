import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/accounts_management_page/data/datasource/get_package_datasource/get_package_repository.dart';
import 'package:web_admin_san/feature/packages_page/data/datasource/create_package_datasource/create_package_datasource.dart';
import 'package:web_admin_san/feature/packages_page/data/datasource/delete_package_datasource/delete_package_datasource.dart';
import 'package:web_admin_san/feature/packages_page/data/datasource/get_packages_datasource/get_packages_datasource.dart';
import 'package:web_admin_san/feature/packages_page/data/datasource/update_package_datasource/update_package_datasource.dart';
import 'package:web_admin_san/feature/packages_page/data/model/get_packages_model/get_packages_model.dart';
import 'package:web_admin_san/feature/packages_page/data/request/delete_package_request/delete_package_request.dart';
import 'package:web_admin_san/feature/packages_page/view_model/packages_cubit/packages_state.dart';
import 'package:web_admin_san/feature/accounts_management_page/data/request/get_package_request/get_package_request.dart';

import 'package:web_admin_san/feature/packages_page/data/model/packages_filter_criteria.dart';

class PackagesCubit extends Cubit<PackagesState> {
  PackagesCubit() : super(const PackagesInitial());

  List<PackageModel> packages = [];
  String _searchQuery = '';
  PackagesFilterCriteria _criteria = PackagesFilterCriteria.empty;
  PackagesFilterCriteria get currentCriteria => _criteria;

  List<PackageModel> get filteredPackages {
    return packages.where((p) {
      if (_searchQuery.isNotEmpty) {
        final name = (p.packagename ?? '').toLowerCase();
        final latinName = (p.packagelatinname ?? '').toLowerCase();
        final id = p.packageid?.toString() ?? '';
        final matchesSearch = name.contains(_searchQuery) ||
            latinName.contains(_searchQuery) ||
            id.contains(_searchQuery);
        if (!matchesSearch) return false;
      }

      if (_criteria.minPrice != null) {
        final mPrice = p.monthprice ?? 0;
        final aPrice = p.annualprice ?? 0;
        final priceToCheck =
            _criteria.billingType == 'annual' ? aPrice : mPrice;
        if (priceToCheck < _criteria.minPrice!) return false;
      }

      if (_criteria.maxPrice != null) {
        final mPrice = p.monthprice ?? 0;
        final aPrice = p.annualprice ?? 0;
        final priceToCheck =
            _criteria.billingType == 'annual' ? aPrice : mPrice;
        if (priceToCheck > _criteria.maxPrice!) return false;
      }

      return true;
    }).toList();
  }

  void filterPackages({
    String? search,
    PackagesFilterCriteria? criteria,
    bool clearFilter = false,
  }) {
    if (search != null) _searchQuery = search.trim().toLowerCase();
    if (clearFilter) {
      _criteria = PackagesFilterCriteria.empty;
    } else if (criteria != null) {
      _criteria = criteria;
    }
    emit(PackagesGetSuccess(packages: filteredPackages));
  }

  void searchPackages(String query) {
    filterPackages(search: query);
  }

  PackageModel? selectedPackage;

  Future<void> getPackages() async {
    if (isClosed) return;

    emit(const PackagesLoading());

    try {
      final result = await getPackagesFunction();

      if (isClosed) return;

      packages = result;

      emit(
        PackagesGetSuccess(
          packages: packages,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        PackagesFailure(
          message: e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }

  Future<void> updatePackage({
    required PackageModel packageModel,
  }) async {
    if (isClosed) return;

    emit(const PackagesLoading());

    try {
      final updatedPackage = await updatePackageFunction(
        packageModel: packageModel,
      );

      if (isClosed) return;

      final index = packages.indexWhere(
        (package) => package.packageid == updatedPackage.packageid,
      );

      if (index != -1) {
        packages[index] = updatedPackage;
      }

      // Update selected package if it is the same package
      if (selectedPackage?.packageid == updatedPackage.packageid) {
        selectedPackage = updatedPackage;
      }

      emit(
        PackagesUpdateSuccess(
          package: updatedPackage,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        PackagesFailure(
          message: e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }

  Future<void> deletePackage({
    required int packageId,
  }) async {
    if (isClosed) return;

    emit(const PackagesLoading());

    try {
      await deletePackageFunction(
        request: DeletePackageRequest(
          packageID: packageId,
        ),
      );

      if (isClosed) return;

      packages.removeWhere(
        (package) => package.packageid == packageId,
      );

      if (selectedPackage?.packageid == packageId) {
        selectedPackage = null;
      }

      emit(
        PackagesDeleteSuccess(
          message: LocaleKeys.deleteServicePackageSuccess.tr(),
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        PackagesFailure(
          message: e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }

  Future<void> createPackage({
    required PackageModel packageModel,
  }) async {
    if (isClosed) return;

    emit(const PackagesLoading());

    try {
      final createdPackage = await createPackageFunction(
        packageModel: packageModel,
      );

      if (isClosed) return;

      packages.add(createdPackage);

      emit(
        PackagesCreateSuccess(
          package: createdPackage,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        PackagesFailure(
          message: e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }

  Future<void> getPackageById({
    required int packageId,
  }) async {
    if (isClosed) return;

    emit(const PackagesLoading());

    try {
      final result = await getPackageFunction(
        request: GetPackageRequest(
          packageID: packageId,
        ),
      );

      if (isClosed) return;

      selectedPackage = result;

      emit(
        PackageGetByIdSuccess(
          package: result,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        PackagesFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
