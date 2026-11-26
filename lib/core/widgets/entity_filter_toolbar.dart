import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/app_search_dropdown.dart';
import 'package:web_admin_san/core/widgets/text_form_field_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class EntityFilterToolbar extends StatefulWidget {
  final TextEditingController searchController;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final VoidCallback? onSearchCleared;
  final VoidCallback? onOpenFilterDialog;
  final int activeFiltersCount;
  final List<Widget>? activeChips;

  // Legacy compatibility fields
  final String? statusLabel;
  final bool? selectedStatus;
  final ValueChanged<bool?>? onStatusChanged;

  final int? totalCount;
  final String? countLabel;
  final IconData? countIcon;
  final Duration debounceDuration;
  final List<Widget>? extraActions;

  const EntityFilterToolbar({
    super.key,
    required this.searchController,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchCleared,
    this.onOpenFilterDialog,
    this.activeFiltersCount = 0,
    this.activeChips,
    this.statusLabel,
    this.selectedStatus,
    this.onStatusChanged,
    this.totalCount,
    this.countLabel,
    this.countIcon,
    this.debounceDuration = const Duration(milliseconds: 400),
    this.extraActions,
  });

  @override
  State<EntityFilterToolbar> createState() => _EntityFilterToolbarState();
}

class _EntityFilterToolbarState extends State<EntityFilterToolbar> {
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
  }

  void _onSubmit() {
    _debounceTimer?.cancel();
    widget.onSearchSubmitted?.call();
  }

  void _onClear() {
    _debounceTimer?.cancel();
    widget.searchController.clear();
    widget.onSearchCleared?.call();
  }

  @override
  Widget build(BuildContext context) {
    final defaultCountLabel = LocaleKeys.totalRecords.tr();
    final bool hasActiveChips =
        widget.activeChips != null && widget.activeChips!.isNotEmpty;

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
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _ToolbarSearchField(
                    controller: widget.searchController,
                    hintText: widget.searchHint ?? LocaleKeys.search.tr(),
                    onChanged: _onChanged,
                    onSubmit: _onSubmit,
                    onClear: _onClear,
                  ),
                  if (widget.onOpenFilterDialog != null)
                    _ToolbarFilterButton(
                      activeCount: widget.activeFiltersCount,
                      onTap: widget.onOpenFilterDialog!,
                    )
                  else if (widget.onStatusChanged != null)
                    AppSearchDropdown<bool?>(
                      aboveText: widget.statusLabel ?? LocaleKeys.accountStatus,
                      hintText: LocaleKeys.common_allCategories,
                      width: 180,
                      height: 42,
                      initialSelection: widget.selectedStatus,
                      dropdownMenuEntries: [
                        DropdownMenuEntry<bool?>(
                          value: null,
                          label: LocaleKeys.common_allCategories.tr(),
                        ),
                        DropdownMenuEntry<bool?>(
                          value: true,
                          label: LocaleKeys.active.tr(),
                        ),
                        DropdownMenuEntry<bool?>(
                          value: false,
                          label: LocaleKeys.inactive.tr(),
                        ),
                      ],
                      onChanged: widget.onStatusChanged!,
                    ),
                  if (widget.extraActions != null) ...widget.extraActions!,
                ],
              ),
              if (widget.totalCount != null)
                _ToolbarTotalCountBadge(
                  count: widget.totalCount!,
                  label: widget.countLabel ?? defaultCountLabel,
                  icon: widget.countIcon ?? Icons.analytics_outlined,
                ),
            ],
          ),
          if (hasActiveChips) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.lightGreyColor, height: 1),
            const SizedBox(height: 10),
            _ToolbarActiveChipsRow(chips: widget.activeChips!),
          ],
        ],
      ),
    );
  }
}

class _ToolbarSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final VoidCallback onClear;

  const _ToolbarSearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onSubmit,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          final hasText = value.text.trim().isNotEmpty;
          return TextFormFieldWidget(
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
          );
        },
      ),
    );
  }
}

class _ToolbarFilterButton extends StatelessWidget {
  final int activeCount;
  final VoidCallback onTap;

  const _ToolbarFilterButton({
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

class _ToolbarTotalCountBadge extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;

  const _ToolbarTotalCountBadge({
    required this.count,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGreyColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
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
    );
  }
}

class _ToolbarActiveChipsRow extends StatelessWidget {
  final List<Widget> chips;

  const _ToolbarActiveChipsRow({
    required this.chips,
  });

  @override
  Widget build(BuildContext context) {
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
        ...chips,
      ],
    );
  }
}
