import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/features/auth_page/data/datasource/get_user_info_datasource/get_user_info_datasource.dart';

import 'package:web_admin_san/features/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';

import 'package:web_admin_san/features/providers/data/datasource/get_all_providers_datasource/get_all_providers_datasource.dart';

import 'package:web_admin_san/features/providers/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';

import 'package:web_admin_san/features/providers/data/request/get_all_providers_request/get_all_providers_request.dart';

import 'get_all_providers_state.dart';

class GetAllProvidersCubit extends Cubit<GetAllProvidersState> {
  GetAllProvidersCubit() : super(GetAllProvidersInitial());

  Future<void> getAllProviders({
    required int currentPage,
  }) async {
    if (isClosed) return;

    emit(GetAllProvidersLoading());

    try {
      final result = await getAllProvidersFunction(
        request: GetAllProvidersRequest(
          pageNumber: currentPage,
        ),
      );

      if (isClosed) return;

      final providerApproval = await _getProviderApprovals(
        result.providers,
      );

      if (isClosed) return;

      emit(
        GetAllProvidersSuccess(
          providers: result.providers,
          providerApproval: providerApproval,
          currentPage: result.currentPage,
          pageCount: result.pageCount,
          totalCount: result.totalCount,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        GetAllProvidersError(
          e.toString(),
        ),
      );
    }
  }

  Future<Map<int, bool>> _getProviderApprovals(
      List<GetAllProvidersModels> providers,
      ) async {
    final Map<int, bool> approvals = {};

    final activeProviders = providers.where(
          (provider) => provider.isActive == true,
    );

    await Future.wait(
      activeProviders.map(
            (provider) async {
          final providerId = provider.providerId;

          if (providerId == null) return;

          try {
            final user = await getUserInfoFunction(
              request: GetUserInfoRequest(
                userId: providerId,
                userType: 4,
              ),
            );

            approvals[providerId] =
                user.providerDetails?.isApproved == true;
          } catch (e) {
            print(
              '❌ Approval Error => Provider: $providerId | $e',
            );

            approvals[providerId] = false;
          }
        },
      ),
    );

    return approvals;
  }
}