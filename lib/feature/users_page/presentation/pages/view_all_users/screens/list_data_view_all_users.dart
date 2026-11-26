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
import 'package:web_admin_san/feature/users_page/data/model/users_filter_criteria.dart';
import 'package:web_admin_san/feature/users_page/presentation/pages/page_details_user/page_details_user.dart';
import 'package:web_admin_san/feature/users_page/presentation/widgets/custom_view_all_users_list_widget.dart';
import 'package:web_admin_san/feature/users_page/presentation/widgets/users_filter_dialog.dart';
import 'package:web_admin_san/feature/users_page/view_model/get_all_users_cubit/get_all_users_cubit.dart';
import 'package:web_admin_san/feature/users_page/view_model/get_all_users_cubit/get_all_users_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ListDataUsersPage extends StatefulWidget {
  const ListDataUsersPage({super.key});

  @override
  State<ListDataUsersPage> createState() => _ListDataUsersPageState();
}

class _ListDataUsersPageState extends State<ListDataUsersPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  UsersFilterCriteria _criteria = UsersFilterCriteria.empty;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSearch({
    UsersFilterCriteria? newCriteria,
    int page = 1,
  }) {
    if (newCriteria != null) {
      setState(() {
        _criteria = newCriteria;
      });
    }
    context.read<GetAllUsersCubit>().getAllUsers(
          currentPage: page,
          searchTerm: _searchController.text.trim(),
          isActive: _criteria.isActive,
          startDate: _criteria.startDate,
          endDate: _criteria.endDate,
          updateFilters: true,
        );
  }

  void _openFilterDialog() {
    UsersFilterDialog.show(
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
      newCriteria: UsersFilterCriteria.empty,
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
        return LocaleKeys.joinDate.tr();
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
          icon: Icons.account_circle_outlined,
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
    return BlocBuilder<GetAllUsersCubit, GetAllUsersState>(
      builder: (context, state) {
        final totalCount =
            state is GetAllUsersSuccess ? state.totalCount : null;

        return Column(
          children: [
            EntityFilterToolbar(
              searchController: _searchController,
              searchHint: LocaleKeys.searchUsersHint.tr(),
              onSearchChanged: (val) => _applyFiltersAndSearch(page: 1),
              onSearchSubmitted: () => _applyFiltersAndSearch(page: 1),
              onSearchCleared: () => _applyFiltersAndSearch(page: 1),
              onOpenFilterDialog: _openFilterDialog,
              activeFiltersCount: _criteria.activeFiltersCount,
              activeChips: _buildActiveChips(),
              totalCount: totalCount,
              countLabel: LocaleKeys.totalUsers.tr(),
              countIcon: Icons.people_outline_rounded,
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state is GetAllUsersLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is GetAllUsersError) {
                    return ErrorStateView(
                      message: state.error,
                      onRetry: () => _applyFiltersAndSearch(page: 1),
                    );
                  }

                  if (state is GetAllUsersSuccess) {
                    final users = state.users;

                    if (users.isEmpty) {
                      return const EmptyStateView(
                        message: LocaleKeys.no_users_registered_currently,
                        icon: Icons.people_outline_rounded,
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
                                itemCount: users.length,
                                separatorBuilder: (_, __) => const SizedBox(
                                  height: 20,
                                ),
                                itemBuilder: (context, index) {
                                  final user = users[index];

                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: CustomUsersPageListWidget(
                                      id: user.userId.toString(),
                                      nameProvider: user.userName ?? '',
                                      nameButton: LocaleKeys.details,
                                      imageProvider: user.image,
                                      isActive: user.isActive,
                                      lastOrderDate:
                                          user.lastOrderProvider != null
                                              ? OrderFunctions
                                                  .formatDateFromDateTime(
                                                  user.lastOrderProvider,
                                                )
                                              : '-',
                                      joinDate: user.joinDate != null
                                          ? OrderFunctions
                                              .formatDateFromDateTime(
                                              user.joinDate,
                                            )
                                          : '-',
                                      onTapViewRates: () async {
                                        await Navigator.push(
                                          context,
                                          NavigateToPageWidget(
                                            PageDetailsUser(
                                              userId: user.userId,
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
