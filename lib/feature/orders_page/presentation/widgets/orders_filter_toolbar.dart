import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/text_form_field_widget.dart';
import 'package:web_admin_san/feature/orders_page/data/model/orders_filter_criteria.dart';

class OrdersFilterToolbar extends StatefulWidget {
  final TextEditingController searchController;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final VoidCallback? onSearchCleared;
  final OrdersFilterCriteria criteria;
  final VoidCallback onOpenFilterDialog;
  final VoidCallback? onClearDateFilter;
  final VoidCallback? onClearOrderStatusFilter;
  final VoidCallback? onClearUserTypeFilter;
  final VoidCallback? onClearAllFilters;
  final int? totalCount;
  final String? countLabel;
  final Duration debounceDuration;

  const OrdersFilterToolbar({
    super.key,
    required this.searchController,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchCleared,
    required this.criteria,
    required this.onOpenFilterDialog,
    this.onClearDateFilter,
    this.onClearOrderStatusFilter,
    this.onClearUserTypeFilter,
    this.onClearAllFilters,
    this.totalCount,
    this.countLabel,
    this.debounceDuration = const Duration(milliseconds: 400),
  });

  @override
  State<OrdersFilterToolbar> createState() => _OrdersFilterToolbarState();
}

class _OrdersFilterToolbarState extends State<OrdersFilterToolbar> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onChanged(String val) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onSearchChanged?.call(val);
    });
    setState(() {});
  }

  void _onSubmit() {
    _debounceTimer?.cancel();
    widget.onSearchSubmitted?.call();
  }

  void _onClear() {
    _debounceTimer?.cancel();
    widget.searchController.clear();
    widget.onSearchCleared?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasSearchText = widget.searchController.text.trim().isNotEmpty;
    final activeFiltersCount = widget.criteria.activeFiltersCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGreyColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  _OrdersSearchField(
                    controller: widget.searchController,
                    hintText: widget.searchHint ??
                        'البحث برقم الطلب، العميل، المركز...',
                    hasText: hasSearchText,
                    onChanged: _onChanged,
                    onSubmit: _onSubmit,
                    onClear: _onClear,
                  ),
                  _OrdersFilterButton(
                    activeCount: activeFiltersCount,
                    onTap: widget.onOpenFilterDialog,
                  ),
                ],
              ),
              if (widget.totalCount != null)
                _OrdersTotalCountBadge(
                  count: widget.totalCount!,
                  label: widget.countLabel ?? 'إجمالي الطلبات',
                ),
            ],
          ),
          if (widget.criteria.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.lightGreyColor, height: 1),
            const SizedBox(height: 10),
            _ActiveFilterChipsRow(
              criteria: widget.criteria,
              onClearDate: widget.onClearDateFilter,
              onClearStatus: widget.onClearOrderStatusFilter,
              onClearUserType: widget.onClearUserTypeFilter,
              onClearAll: widget.onClearAllFilters,
            ),
          ],
        ],
      ),
    );
  }
}

class _OrdersSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool hasText;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final VoidCallback onClear;

  const _OrdersSearchField({
    required this.controller,
    required this.hintText,
    required this.hasText,
    required this.onChanged,
    required this.onSubmit,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextFormFieldWidget(
        textFormController: controller,
        hintText: hintText,
        suffixIcon: hasText ? Icons.close : Icons.search,
        suffixOnPressed: hasText ? onClear : onSubmit,
        onEditingComplete: onSubmit,
        onChanged: onChanged,
        isColumn: false,
        textFormHeight: 42,
        fillColor: AppColors.scaffoldColor,
        borderColor: AppColors.lightGreyColor,
        focusBorderColor: AppColors.orangeColor,
      ),
    );
  }
}

class _OrdersFilterButton extends StatelessWidget {
  final int activeCount;
  final VoidCallback onTap;

  const _OrdersFilterButton({
    required this.activeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasActiveFilters = activeCount > 0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: hasActiveFilters
                ? AppColors.orangeColor.withValues(alpha: 0.08)
                : AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasActiveFilters
                  ? AppColors.orangeColor
                  : AppColors.lightGreyColor,
              width: hasActiveFilters ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                size: 19,
                color: hasActiveFilters
                    ? AppColors.orangeColor
                    : AppColors.darkGreyColor,
              ),
              const SizedBox(width: 8),
              Text(
                'تصفية متقدمة',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: hasActiveFilters
                      ? AppColors.orangeColor
                      : AppColors.darkColor,
                ),
              ),
              if (hasActiveFilters) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.orangeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$activeCount',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OrdersTotalCountBadge extends StatelessWidget {
  final int count;
  final String label;

  const _OrdersTotalCountBadge({
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.scaffoldColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.lightGreyColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.receipt_long_rounded,
              size: 18,
              color: AppColors.orangeColor,
            ),
            const SizedBox(width: 8),
            Text(
              '$label: $count',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveFilterChipsRow extends StatelessWidget {
  final OrdersFilterCriteria criteria;
  final VoidCallback? onClearDate;
  final VoidCallback? onClearStatus;
  final VoidCallback? onClearUserType;
  final VoidCallback? onClearAll;

  const _ActiveFilterChipsRow({
    required this.criteria,
    this.onClearDate,
    this.onClearStatus,
    this.onClearUserType,
    this.onClearAll,
  });

  String _formatDateRange() {
    final dateFormat = DateFormat('yyyy/MM/dd');
    switch (criteria.datePreset) {
      case 'today':
        return 'التاريخ: اليوم';
      case 'last7days':
        return 'التاريخ: آخر 7 أيام';
      case 'thisMonth':
        return 'التاريخ: هذا الشهر';
      default:
        if (criteria.startDate != null && criteria.endDate != null) {
          return 'التاريخ: ${dateFormat.format(criteria.startDate!)} - ${dateFormat.format(criteria.endDate!)}';
        } else if (criteria.startDate != null) {
          return 'من تاريخ: ${dateFormat.format(criteria.startDate!)}';
        } else if (criteria.endDate != null) {
          return 'إلى تاريخ: ${dateFormat.format(criteria.endDate!)}';
        }
        return 'نطاق التاريخ';
    }
  }

  String _formatStatusLabel() {
    switch (criteria.orderType) {
      case 1:
        return 'الحالة: طلبات جديدة';
      case 2:
        return 'الحالة: طلبات جارية';
      case 3:
        return 'الحالة: طلبات منتهية';
      default:
        return 'حالة الطلب';
    }
  }

  String _formatUserTypeLabel() {
    switch (criteria.userType) {
      case 1:
        return 'العميل: أفراد';
      case 2:
        return 'العميل: شركات';
      default:
        return 'نوع العميل';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasDate = criteria.startDate != null ||
        criteria.endDate != null ||
        (criteria.datePreset != null && criteria.datePreset != 'all');
    final bool hasStatus = criteria.orderType != null;
    final bool hasUserType = criteria.userType != null;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_outlined,
              size: 16,
              color: AppColors.darkGreyColor,
            ),
            SizedBox(width: 4),
            Text(
              'الفلاتر النشطة:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreyColor,
              ),
            ),
          ],
        ),
        if (hasDate)
          _ActiveDismissibleChip(
            label: _formatDateRange(),
            icon: Icons.calendar_today_rounded,
            onDeleted: onClearDate,
          ),
        if (hasStatus)
          _ActiveDismissibleChip(
            label: _formatStatusLabel(),
            icon: Icons.assignment_outlined,
            onDeleted: onClearStatus,
          ),
        if (hasUserType)
          _ActiveDismissibleChip(
            label: _formatUserTypeLabel(),
            icon: Icons.people_outline_rounded,
            onDeleted: onClearUserType,
          ),
        if (onClearAll != null) _ClearAllFiltersChip(onClearAll: onClearAll!),
      ],
    );
  }
}

class _ActiveDismissibleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onDeleted;

  const _ActiveDismissibleChip({
    required this.label,
    required this.icon,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.orangeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.orangeColor.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.orangeColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.darkColor,
            ),
          ),
          if (onDeleted != null) ...[
            const SizedBox(width: 6),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onDeleted,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.orangeColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 13,
                    color: AppColors.orangeColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ClearAllFiltersChip extends StatelessWidget {
  final VoidCallback onClearAll;

  const _ClearAllFiltersChip({
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onClearAll,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.lightGreyColor),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.restart_alt_rounded,
                size: 14,
                color: AppColors.darkGreyColor,
              ),
              SizedBox(width: 4),
              Text(
                'مسح الكل',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
