import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/di/sl.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/error_state_view.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../bloc/delivery_setting_cubit.dart';
import '../bloc/delivery_setting_state.dart';
import '../custom_widget/delivery_kpi_cards.dart';
import '../custom_widget/delivery_orders_table.dart';
import '../custom_widget/delivery_settings_card.dart';

class DeliverySettingPage extends StatelessWidget {
  const DeliverySettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DeliverySettingCubit>()..loadData(),
      child: const _DeliverySettingPageView(),
    );
  }
}

class _DeliverySettingPageView extends StatefulWidget {
  const _DeliverySettingPageView();

  @override
  State<_DeliverySettingPageView> createState() =>
      _DeliverySettingPageViewState();
}

class _DeliverySettingPageViewState extends State<_DeliverySettingPageView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliverySettingCubit, DeliverySettingState>(
      listener: (context, state) {
        if (state.successActionMessage != null) {
          AppSnackBar.showSuccess(state.successActionMessage!);
          context.read<DeliverySettingCubit>().clearActionMessages();
        }

        if (state.errorMessage != null &&
            state.viewStatus != DeliveryViewStatus.error) {
          AppSnackBar.showError(state.errorMessage!);
          context.read<DeliverySettingCubit>().clearActionMessages();
        }
      },
      builder: (context, state) {
        final cubit = context.read<DeliverySettingCubit>();

        // Loading state on initial fetch
        if (state.viewStatus == DeliveryViewStatus.loading &&
            state.deliveryInfo == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: AppColors.orangeColor),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.loadingDeliverySettings.tr(),
                  style: const TextStyle(
                    color: AppColors.darkGreyColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        // Error state if initial fetch fails
        if (state.viewStatus == DeliveryViewStatus.error &&
            state.deliveryInfo == null) {
          return Center(
            child: ErrorStateView(
              message: state.errorMessage ??
                  LocaleKeys.failedToLoadDeliverySettings.tr(),
              onRetry: () => cubit.loadData(),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;

            return Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 24,
                  vertical: isMobile ? 16 : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Page Header with Refresh Action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(isMobile ? 8 : 10),
                                decoration: BoxDecoration(
                                  color: AppColors.CircleLightorangeColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.local_shipping,
                                  color: AppColors.orangeColor,
                                  size: isMobile ? 22 : 26,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LocaleKeys.deliverySettings.tr(),
                                      style: TextStyle(
                                        fontSize: isMobile ? 18 : 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.darkColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      LocaleKeys.deliveryStatus.tr(),
                                      style: TextStyle(
                                        fontSize: isMobile ? 11.5 : 13,
                                        color: AppColors.darkGreyColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: isMobile
                              ? IconButton(
                                  onPressed: () =>
                                      cubit.loadData(isRefresh: true),
                                  icon: const Icon(Icons.refresh, size: 20),
                                  color: AppColors.orangeColor,
                                  tooltip: LocaleKeys.refresh.tr(),
                                  style: IconButton.styleFrom(
                                    side: const BorderSide(
                                        color: AppColors.orangeColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                )
                              : OutlinedButton.icon(
                                  onPressed: () =>
                                      cubit.loadData(isRefresh: true),
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: Text(LocaleKeys.refresh.tr()),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.orangeColor,
                                    side: const BorderSide(
                                        color: AppColors.orangeColor),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(height: isMobile ? 16 : 24),

                    // 1. KPI Metric Summary Cards
                    DeliveryKpiCards(deliveryInfo: state.deliveryInfo),
                    const SizedBox(height: 24),

                    // 2. Delivery Settings & Price Form Card
                    DeliverySettingsCard(
                      initialSetting: state.deliveryInfo?.deliverySetting,
                      isUpdating: state.isUpdatingSettings,
                      onSave: ({
                        required double deliveryCost,
                        required double deliveryPrice,
                        required bool isDeliveryEnabled,
                      }) {
                        cubit.updateSettings(
                          deliveryCost: deliveryCost,
                          deliveryPrice: deliveryPrice,
                          isDeliveryEnabled: isDeliveryEnabled,
                          lang: context.locale.languageCode,
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // 3. Paginated Delivery Orders Table
                    DeliveryOrdersTable(
                      ordersResponse: state.ordersResponse,
                      selectedStatus: state.selectedStatusFilter,
                      searchQuery: state.searchQuery,
                      currentPage: state.currentPage,
                      isLoading: state.isLoadingOrders,
                      isCancelling: state.isCancellingOrder,
                      onSearchChanged: (query) => cubit.setSearchQuery(query),
                      onStatusChanged: (status) =>
                          cubit.setStatusFilter(status),
                      onPageChanged: (page) => cubit.changePage(page),
                      onCancelOrder: (orderId, reason) => cubit.cancelOrder(
                        orderId: orderId,
                        reason: reason,
                        lang: context.locale.languageCode,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
