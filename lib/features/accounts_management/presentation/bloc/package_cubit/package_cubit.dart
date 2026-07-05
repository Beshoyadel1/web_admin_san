import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/features/providers/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';
import '../../../../../../../features/accounts_management/data/datasource/get_package_datasource/get_package_repository.dart';
import '../../../../../../../features/accounts_management/data/request/get_package_request/get_package_request.dart';
import '../../../../../../../features/accounts_management/presentation/bloc/package_cubit/package_state.dart';

class PackageCubit extends Cubit<PackageState> {
  PackageCubit() : super(PackageInitial());

  Future<void> getPackages({required GetAllProvidersModels providerDetailsRequest}) async {
    emit(PackageLoading());

    try {
      final data = await getPackageFunction(
        request: GetPackageRequest(
          packageID: providerDetailsRequest.providerId??5,
        ),
      );

      emit(
        PackageSuccess(
          packages: data,
          startDate: providerDetailsRequest.joinDate,
          endDate: providerDetailsRequest.lastOrderDate,
        ),
      );
    } catch (e) {
      emit(PackageError(e.toString()));
    }
  }
}
