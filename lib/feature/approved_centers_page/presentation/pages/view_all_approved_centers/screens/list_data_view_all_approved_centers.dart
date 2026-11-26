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
import 'package:web_admin_san/feature/approved_centers_page/data/model/approved_centers_filter_criteria.dart';
import 'package:web_admin_san/feature/approved_centers_page/presentation/widgets/approved_centers_filter_dialog.dart';
import 'package:web_admin_san/feature/approved_centers_page/view_model/get_approved_providers_cubit/get_approved_providers_cubit.dart';
import 'package:web_admin_san/feature/approved_centers_page/view_model/get_approved_providers_cubit/get_approved_providers_state.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/page_details_provider.dart';
import 'package:web_admin_san/feature/providers_page/presentation/widgets/custom_view_all_provider_list_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ListDataApprovedCentersPage extends StatefulWidget {
  const ListDataApprovedCentersPage({super.key});

  @override
  State<ListDataApprovedCentersPage> createState() =>
      _ListDataApprovedCentersPageState();
}

class _ListDataApprovedCentersPageState
    extends State<ListDataApprovedCentersPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ApprovedCentersFilterCriteria _criteria =
      ApprovedCentersFilterCriteria.empty;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSearch({
    ApprovedCentersFilterCriteria? newCriteria,
    int page = 1,
  }) {
    if (newCriteria != null) {
      setState(() {
        _criteria = newCriteria;
      });
    }
    context.read<GetApprovedProvidersCubit>().getApprovedProviders(
          pageNumber: page,
          searchTerm: _searchController.text.trim(),
          isActive: _criteria.isActive,
          updateFilters: true,
        );
  }

  void _openFilterDialog() {
    ApprovedCentersFilterDialog.show(
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

  void _clearAllFilters() {
    _applyFiltersAndSearch(
      newCriteria: ApprovedCentersFilterCriteria.empty,
      page: 1,
    );
  }

  List<Widget> _buildActiveChips() {
    final chips = <Widget>[];

    if (_criteria.isActive != null) {
      chips.add(
        AppActiveFilterChip(
          label: _criteria.isActive! ? 'الحالة: نشط ومعتمد' : 'الحالة: غير نشط',
          icon: Icons.verified_outlined,
          onDeleted: _clearStatusFilter,
        ),
      );
    }

    if (_criteria.isNotEmpty) {
      chips.add(
        AppClearAllFiltersChip(
          onPressed: _clearAllFilters,
        ),
      );
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetApprovedProvidersCubit, GetApprovedProvidersState>(
      builder: (context, state) {
        final totalCount =
            state is GetApprovedProvidersSuccess ? state.data.totalCount : null;
        return Column(
          children: [
            // ============================================================
            // SEARCH & FILTER BAR
            // ============================================================
            EntityFilterToolbar(
              searchController: _searchController,
              searchHint: 'البحث باسم المركز المعتمد، المعرف...',
              onOpenFilterDialog: _openFilterDialog,
              activeFiltersCount: _criteria.activeFiltersCount,
              activeChips: _buildActiveChips(),
              onSearchChanged: (val) => _applyFiltersAndSearch(page: 1),
              onSearchSubmitted: () => _applyFiltersAndSearch(page: 1),
              onSearchCleared: () => _applyFiltersAndSearch(page: 1),
              totalCount: totalCount,
              countLabel: LocaleKeys.totalApprovedCenters.tr(),
              countIcon: Icons.verified_outlined,
            ),

            // ============================================================
            // APPROVED CENTERS LIST & PAGINATION
            // ============================================================
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state is GetApprovedProvidersLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is GetApprovedProvidersError) {
                    return ErrorStateView(
                      message: state.message,
                      onRetry: () => _applyFiltersAndSearch(page: 1),
                    );
                  }

                  if (state is GetApprovedProvidersSuccess) {
                    final approvedProviders = state.data.data;
                    if (approvedProviders.isEmpty) {
                      return const EmptyStateView(
                        message: LocaleKeys.noApprovedCentersCurrently,
                        icon: Icons.verified_outlined,
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
                                itemCount: approvedProviders.length,
                                separatorBuilder: (_, __) => const SizedBox(
                                  height: 16,
                                ),
                                itemBuilder: (context, index) {
                                  final provider = approvedProviders[index];

                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: CustomViewAllProviderListWidget(
                                      id: provider.providerId?.toString() ?? '',
                                      nameProvider: provider.name ?? '',
                                      isActive: provider.approval?.isactive,
                                      nameButton: LocaleKeys.details,
                                      imageProvider: provider.image,
                                      lastOrderDate: '-',
                                      orderCount: '-',
                                      onTapViewRates: () async {
                                        final providerId = provider.providerId;
                                        if (providerId == null) return;

                                        final result = await Navigator.push(
                                          context,
                                          NavigateToPageWidget(
                                            PageDetailsProvider(
                                              providerID: providerId,
                                            ),
                                          ),
                                        );

                                        if (context.mounted &&
                                            (result == true ||
                                                result != null)) {
                                          await context
                                              .read<GetApprovedProvidersCubit>()
                                              .getApprovedProviders(
                                                pageNumber:
                                                    state.data.currentPage,
                                              );
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
                            currentPage: state.data.currentPage,
                            totalPages: state.data.pageCount,
                            onPageChanged: (page) {
                              _applyFiltersAndSearch(page: page);
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
