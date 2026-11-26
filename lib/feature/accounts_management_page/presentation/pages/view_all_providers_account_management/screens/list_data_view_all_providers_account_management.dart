import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/pages/details_user_accounts_management/details_user_accounts_management.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/feature/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/core/widgets/empty_state_view.dart';
import 'package:web_admin_san/core/widgets/error_state_view.dart';
import 'package:web_admin_san/core/widgets/app_pagination.dart';
import 'package:web_admin_san/feature/providers_page/view_model/get_all_providers_cubit/get_all_providers_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/get_all_providers_cubit/get_all_providers_state.dart';
import 'package:web_admin_san/feature/providers_page/presentation/widgets/custom_view_all_provider_list_widget.dart';

class ListDataAccountsManagementPage extends StatelessWidget {
  const ListDataAccountsManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllProvidersCubit, GetAllProvidersState>(
      builder: (context, state) {
        if (state is GetAllProvidersLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetAllProvidersError) {
          return ErrorStateView(
            message: state.error,
            onRetry: () {
              context
                  .read<GetAllProvidersCubit>()
                  .getAllProviders(currentPage: 1);
            },
          );
        }

        if (state is GetAllProvidersSuccess) {
          if (state.providers.isEmpty) {
            return const EmptyStateView(
              message: LocaleKeys.no_provider_accounts_currently,
              icon: Icons.account_balance_wallet_outlined,
            );
          }

          return CustomContainer(
            isSelected: false,
            onTap: () {},
            typeWidget: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: state.providers.length,
                    separatorBuilder: (_, __) => const SizedBox(
                      height: 20,
                    ),
                    itemBuilder: (context, index) {
                      final provider = state.providers[index];

                      return CustomViewAllProviderListWidget(
                          id: provider.providerId.toString(),
                          nameProvider: provider.name ?? '',
                          nameButton: LocaleKeys.details,
                          isActive: provider.isActive,
                          imageProvider: provider.image,
                          lastOrderDate: provider.lastOrderDate != null
                              ? OrderFunctions.formatDateFromDateTime(
                                  provider.lastOrderDate,
                                )
                              : '-',
                          orderCount: provider.totalOrders.toString(),
                          onTapViewRates: () async {
                            final cubit = context.read<GetUserInfoCubit>();

                            await cubit.getUserInfo(
                              request: GetUserInfoRequest(
                                userId: provider.providerId,
                                userType: 4,
                              ),
                            );

                            if (context.mounted && cubit.user != null) {
                              Navigator.push(
                                context,
                                NavigateToPageWidget(
                                  DetailsUserAccountsManagement(
                                    providerDetailsRequest:
                                        cubit.user?.providerDetails ??
                                            const ProviderDetailsRequest(),
                                  ),
                                ),
                              );
                            }
                          });
                    },
                  ),
                ),
                AppPagination(
                  currentPage: state.currentPage,
                  totalPages: state.pageCount,
                  onPageChanged: (page) {
                    context.read<GetAllProvidersCubit>().getAllProviders(
                          currentPage: page,
                        );
                  },
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
