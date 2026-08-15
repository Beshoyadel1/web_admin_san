import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/accounts_management/data/datasource/get_package_datasource/get_package_repository.dart';
import 'package:web_admin_san/features/packages/data/datasource/create_package_datasource/create_package_datasource.dart';
import 'package:web_admin_san/features/packages/data/datasource/delete_package_datasource/delete_package_datasource.dart';
import 'package:web_admin_san/features/packages/data/datasource/get_packages_datasource/get_packages_datasource.dart';
import 'package:web_admin_san/features/packages/data/datasource/update_package_datasource/update_package_datasource.dart';
import 'package:web_admin_san/features/packages/data/model/get_packages_model/get_packages_model.dart';
import 'package:web_admin_san/features/packages/data/request/delete_package_request/delete_package_request.dart';
import 'package:web_admin_san/features/packages/presentation/bloc/packages_cubit/packages_state.dart';
import '../../../../accounts_management/data/request/get_package_request/get_package_request.dart';

class PackagesCubit extends Cubit<PackagesState> {
  PackagesCubit() : super(const PackagesInitial());

  List<PackageModel> packages = [];

  PackageModel? selectedPackage;


  Future<void> getPackages() async {
    if (isClosed) return;

    emit(const PackagesLoading());

    try {
      final result = await getPackagesFunction();

      if (isClosed) return;

      if (result != null) {
        packages = result;

        emit(
          PackagesGetSuccess(
            packages: packages,
          ),
        );
      } else {
        emit(
          const PackagesFailure(
            message: 'Failed to get packages',
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;

      emit(
        PackagesFailure(
          message: e.toString(),
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
            (package) =>
        package.packageid == updatedPackage.packageid,
      );

      if (index != -1) {
        packages[index] = updatedPackage;
      }

      // Update selected package if it is the same package
      if (selectedPackage?.packageid ==
          updatedPackage.packageid) {
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
        const PackagesDeleteSuccess(
          message: 'تم الحذف بنجاح',
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
