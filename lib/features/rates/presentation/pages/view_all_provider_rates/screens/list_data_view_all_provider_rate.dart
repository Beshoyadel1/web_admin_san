import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/rates/presentation/bloc/providers_rate_cubit/providers_rate_cubit.dart';
import 'package:web_admin_san/features/rates/presentation/bloc/providers_rate_cubit/providers_rate_state.dart';
import 'package:web_admin_san/features/rates/presentation/custom_widget/custom_view_all_provider_rates.dart';
import 'package:web_admin_san/features/rates/presentation/pages/view_all_service_rates/view_all_service_rates.dart';

class ListDataViewAllProviderRate extends StatelessWidget {
  const ListDataViewAllProviderRate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProvidersRateCubit, ProvidersRateState>(
      builder: (context, state) {
        if (state is ProvidersRateLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ProvidersRateSuccess) {
          if (state.providers.isEmpty) {
            return const Center(
              child: TextEmptyViewData(),
            );
          }

          return CustomContainer(
            isSelected: false,
            onTap: () {},
            typeWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                state.providers.length,
                    (index) {
                  final providerRate = state.providers[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: CustomViewAllProviderRates(
                      avgRate: providerRate.averageRate.toString(),
                      countRate: providerRate.rateCount.toString(),
                      id: providerRate.provider.id.toString(),
                      nameProvider: providerRate.provider.name,
                      onTapViewRates: () {
                        Navigator.push(
                          context,
                          NavigateToPageWidget(ViewAllServiceRates(providerModel: providerRate.provider)),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );

        }

        if (state is ProvidersRateError) {
          return Center(
            child: Text(state.message),
          );
        }

        return const SizedBox();
      },
    );
  }
}
