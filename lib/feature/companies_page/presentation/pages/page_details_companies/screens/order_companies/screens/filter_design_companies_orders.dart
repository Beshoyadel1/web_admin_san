import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/app_pagination.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/internal_services/view_model/tabs_cubit/tabs_cubit.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import '../../../../../../../../core/helpers/constants/assets.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class FilterDesignCompaniesOrders extends StatelessWidget {
  final int companyId;
  const FilterDesignCompaniesOrders({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProviderInternalOrderCubit,
        GetProviderInternalOrderState>(
      builder: (context, state) {
        if (state is GetProviderInternalOrderLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.orangeColor),
          );
        }

        if (state is GetProviderInternalOrderError) {
          return CompanyOrdersErrorView(
            message: state.message,
            onRetry: () {
              final selectedTab = context.read<TabsCubit>().state;
              context.read<GetProviderInternalOrderCubit>().getCompanyOrders(
                    pageNumber: 1,
                    orderType: mapOrderType(selectedTab),
                    companyId: companyId,
                  );
            },
          );
        }

        if (state is GetProviderInternalOrderSuccess) {
          final orders = state.orders;

          if (orders.isEmpty) {
            return CompanyOrdersEmptyView(
              onRefresh: () async {
                final selectedTab = context.read<TabsCubit>().state;
                await context
                    .read<GetProviderInternalOrderCubit>()
                    .getCompanyOrders(
                      pageNumber: 1,
                      orderType: mapOrderType(selectedTab),
                      companyId: companyId,
                    );
              },
            );
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.orangeColor,
                  onRefresh: () async {
                    final selectedTab = context.read<TabsCubit>().state;
                    await context
                        .read<GetProviderInternalOrderCubit>()
                        .getCompanyOrders(
                          pageNumber: 1,
                          orderType: mapOrderType(selectedTab),
                          companyId: companyId,
                        );
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      final service = order.services?.isNotEmpty == true
                          ? order.services!.first
                          : null;

                      final serviceTitle = OrderFunctions.getServiceTitle(
                        context: context,
                        service: service,
                      );

                      return ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
                        imagePathPart1: service?.image,
                        titlePart1: serviceTitle,
                        subTitlePart1: '',
                        imagePathPart2: AppImageKeys.car501,
                        textCarPart2: order.branchName ?? '',
                        titlePart2: order.providerName ?? '',
                        imagePathPart3: order.providerImage,
                        titlePart3: LocaleKeys.name,
                        subTitlePart3: order.username ?? '',
                        status: order.orderStatus,
                        timePart5: OrderFunctions.formatDate(order.orderDate),
                        pricePart6: order.totalPrice?.toString() ?? '0',
                        order: order,
                        serviceId: service?.id,
                        id: order.id.toString(),
                      );
                    },
                  ),
                ),
              ),
              if (state.pageCount > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: AppPagination(
                    currentPage: state.currentPage,
                    totalPages: state.pageCount,
                    onPageChanged: (page) {
                      final selectedTab = context.read<TabsCubit>().state;
                      context
                          .read<GetProviderInternalOrderCubit>()
                          .getCompanyOrders(
                            pageNumber: page,
                            orderType: mapOrderType(selectedTab),
                            companyId: companyId,
                          );
                    },
                  ),
                ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

class CompanyOrdersEmptyView extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const CompanyOrdersEmptyView({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RefreshIndicator(
        color: AppColors.orangeColor,
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 54,
                  color: AppColors.greyColor.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                TextInAppWidget(
                  text: LocaleKeys.noOrdersInThisSection.tr(),
                  textSize: 15,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.darkGreyColor,
                ),
                const SizedBox(height: 14),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: TextButton.icon(
                    onPressed: () => onRefresh(),
                    icon:
                        const Icon(Icons.refresh, color: AppColors.orangeColor),
                    label: const TextInAppWidget(
                      text: LocaleKeys.retry,
                      textSize: 13,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                      textColor: AppColors.orangeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CompanyOrdersErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CompanyOrdersErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.redColor,
              ),
              const SizedBox(height: 12),
              TextInAppWidget(
                text: message,
                textSize: 14,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
                textColor: AppColors.darkGreyColor,
                isTextCenter: true,
              ),
              const SizedBox(height: 16),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeColor,
                    foregroundColor: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const TextInAppWidget(
                    text: LocaleKeys.retry,
                    textSize: 13,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
