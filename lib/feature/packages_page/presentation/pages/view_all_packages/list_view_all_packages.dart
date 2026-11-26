import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/widgets/app_active_filter_chip.dart';
import 'package:web_admin_san/core/widgets/entity_filter_toolbar.dart';
import 'package:web_admin_san/core/widgets/error_state_view.dart';
import 'package:web_admin_san/core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/core/widgets/show_delete_confirmation_dialog_in_app.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';
import 'package:web_admin_san/feature/packages_page/data/model/packages_filter_criteria.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/page_details_packages/page_details_packages.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/edit_package_dialog.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/package_card_skeleton.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/packages_filter_dialog.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/widget_design_list_package.dart';
import 'package:web_admin_san/feature/packages_page/view_model/packages_cubit/packages_cubit.dart';
import 'package:web_admin_san/feature/packages_page/view_model/packages_cubit/packages_state.dart';

class ListPackagesPage extends StatefulWidget {
  const ListPackagesPage({super.key});

  @override
  State<ListPackagesPage> createState() => _ListPackagesPageState();
}

class _ListPackagesPageState extends State<ListPackagesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  PackagesFilterCriteria _criteria = PackagesFilterCriteria.empty;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openFilterDialog() {
    PackagesFilterDialog.show(
      context,
      initialCriteria: _criteria,
      onApply: (newCriteria) {
        setState(() {
          _criteria = newCriteria;
        });
        context.read<PackagesCubit>().filterPackages(criteria: newCriteria);
      },
    );
  }

  void _clearBillingTypeFilter() {
    final newCriteria = _criteria.copyWith(clearBillingType: true);
    setState(() => _criteria = newCriteria);
    context.read<PackagesCubit>().filterPackages(criteria: newCriteria);
  }

  void _clearPriceFilter() {
    final newCriteria = _criteria.copyWith(
      clearMinPrice: true,
      clearMaxPrice: true,
    );
    setState(() => _criteria = newCriteria);
    context.read<PackagesCubit>().filterPackages(criteria: newCriteria);
  }

  void _clearAllFilters() {
    setState(() => _criteria = PackagesFilterCriteria.empty);
    context.read<PackagesCubit>().filterPackages(clearFilter: true);
  }

  String _formatPriceRange() {
    if (_criteria.minPrice != null && _criteria.maxPrice != null) {
      return 'السعر: ${_criteria.minPrice!.toStringAsFixed(0)} - ${_criteria.maxPrice!.toStringAsFixed(0)} ريال';
    } else if (_criteria.minPrice != null) {
      return 'السعر: من ${_criteria.minPrice!.toStringAsFixed(0)} ريال';
    } else if (_criteria.maxPrice != null) {
      return 'السعر: حتى ${_criteria.maxPrice!.toStringAsFixed(0)} ريال';
    }
    return 'نطاق السعر';
  }

  List<Widget> _buildActiveChips() {
    final chips = <Widget>[];

    if (_criteria.billingType != null && _criteria.billingType != 'all') {
      chips.add(
        AppActiveFilterChip(
          label: _criteria.billingType == 'monthly'
              ? 'الاشتراك: شهري'
              : 'الاشتراك: سنوي',
          icon: Icons.layers_outlined,
          onDeleted: _clearBillingTypeFilter,
        ),
      );
    }

    if (_criteria.minPrice != null || _criteria.maxPrice != null) {
      chips.add(
        AppActiveFilterChip(
          label: _formatPriceRange(),
          icon: Icons.payments_outlined,
          onDeleted: _clearPriceFilter,
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
    return BlocListener<PackagesCubit, PackagesState>(
      listener: (context, state) {
        if (state is PackagesDeleteSuccess) {
          AppSnackBar.showSuccess(state.message);
        } else if (state is PackagesFailure) {
          AppSnackBar.showError(state.message);
        }
      },
      child: BlocBuilder<PackagesCubit, PackagesState>(
        builder: (context, state) {
          if (state is PackagesLoading &&
              context.read<PackagesCubit>().packages.isEmpty) {
            return const SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: PackageCardSkeleton(),
            );
          }

          if (state is PackagesFailure &&
              context.read<PackagesCubit>().packages.isEmpty) {
            return ErrorStateView(
              message: state.message,
              onRetry: () {
                context.read<PackagesCubit>().getPackages();
              },
            );
          }

          final cubit = context.read<PackagesCubit>();
          final packages = cubit.filteredPackages;

          return Column(
            children: [
              EntityFilterToolbar(
                searchController: _searchController,
                searchHint: 'البحث عن اسم الباقة أو المعرف...',
                onOpenFilterDialog: _openFilterDialog,
                activeFiltersCount: _criteria.activeFiltersCount,
                activeChips: _buildActiveChips(),
                totalCount: packages.length,
                countLabel: 'إجمالي الباقات',
                countIcon: Icons.card_membership_outlined,
                onSearchChanged: (query) {
                  cubit.searchPackages(query);
                },
                onSearchCleared: () {
                  _searchController.clear();
                  cubit.searchPackages('');
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: packages.isEmpty
                    ? const Center(
                        child: TextEmptyViewData(),
                      )
                    : Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: packages.length,
                          padding: const EdgeInsets.only(bottom: 24),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final package = packages[index];

                            return WidgetDesignListPackage(
                              packageId: package.packageid?.toString(),
                              packageName: package.packagename,
                              packageLatinName: package.packagelatinname,
                              monthlyPrice: package.monthprice,
                              annualPrice: package.annualprice,
                              description: package.packagedisc,
                              latinDescription: package.packagelatindisc,
                              onTapDetails: () async {
                                final result = await Navigator.push(
                                  context,
                                  NavigateToPageWidget(
                                    PageDetailsPackages(
                                      packageID: package.packageid ?? 0,
                                    ),
                                  ),
                                );

                                if (result == true && context.mounted) {
                                  await context
                                      .read<PackagesCubit>()
                                      .getPackages();
                                }
                              },
                              onTapEdit: () async {
                                final result = await showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<PackagesCubit>(),
                                    child: EditPackageDialog(
                                      package: package,
                                    ),
                                  ),
                                );

                                if (result == true && context.mounted) {
                                  await context
                                      .read<PackagesCubit>()
                                      .getPackages();
                                }
                              },
                              onTapDelete: () async {
                                final confirmed =
                                    await showDeleteConfirmationDialogInApp(
                                  context,
                                );

                                if (confirmed != true) return;
                                if (!context.mounted) return;
                                if (package.packageid == null) return;

                                await context
                                    .read<PackagesCubit>()
                                    .deletePackage(
                                      packageId: package.packageid!,
                                    );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
