import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/providers/presentation/custom_widget/custom_view_all_provider_list_widget.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/page_details_provider.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/get_all_providers_cubit/get_all_providers_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/get_all_providers_cubit/get_all_providers_state.dart';
import 'package:web_admin_san/features/order_services/presentation/custom_widget/app_pagination.dart';

class ListDataViewAllProvider extends StatelessWidget {
  const ListDataViewAllProvider({super.key});

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
          return Center(
            child: Text(
              state.error,
            ),
          );
        }

        if (state is GetAllProvidersSuccess) {
          if (state.providers.isEmpty) {
            return const Center(
              child: TextEmptyViewData(),
            );
          }

          return Column(
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
                      nameButton: AppLanguageKeys.details,
                      imageProvider: provider.image,
                      lastOrderDate: provider.lastOrderDate != null
                          ? OrderFunctions.formatDateFromDateTime(
                              provider.lastOrderDate,
                            )
                          : '-',
                      orderCount: provider.totalOrders.toString(),
                      onTapViewRates: () {
                        Navigator.push(
                          context,
                          NavigateToPageWidget(
                            PageDetailsProvider(
                              providerID: provider.providerId,
                            ),
                          ),
                        );
                      },
                    );
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
          );
        }

        return const SizedBox();
      },
    );
  }
}
