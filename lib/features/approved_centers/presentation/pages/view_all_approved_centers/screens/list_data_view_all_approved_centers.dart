import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/language/language_constant.dart';

import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';

import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';

import 'package:web_admin_san/core/theming/colors.dart';

import 'package:web_admin_san/core/theming/fonts.dart';

import 'package:web_admin_san/core/theming/text_styles.dart';

import 'package:web_admin_san/features/approved_centers/presentation/bloc/get_approved_providers_cubit/get_approved_providers_cubit.dart';

import 'package:web_admin_san/features/approved_centers/presentation/bloc/get_approved_providers_cubit/get_approved_providers_state.dart';

import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';

import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';

import 'package:web_admin_san/features/order_services/presentation/custom_widget/app_pagination.dart';

import 'package:web_admin_san/features/providers/presentation/custom_widget/custom_view_all_provider_list_widget.dart';

import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/page_details_provider.dart';

class ListDataViewAllApprovedCenters extends StatelessWidget {
  const ListDataViewAllApprovedCenters({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        GetApprovedProvidersCubit,
        GetApprovedProvidersState>(
      builder: (context, state) {


        if (state is GetApprovedProvidersLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is GetApprovedProvidersError) {
          return Center(
            child: Text(
              state.message,
            ),
          );
        }


        if (state is GetApprovedProvidersSuccess) {
          final approvedProviders =
              state.data.data;

          if (approvedProviders.isEmpty) {
            return const Center(
              child: TextEmptyViewData(),
            );
          }


          return CustomContainer(
            isSelected: false,
            onTap: () {},
            typeWidget: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount:
                    approvedProviders.length,

                    separatorBuilder: (_, __) =>
                    const SizedBox(
                      height: 20,
                    ),

                    itemBuilder: (
                        context,
                        index,
                        ) {
                      final provider =
                      approvedProviders[index];

                      return CustomViewAllProviderListWidget(
                        id: provider.providerId
                            ?.toString() ??
                            '',

                        nameProvider:
                        provider.name ?? '',

                        nameButton:
                        AppLanguageKeys.details,

                        imageProvider:
                        provider.image,


                        lastOrderDate: '-',

                        orderCount: '0',

                        onTapViewRates: () {
                          final providerId =
                              provider.providerId;

                          if (providerId == null) {
                            return;
                          }

                          Navigator.push(
                            context,
                            NavigateToPageWidget(
                              PageDetailsProvider(
                                providerID:
                                providerId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // =========================================
                // PAGINATION
                // =========================================

                AppPagination(
                  currentPage:
                  state.data.currentPage,

                  totalPages:
                  state.data.pageCount,

                  onPageChanged: (page) {
                    context
                        .read<
                        GetApprovedProvidersCubit>()
                        .getApprovedProviders(
                      pageNumber: page,
                    );
                  },
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}