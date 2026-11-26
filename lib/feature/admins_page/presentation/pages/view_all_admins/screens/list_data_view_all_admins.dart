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
import 'package:web_admin_san/feature/admins_page/data/model/admins_filter_criteria.dart';
import 'package:web_admin_san/feature/admins_page/presentation/pages/page_details_admins/page_details_admins.dart';
import 'package:web_admin_san/feature/admins_page/presentation/widgets/admins_filter_dialog.dart';
import 'package:web_admin_san/feature/admins_page/presentation/widgets/custom_view_all_admins_list_widget.dart';
import 'package:web_admin_san/feature/admins_page/view_model/admins_cubit/admins_cubit.dart';
import 'package:web_admin_san/feature/admins_page/view_model/admins_cubit/admins_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ListDataAdminsPage extends StatefulWidget {
  const ListDataAdminsPage({super.key});

  @override
  State<ListDataAdminsPage> createState() => _ListDataAdminsPageState();
}

class _ListDataAdminsPageState extends State<ListDataAdminsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  AdminsFilterCriteria _criteria = AdminsFilterCriteria.empty;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSearch({
    AdminsFilterCriteria? newCriteria,
    int page = 1,
  }) {
    if (newCriteria != null) {
      setState(() {
        _criteria = newCriteria;
      });
    }
    context.read<AdminsCubit>().getAllAdmins(
          currentPage: page,
          searchTerm: _searchController.text.trim(),
          isActive: _criteria.isActive,
          startDate: _criteria.startDate,
          endDate: _criteria.endDate,
          updateFilters: true,
        );
  }

  void _openFilterDialog() {
    AdminsFilterDialog.show(
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
      newCriteria: AdminsFilterCriteria.empty,
      page: 1,
    );
  }

  String _formatDateRange() {
    final dateFormat = DateFormat('yyyy/MM/dd');
    switch (_criteria.datePreset) {
      case 'today':
        return 'التاريخ: اليوم';
      case 'last7days':
        return 'التاريخ: آخر 7 أيام';
      case 'thisMonth':
        return 'التاريخ: هذا الشهر';
      default:
        if (_criteria.startDate != null && _criteria.endDate != null) {
          return 'التاريخ: ${dateFormat.format(_criteria.startDate!)} - ${dateFormat.format(_criteria.endDate!)}';
        } else if (_criteria.startDate != null) {
          return 'من تاريخ: ${dateFormat.format(_criteria.startDate!)}';
        } else if (_criteria.endDate != null) {
          return 'إلى تاريخ: ${dateFormat.format(_criteria.endDate!)}';
        }
        return 'تاريخ التسجيل';
    }
  }

  List<Widget> _buildActiveChips() {
    final chips = <Widget>[];

    if (_criteria.isActive != null) {
      chips.add(
        AppActiveFilterChip(
          label: _criteria.isActive! ? 'الحالة: نشط' : 'الحالة: غير نشط',
          icon: Icons.shield_outlined,
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
        AppClearAllFiltersChip(
          onPressed: _clearAllFilters,
        ),
      );
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminsCubit, AdminsState>(
      builder: (context, state) {
        final totalCount = state is AdminsSuccess ? state.totalCount : null;

        return Column(
          children: [
            EntityFilterToolbar(
              searchController: _searchController,
              searchHint: 'البحث باسم المشرف، الهاتف، البريد...',
              onOpenFilterDialog: _openFilterDialog,
              activeFiltersCount: _criteria.activeFiltersCount,
              activeChips: _buildActiveChips(),
              onSearchChanged: (val) => _applyFiltersAndSearch(page: 1),
              onSearchSubmitted: () => _applyFiltersAndSearch(page: 1),
              onSearchCleared: () => _applyFiltersAndSearch(page: 1),
              totalCount: totalCount,
              countLabel: 'إجمالي المشرفين',
              countIcon: Icons.admin_panel_settings_outlined,
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state is AdminsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is AdminsError) {
                    return ErrorStateView(
                      message: state.error,
                      onRetry: () => _applyFiltersAndSearch(page: 1),
                    );
                  }

                  if (state is AdminsSuccess) {
                    final admins = state.admins;

                    if (admins.isEmpty) {
                      return const EmptyStateView(
                        message: LocaleKeys.no_admins_registered_currently,
                        icon: Icons.admin_panel_settings_outlined,
                      );
                    }

                    return CustomContainer(
                      isSelected: false,
                      onTap: () {},
                      typeWidget: Column(
                        children: [
                          Expanded(
                            child: Scrollbar(
                              controller: _scrollController,
                              thumbVisibility: true,
                              child: ListView.separated(
                                controller: _scrollController,
                                itemCount: admins.length,
                                separatorBuilder: (_, __) => const SizedBox(
                                  height: 20,
                                ),
                                itemBuilder: (context, index) {
                                  final admin = admins[index];

                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: CustomAdminsPageListWidget(
                                      id: admin.adminId?.toString(),
                                      nameAdmin: admin.userName ?? '',
                                      email: admin.email ?? '',
                                      phone: admin.phone ?? '',
                                      image: admin.image,
                                      isActive: admin.isActive ?? false,
                                      joinDate:
                                          OrderFunctions.formatDateFromDateTime(
                                              admin.joinDate),
                                      onTapDetails: () async {
                                        if (admin.adminId == null) return;

                                        final result = await Navigator.push(
                                          context,
                                          NavigateToPageWidget(
                                            PageDetailsAdmin(
                                              adminId: admin.adminId!,
                                            ),
                                          ),
                                        );

                                        if (result == true && context.mounted) {
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
