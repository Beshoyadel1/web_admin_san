import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/providers_page/view_model/statistics_providers_cubit/get_provider_orders_sales_cubit/get_provider_orders_sales_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/statistics_providers_cubit/get_provider_service_statistics_cubit/get_provider_service_statistics_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/statistics_providers_cubit/get_provider_service_statistics_cubit/get_provider_service_statistics_state.dart';
import 'package:web_admin_san/feature/providers_page/view_model/statistics_providers_cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/statistics_providers_cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_state.dart';
import 'widgets/provider_bottom_columns_grid.dart';
import 'widgets/provider_internal_services_donut_card.dart';
import 'widgets/provider_orders_sales_spline_chart_card.dart';
import 'widgets/provider_top_row_cards_grid.dart';

class StatisticsProviders extends StatefulWidget {
  final int providerID;

  const StatisticsProviders({
    super.key,
    required this.providerID,
  });

  @override
  State<StatisticsProviders> createState() => _StatisticsProvidersState();
}

class _StatisticsProvidersState extends State<StatisticsProviders> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetProviderServiceStatisticsCubit()
            ..getProviderServiceStatistics(
              providerId: widget.providerID,
            ),
        ),
        BlocProvider(
          create: (_) => GetProviderTotalRateAndEmployeeAndBalanceCubit()
            ..getProviderTotalRateAndEmployeeAndBalance(
              providerId: widget.providerID,
            ),
        ),
        BlocProvider(
          create: (_) => GetProviderOrdersSalesCubit()
            ..getProviderOrdersSales(
              providerId: widget.providerID,
            ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: AppColors.orangeColor,
            onRefresh: () async {
              await Future.wait([
                context
                    .read<GetProviderServiceStatisticsCubit>()
                    .getProviderServiceStatistics(
                      providerId: widget.providerID,
                    ),
                context
                    .read<GetProviderTotalRateAndEmployeeAndBalanceCubit>()
                    .getProviderTotalRateAndEmployeeAndBalance(
                      providerId: widget.providerID,
                    ),
                context
                    .read<GetProviderOrdersSalesCubit>()
                    .getProviderOrdersSales(
                      providerId: widget.providerID,
                    ),
              ]);
            },
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Top Section: 5 Main Services KPI Cards Grid
                    BlocBuilder<GetProviderServiceStatisticsCubit,
                        GetProviderServiceStatisticsState>(
                      builder: (context, state) {
                        if (state is GetProviderServiceStatisticsLoading) {
                          return const _StatisticsLoadingCard(height: 180);
                        }

                        if (state is GetProviderServiceStatisticsError) {
                          return _StatisticsErrorCard(
                            height: 180,
                            message: state.message,
                            onRetry: () {
                              context
                                  .read<GetProviderServiceStatisticsCubit>()
                                  .getProviderServiceStatistics(
                                    providerId: widget.providerID,
                                  );
                            },
                          );
                        }

                        final summaryCards =
                            state is GetProviderServiceStatisticsSuccess
                                ? state.data.summaryCards
                                : [];

                        return ProviderTopRowCardsGrid(
                          summaryCards: summaryCards.cast(),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // 2. Middle Section: Side-by-Side Charts (Donut Chart & Orders Line Chart)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final isDesktop = width >= 1000;

                        final donutWidget = BlocBuilder<
                            GetProviderServiceStatisticsCubit,
                            GetProviderServiceStatisticsState>(
                          builder: (context, state) {
                            final summaryCards =
                                state is GetProviderServiceStatisticsSuccess
                                    ? state.data.summaryCards
                                    : [];

                            final chart =
                                state is GetProviderServiceStatisticsSuccess
                                    ? state.data.chart
                                    : [];

                            return ProviderInternalServicesDonutCard(
                              summaryCards: summaryCards.cast(),
                              chart: chart.cast(),
                              onDateFilter: (from, to) {
                                context
                                    .read<GetProviderServiceStatisticsCubit>()
                                    .getProviderServiceStatistics(
                                      providerId: widget.providerID,
                                      startDate: from,
                                      endDate: to,
                                    );
                              },
                            );
                          },
                        );

                        final ordersWidget = ProviderOrdersSalesSplineChartCard(
                          providerId: widget.providerID,
                        );

                        if (isDesktop) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 5, child: donutWidget),
                              const SizedBox(width: 14),
                              Expanded(flex: 6, child: ordersWidget),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              ordersWidget,
                              const SizedBox(height: 14),
                              donutWidget,
                            ],
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Bottom Row: 3 Columns (Orders Spline Chart, Rating + Top Employees, Account Balance)
                    BlocBuilder<GetProviderTotalRateAndEmployeeAndBalanceCubit,
                        GetProviderTotalRateAndEmployeeAndBalanceState>(
                      builder: (context, state) {
                        if (state
                            is GetProviderTotalRateAndEmployeeAndBalanceLoading) {
                          return const _StatisticsLoadingCard(height: 380);
                        }

                        if (state
                            is GetProviderTotalRateAndEmployeeAndBalanceError) {
                          return _StatisticsErrorCard(
                            height: 380,
                            message: state.message,
                            onRetry: () {
                              context
                                  .read<
                                      GetProviderTotalRateAndEmployeeAndBalanceCubit>()
                                  .getProviderTotalRateAndEmployeeAndBalance(
                                    providerId: widget.providerID,
                                  );
                            },
                          );
                        }

                        final averageRate = state
                                is GetProviderTotalRateAndEmployeeAndBalanceSuccess
                            ? state.data.averageRate
                            : 0.0;

                        final topEmployees = state
                                is GetProviderTotalRateAndEmployeeAndBalanceSuccess
                            ? state.data.topEmployees
                            : [];

                        final totalBalance = state
                                is GetProviderTotalRateAndEmployeeAndBalanceSuccess
                            ? state.data.totalBalance
                            : 0.0;

                        final accountsBalance = state
                                is GetProviderTotalRateAndEmployeeAndBalanceSuccess
                            ? state.data.accountsBalance
                            : [];

                        return ProviderBottomColumnsGrid(
                          averageRate: averageRate,
                          topEmployees: topEmployees.cast(),
                          totalBalance: totalBalance,
                          accountsBalance: accountsBalance.cast(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatisticsLoadingCard extends StatelessWidget {
  final double height;

  const _StatisticsLoadingCard({
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: const CircularProgressIndicator(
        color: AppColors.orangeColor,
      ),
    );
  }
}

class _StatisticsErrorCard extends StatelessWidget {
  final double height;
  final String message;
  final VoidCallback onRetry;

  const _StatisticsErrorCard({
    required this.height,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: AppColors.darkGreyColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: TextButton(
              onPressed: onRetry,
              child: Text(
                LocaleKeys.retry.tr(),
                style: const TextStyle(
                  color: AppColors.orangeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
