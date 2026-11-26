import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/widgets/app_active_filter_chip.dart';
import 'package:web_admin_san/core/widgets/app_pagination.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/widgets/empty_state_view.dart';
import 'package:web_admin_san/core/widgets/entity_filter_toolbar.dart';
import 'package:web_admin_san/core/widgets/error_state_view.dart';
import 'package:web_admin_san/core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/providers_page/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';
import 'package:web_admin_san/feature/providers_page/data/model/providers_filter_criteria.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/page_details_provider.dart';
import 'package:web_admin_san/feature/providers_page/presentation/widgets/custom_view_all_provider_list_widget.dart';
import 'package:web_admin_san/feature/providers_page/presentation/widgets/providers_filter_dialog.dart';
import 'package:web_admin_san/feature/providers_page/view_model/get_all_providers_cubit/get_all_providers_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/get_all_providers_cubit/get_all_providers_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ListDataProvidersPage extends StatefulWidget {
  const ListDataProvidersPage({super.key});

  @override
  State<ListDataProvidersPage> createState() => _ListDataProvidersPageState();
}

class _ListDataProvidersPageState extends State<ListDataProvidersPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ProvidersFilterCriteria _criteria = ProvidersFilterCriteria.empty;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSearch({
    ProvidersFilterCriteria? newCriteria,
    int page = 1,
  }) {
    if (newCriteria != null) {
      setState(() {
        _criteria = newCriteria;
      });
    }
    context.read<GetAllProvidersCubit>().getAllProviders(
          currentPage: page,
          searchTerm: _searchController.text.trim(),
          isActive: _criteria.isActive,
          startDate: _criteria.startDate,
          endDate: _criteria.endDate,
          updateFilters: true,
        );
  }

  void _openFilterDialog() {
    ProvidersFilterDialog.show(
      context,
      initialCriteria: _criteria,
      onApply: (newCriteria) {
        _applyFiltersAndSearch(newCriteria: newCriteria, page: 1);
      },
    );
  }

  void _clearStatusFilter() {
    _applyFiltersAndSearch(
      newCriteria: _criteria.copyWith(clearIsActive: true),
      page: 1,
    );
  }

  void _clearDateFilter() {
    _applyFiltersAndSearch(
      newCriteria: _criteria.copyWith(
        clearStartDate: true,
        clearEndDate: true,
        clearDatePreset: true,
      ),
      page: 1,
    );
  }

  void _clearAllFilters() {
    _applyFiltersAndSearch(
      newCriteria: ProvidersFilterCriteria.empty,
      page: 1,
    );
  }

  String _formatDateRange() {
    final dateFormat = DateFormat('yyyy/MM/dd');
    switch (_criteria.datePreset) {
      case 'today':
        return LocaleKeys.dateToday.tr();
      case 'last7days':
        return LocaleKeys.dateLast7Days.tr();
      case 'thisMonth':
        return LocaleKeys.dateThisMonth.tr();
      default:
        if (_criteria.startDate != null && _criteria.endDate != null) {
          return '${LocaleKeys.datePrefix.tr()} ${dateFormat.format(_criteria.startDate!)} - ${dateFormat.format(_criteria.endDate!)}';
        } else if (_criteria.startDate != null) {
          return '${LocaleKeys.fromDatePrefix.tr()} ${dateFormat.format(_criteria.startDate!)}';
        } else if (_criteria.endDate != null) {
          return '${LocaleKeys.toDatePrefix.tr()} ${dateFormat.format(_criteria.endDate!)}';
        }
        return LocaleKeys.registrationDate.tr();
    }
  }

  List<Widget> _buildActiveChips() {
    final chips = <Widget>[];

    if (_criteria.isActive != null) {
      chips.add(
        AppActiveFilterChip(
          label: _criteria.isActive!
              ? LocaleKeys.statusActive.tr()
              : LocaleKeys.statusInactive.tr(),
          icon: Icons.storefront_outlined,
          onDeleted: _clearStatusFilter,
        ),
      );
    }

    if (_criteria.startDate != null ||
        _criteria.endDate != null ||
        (_criteria.datePreset != null && _criteria.datePreset != 'all')) {
      chips.add(
        AppActiveFilterChip(
          label: _formatDateRange(),
          icon: Icons.calendar_today_rounded,
          onDeleted: _clearDateFilter,
        ),
      );
    }

    if (_criteria.isNotEmpty) {
      chips.add(
        AppClearAllFiltersChip(onClearAll: _clearAllFilters),
      );
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllProvidersCubit, GetAllProvidersState>(
      builder: (context, state) {
        final totalCount =
            state is GetAllProvidersSuccess ? state.totalCount : null;

        return Column(
          children: [
            EntityFilterToolbar(
              searchController: _searchController,
              searchHint: LocaleKeys.searchProvidersHint.tr(),
              onSearchChanged: (val) => _applyFiltersAndSearch(page: 1),
              onSearchSubmitted: () => _applyFiltersAndSearch(page: 1),
              onSearchCleared: () => _applyFiltersAndSearch(page: 1),
              onOpenFilterDialog: _openFilterDialog,
              activeFiltersCount: _criteria.activeFiltersCount,
              activeChips: _buildActiveChips(),
              totalCount: totalCount,
              countLabel: LocaleKeys.totalProviders.tr(),
              countIcon: Icons.storefront_outlined,
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state is GetAllProvidersLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is GetAllProvidersError) {
                    return ErrorStateView(
                      message: state.error,
                      onRetry: () => _applyFiltersAndSearch(page: 1),
                    );
                  }

                  if (state is GetAllProvidersSuccess) {
                    final providers = state.providers;

                    if (providers.isEmpty) {
                      return const EmptyStateView(
                        message: LocaleKeys.noProvidersRegisteredCurrently,
                        icon: Icons.storefront_outlined,
                      );
                    }

                    return CustomContainer(
                      isSelected: false,
                      onTap: () {},
                      typeWidget: Column(
                        children: [
                          Expanded(
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: _scrollController,
                              child: ListView.separated(
                                controller: _scrollController,
                                itemCount: providers.length,
                                separatorBuilder: (_, __) => const SizedBox(
                                  height: 16,
                                ),
                                itemBuilder: (context, index) {
                                  final provider = providers[index];

                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: CustomViewAllProviderListWidget(
                                      id: provider.providerId.toString(),
                                      nameProvider: provider.name ?? '',
                                      nameButton: LocaleKeys.details,
                                      imageProvider: provider.image,
                                      isActive: provider.isActive,
                                      lastOrderDate:
                                          provider.lastOrderDate != null
                                              ? OrderFunctions
                                                  .formatDateFromDateTime(
                                                  provider.lastOrderDate,
                                                )
                                              : '-',
                                      orderCount:
                                          provider.totalOrders.toString(),
                                      onTapViewRates: () async {
                                        final updatedProvider =
                                            await Navigator.push(
                                          context,
                                          NavigateToPageWidget(
                                            PageDetailsProvider(
                                              providerID: provider.providerId,
                                            ),
                                          ),
                                        );

                                        if (context.mounted) {
                                          if (updatedProvider
                                              is GetAllProvidersModels) {
                                            context
                                                .read<GetAllProvidersCubit>()
                                                .updateProviderInList(
                                                  updatedProvider,
                                                );
                                          } else if (updatedProvider == true) {
                                            _applyFiltersAndSearch(
                                              page: state.currentPage,
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          AppPagination(
                            currentPage: state.currentPage,
                            totalPages: state.pageCount,
                            onPageChanged: (page) {
                              _applyFiltersAndSearch(page: page);
                            },
                          ),
                        ],
                      ),
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
