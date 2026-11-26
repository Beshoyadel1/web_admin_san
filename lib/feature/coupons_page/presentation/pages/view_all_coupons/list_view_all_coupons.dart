import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:web_admin_san/core/widgets/app_active_filter_chip.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/widgets/entity_filter_toolbar.dart';
import 'package:web_admin_san/core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/core/widgets/show_delete_confirmation_dialog_in_app.dart';
import 'package:web_admin_san/feature/coupons_page/data/model/coupons_filter_criteria.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/page_details_coupons/page_details_coupons.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/create_coupon_dialog.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/widgets/coupons_filter_dialog.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/widgets/widget_design_list_coupon.dart';
import 'package:web_admin_san/feature/coupons_page/view_model/coupon_cubit/coupon_cubit.dart';
import 'package:web_admin_san/feature/coupons_page/view_model/coupon_cubit/coupon_state.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';

class ListCouponsPage extends StatefulWidget {
  const ListCouponsPage({super.key});

  @override
  State<ListCouponsPage> createState() => _ListCouponsPageState();
}

class _ListCouponsPageState extends State<ListCouponsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  CouponsFilterCriteria _criteria = CouponsFilterCriteria.empty;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openFilterDialog() {
    CouponsFilterDialog.show(
      context,
      initialCriteria: _criteria,
      onApply: (newCriteria) {
        setState(() {
          _criteria = newCriteria;
        });
        context.read<CouponCubit>().filterCoupons(criteria: newCriteria);
      },
    );
  }

  void _clearStatusFilter() {
    final newCriteria = _criteria.copyWith(clearIsActive: true);
    setState(() => _criteria = newCriteria);
    context.read<CouponCubit>().filterCoupons(criteria: newCriteria);
  }

  void _clearDateFilter() {
    final newCriteria = _criteria.copyWith(
      clearStartDate: true,
      clearEndDate: true,
      clearDatePreset: true,
    );
    setState(() => _criteria = newCriteria);
    context.read<CouponCubit>().filterCoupons(criteria: newCriteria);
  }

  void _clearAllFilters() {
    setState(() => _criteria = CouponsFilterCriteria.empty);
    context.read<CouponCubit>().filterCoupons(clearFilter: true);
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
        return 'نطاق الصلاحية والتاريخ';
    }
  }

  List<Widget> _buildActiveChips() {
    final chips = <Widget>[];

    if (_criteria.isActive != null) {
      chips.add(
        AppActiveFilterChip(
          label: _criteria.isActive! ? 'الحالة: نشط' : 'الحالة: غير نشط',
          icon: Icons.discount_outlined,
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
    return BlocBuilder<CouponCubit, CouponState>(
      builder: (context, state) {
        // Loading
        if (state is CouponLoading) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }

        // Failure
        if (state is CouponFailure) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 400,
                child: Center(
                  child: Text(
                    state.message,
                  ),
                ),
              ),
            ],
          );
        }

        // Success
        if (state is CouponGetAllSuccess) {
          final cubit = context.read<CouponCubit>();
          final coupons = state.coupons;

          return Column(
            children: [
              EntityFilterToolbar(
                searchController: _searchController,
                searchHint: 'البحث عن كود الكوبون...',
                onOpenFilterDialog: _openFilterDialog,
                activeFiltersCount: _criteria.activeFiltersCount,
                activeChips: _buildActiveChips(),
                totalCount: coupons.length,
                countLabel: 'إجمالي الكوبونات',
                countIcon: Icons.discount_outlined,
                onSearchChanged: (query) {
                  cubit.filterCoupons(search: query);
                },
                onSearchCleared: () {
                  _searchController.clear();
                  cubit.filterCoupons(search: '');
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: coupons.isEmpty
                    ? const Center(
                        child: TextEmptyViewData(),
                      )
                    : Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 20),
                          children: [
                            CustomContainer(
                              isSelected: false,
                              containerWidth: double.infinity,
                              onTap: () {},
                              typeWidget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  coupons.length,
                                  (index) {
                                    final coupon = coupons[index];

                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: index == coupons.length - 1
                                            ? 0
                                            : 20,
                                      ),
                                      child: WidgetDesignListCoupon(
                                        couponId: coupon.coupon.couponId,
                                        couponCode: coupon.coupon.couponCode,
                                        discountValue:
                                            coupon.coupon.discountValue,
                                        isActive: coupon.coupon.isActive,
                                        startDate:
                                            coupon.coupon.couponStartDate,
                                        endDate: coupon.coupon.couponEndDate,

                                        // Status Quick Toggle
                                        onToggleStatus: () async {
                                          await context
                                              .read<CouponCubit>()
                                              .toggleCouponStatus(
                                                couponData: coupon,
                                              );
                                        },

                                        // Details
                                        onTapDetails: () async {
                                          final result = await Navigator.push(
                                            context,
                                            NavigateToPageWidget(
                                                PageDetailsCoupons(
                                              couponId:
                                                  coupon.coupon.couponId ?? 0,
                                            )),
                                          );

                                          if (!context.mounted) return;
                                          if (result == true) {
                                            await context
                                                .read<CouponCubit>()
                                                .getAllCoupons();
                                          }
                                        },

                                        // Edit
                                        onTapEdit: () async {
                                          final result = await showDialog<bool>(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) {
                                              return BlocProvider.value(
                                                value:
                                                    context.read<CouponCubit>(),
                                                child: CreateCouponDialog(
                                                  couponData: coupon,
                                                ),
                                              );
                                            },
                                          );

                                          if (!context.mounted) return;
                                          if (result == true) {
                                            await context
                                                .read<CouponCubit>()
                                                .getAllCoupons();
                                          }
                                        },

                                        // Delete
                                        onTapDelete: () async {
                                          final confirmed =
                                              await showDeleteConfirmationDialogInApp(
                                            context,
                                          );

                                          if (confirmed != true) return;

                                          final couponId =
                                              coupon.coupon.couponId;
                                          if (couponId == null) return;

                                          if (!context.mounted) return;
                                          await context
                                              .read<CouponCubit>()
                                              .deleteCoupon(
                                                couponId: couponId,
                                              );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        }

        // Initial
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(
              height: 400,
            ),
          ],
        );
      },
    );
  }
}
