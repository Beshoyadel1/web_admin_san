import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/bloc/get_harage_providers_cubit/get_harage_providers_cubit.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/bloc/get_harage_providers_cubit/get_harage_providers_state.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/widget_design_list_harag.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/ui/page_details_provider_harag/page_details_provider_harag.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/order_services/presentation/custom_widget/app_pagination.dart';

class ListViewCarHarag extends StatelessWidget {
  const ListViewCarHarag({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetHarageProvidersCubit, GetHarageProvidersState>(
      builder: (context, state) {
        if (state is GetHarageProvidersLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetHarageProvidersError) {
          return Center(
            child: Text(
              state.error,
            ),
          );
        }

        if (state is GetHarageProvidersSuccess) {
          if (state.providers.isEmpty) {
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
                    itemCount: state.providers.length,
                    separatorBuilder: (_, __) => const SizedBox(
                      height: 20,
                    ),
                    itemBuilder: (context, index) {
                      final providers = state.providers[index];

                      return WidgetDesignListHarag(
                        providerId: providers.providerId.toString(),
                        name: providers.name ?? '',
                        nameButton: AppLanguageKeys.details,
                        image: providers.image,
                        totalCars: providers.totalCars.toString(),
                        lastOrderDate: providers.lastAddedDate != null
                            ? OrderFunctions.formatDateFromDateTime(
                          providers.lastAddedDate,
                        )
                            : '-',
                        joiningDate: providers.joinDate != null
                            ? OrderFunctions.formatDateFromDateTime(
                          providers.joinDate,
                        )
                            : '-',
                        onTabDetails: () {
                          Navigator.push(
                            context,
                            NavigateToPageWidget(
                              PageDetailsProvider(
                                providerID: providers.providerId??5,
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
                    context.read<GetHarageProvidersCubit>().getAllHarahProviders(
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
