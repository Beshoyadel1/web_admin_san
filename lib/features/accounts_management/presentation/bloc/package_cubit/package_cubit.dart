import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import '../../../../../../../features/accounts_management/data/datasource/get_package_datasource/get_package_repository.dart';
import '../../../../../../../features/accounts_management/data/request/get_package_request/get_package_request.dart';
import '../../../../../../../features/accounts_management/presentation/bloc/package_cubit/package_state.dart';


class PackageCubit extends Cubit<PackageState> {
  PackageCubit() : super(const PackageInitial());

  Future<void> getPackage({
    required ProviderDetailsRequest providerDetailsRequest,
  }) async {
    if (isClosed) return;

    emit(const PackageLoading());

    try {
      final packageId = providerDetailsRequest.packageid;

      if (packageId == null) {
        emit(
          const PackageError(
            'Package ID is not available',
          ),
        );
        return;
      }

      final package = await getPackageFunction(
        request: GetPackageRequest(
          packageID: packageId,
        ),
      );

      if (isClosed) return;

      emit(
        PackageSuccess(
          package: package,
          startDate: providerDetailsRequest.subscriptionstartdate,
          endDate: providerDetailsRequest.subscriptionenddate,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      final message = e.toString().replaceFirst(
        'Exception: ',
        '',
      );

      emit(
        PackageError(message),
      );
    }
  }
}