import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/rates/presentation/bloc/update_rate_cubit/update_rate_cubit.dart';
import 'package:web_admin_san/features/rates/presentation/pages/view_all_service_rates/screens/edit_rate_dialog.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import '../../../../../../features/rates/data/model/get_providers_basic_rate_models/get_providers_basic_rate_models.dart';
import '../../../../../../features/rates/presentation/bloc/get_provider_details_rates_cubit/get_provider_details_rates_cubit.dart';
import '../../../../../../features/rates/presentation/bloc/get_provider_details_rates_cubit/get_provider_details_rates_state.dart';
import '../../../../../../features/rates/presentation/bloc/service_settings_cubit/service_settings_cubit.dart';
import '../../../../../../features/rates/presentation/bloc/service_settings_cubit/service_settings_state.dart';
import '../../../../../../features/rates/presentation/custom_widget/Container_list_container_all_rate_service_widget.dart';
import '../../../../../../features/rates/presentation/custom_widget/custom_tab_select_rate_service.dart';
import '../../../../../../features/rates/presentation/pages/view_all_service_rates/screens/title_total_rate_in_list_data_first_screen_rate.dart';

class TabDataDesignRateService extends StatelessWidget {
  final ProviderModel providerModel;

  const TabDataDesignRateService({
    super.key,
    required this.providerModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceSettingsCubit, ServiceSettingsState>(
      builder: (context, state) {
        final cubit = ServiceSettingsCubit.get(context);

        if (state is ServiceSettingsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is! ServiceSettingsSuccess) {
          return const SizedBox();
        }

        if (cubit.selectedService == null && !cubit.isAllServicesSelected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            cubit.selectAllServices();
          });
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTabController(
              length: state.services.length + 1,
              initialIndex: cubit.isAllServicesSelected
                  ? 0
                  : state.services.indexWhere(
                    (service) => service.id == cubit.selectedService?.id,
              ) +
                  1,
              child: SizedBox(
                height: 60,
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  overlayColor: WidgetStateColor.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: const EdgeInsets.only(right: 10),

                  onTap: (index) {
                    if (index == 0) {
                      cubit.selectAllServices();
                      return;
                    }

                    final service = state.services[index - 1];

                    cubit.selectService(service);
                  },

                  tabs: [
                    CustomTabSelectRateService(
                      title: AppLanguageKeys.allReviews,
                      isSelect: cubit.isAllServicesSelected,
                    ),

                    ...state.services.map(
                          (service) => CustomTabSelectRateService(
                        imagePath: service.image,
                        title: service.getName(context) ?? '',
                        isSelect: !cubit.isAllServicesSelected &&
                            cubit.selectedService?.id == service.id,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            BlocProvider(
              key: ValueKey(
                "${providerModel.id}_${cubit.selectedService?.id ?? 0}",
              ),
              create: (_) => GetProviderDetailsRatesCubit()
                ..getProviderDetailsRates(
                  providerId: providerModel.id,
                  serviceId: cubit.selectedService?.id ?? 0,
                ),
              child: BlocBuilder<GetProviderDetailsRatesCubit,
                  GetProviderDetailsRatesState>(
                builder: (context, rateState) {
                  if (rateState is GetProviderDetailsRatesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (rateState is GetProviderDetailsRatesSuccess) {
                    if (state.services.isEmpty) {
                      return const TextEmptyViewData();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTotalRateInListDataFirstScreenRate(
                          averageRate: rateState.model.averageRate.toString(),
                        ),
                        const SizedBox(height: 10),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final allRates = rateState.model.rates
                                .expand(
                                  (service) => service.rates,
                            )
                                .toList();

                            final isMobile = constraints.maxWidth < 700;

                            final itemWidth = isMobile
                                ? constraints.maxWidth
                                : (constraints.maxWidth - 10) / 2;
                            if (allRates.isEmpty) {
                              return const TextEmptyViewData();
                            }
                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: allRates.map(
                                    (rate) {
                                  // ==========================================
                                  // FIND SERVICE NAME USING serviceId
                                  // ==========================================

                                  final service = state.services.cast<dynamic>().firstWhere(
                                        (service) => service.id == rate.serviceId,
                                    orElse: () => null,
                                  );

                                  final serviceName = service?.getName(context) ?? '';

                                  return SizedBox(
                                    width: itemWidth,
                                    child: ContainerListContainerAllRateServiceWidget(
                                      imagePath: rate.userImage,
                                      username: rate.username,
                                      message: rate.message ?? '',
                                      rate: rate.rate,

                                      // SERVICE NAME
                                      serviceName: serviceName,

                                      onEdit: () async {
                                        final updated = await showDialog<bool>(
                                          context: context,
                                          builder: (_) {
                                            return BlocProvider(
                                              create: (_) => UpdateRateCubit(),
                                              child: EditRateDialog(
                                                rateId: rate.id,
                                                orderId: rate.orderId,
                                                providerId: rate.providerId,
                                                userId: rate.userId,
                                                userType: rate.userType,
                                                serviceId: rate.serviceId,
                                                currentRate: rate.rate,
                                                currentMessage: rate.message ?? '',
                                              ),
                                            );
                                          },
                                        );

                                        if (updated == true && context.mounted) {
                                          await context
                                              .read<GetProviderDetailsRatesCubit>()
                                              .getProviderDetailsRates(
                                            providerId: providerModel.id,
                                            serviceId: cubit.isAllServicesSelected
                                                ? 0
                                                : cubit.selectedService?.id ?? 0,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          },
                        ),
                      ],
                    );
                  }

                  if (rateState is GetProviderDetailsRatesError) {
                    return Text(
                      rateState.message,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
