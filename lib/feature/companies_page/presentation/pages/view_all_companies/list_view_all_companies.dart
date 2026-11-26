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
import 'package:web_admin_san/feature/companies_page/data/model/companies_filter_criteria.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/page_details_companies.dart';
import 'package:web_admin_san/feature/companies_page/presentation/widgets/companies_filter_dialog.dart';
import 'package:web_admin_san/feature/companies_page/presentation/widgets/widget_design_list_company.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_all_companies_cubit/get_all_companies_cubit.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_all_companies_cubit/get_all_companies_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ListCompaniesPage extends StatefulWidget {
  const ListCompaniesPage({super.key});

  @override
  State<ListCompaniesPage> createState() => _ListCompaniesPageState();
}

class _ListCompaniesPageState extends State<ListCompaniesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  CompaniesFilterCriteria _criteria = CompaniesFilterCriteria.empty;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSearch({
    CompaniesFilterCriteria? newCriteria,
    int page = 1,
  }) {
    if (newCriteria != null) {
      setState(() {
        _criteria = newCriteria;
      });
    }
    context.read<GetAllCompaniesCubit>().getAllCompanies(
          currentPage: page,
          searchTerm: _searchController.text.trim(),
          isActive: _criteria.isActive,
          startDate: _criteria.startDate,
          endDate: _criteria.endDate,
          updateFilters: true,
        );
  }

  void _openFilterDialog() {
    CompaniesFilterDialog.show(
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
      newCriteria: CompaniesFilterCriteria.empty,
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
          icon: Icons.business_outlined,
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
    return BlocBuilder<GetAllCompaniesCubit, GetAllCompaniesState>(
      builder: (context, state) {
        final totalCount =
            state is GetAllCompaniesSuccess ? state.totalCount : null;

        return Column(
          children: [
            EntityFilterToolbar(
              searchController: _searchController,
              searchHint: LocaleKeys.searchCompaniesHint.tr(),
              onSearchChanged: (val) => _applyFiltersAndSearch(page: 1),
              onSearchSubmitted: () => _applyFiltersAndSearch(page: 1),
              onSearchCleared: () => _applyFiltersAndSearch(page: 1),
              onOpenFilterDialog: _openFilterDialog,
              activeFiltersCount: _criteria.activeFiltersCount,
              activeChips: _buildActiveChips(),
              totalCount: totalCount,
              countLabel: LocaleKeys.totalCompanies.tr(),
              countIcon: Icons.business_outlined,
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state is GetAllCompaniesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is GetAllCompaniesError) {
                    return ErrorStateView(
                      message: state.error,
                      onRetry: () => _applyFiltersAndSearch(page: 1),
                    );
                  }

                  if (state is GetAllCompaniesSuccess) {
                    final companiesList = state.companies;

                    if (companiesList.isEmpty) {
                      return const EmptyStateView(
                        message: LocaleKeys.no_companies_registered_currently,
                        icon: Icons.business_outlined,
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
                                itemCount: companiesList.length,
                                separatorBuilder: (_, __) => const SizedBox(
                                  height: 16,
                                ),
                                itemBuilder: (context, index) {
                                  final company = companiesList[index];

                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: WidgetDesignListCompany(
                                      companyId: company.companyId?.toString(),
                                      name: company.name ?? '',
                                      nameButton: LocaleKeys.details,
                                      image: company.image,
                                      isActive: company.isActive,
                                      lastOrderDate:
                                          company.lastOrderProvider != null
                                              ? OrderFunctions
                                                  .formatDateFromDateTime(
                                                  company.lastOrderProvider,
                                                )
                                              : '-',
                                      joiningDate: company.joinDate != null
                                          ? OrderFunctions
                                              .formatDateFromDateTime(
                                              company.joinDate,
                                            )
                                          : '-',
                                      onTabDetails: () async {
                                        final cId = company.companyId;
                                        if (cId == null) return;
                                        await Navigator.push(
                                          context,
                                          NavigateToPageWidget(
                                            PageDetailsCompanies(
                                              companyId: cId,
                                            ),
                                          ),
                                        );
                                        if (context.mounted) {
                                          _applyFiltersAndSearch(
                                            page: state.currentPage,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
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
