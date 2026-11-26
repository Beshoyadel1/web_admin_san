import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/companies_page/data/model/companies_filter_criteria.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CompaniesFilterDialog extends StatefulWidget {
  final CompaniesFilterCriteria initialCriteria;
  final ValueChanged<CompaniesFilterCriteria> onApply;

  const CompaniesFilterDialog({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required CompaniesFilterCriteria initialCriteria,
    required ValueChanged<CompaniesFilterCriteria> onApply,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => CompaniesFilterDialog(
        initialCriteria: initialCriteria,
        onApply: onApply,
      ),
    );
  }

  @override
  State<CompaniesFilterDialog> createState() => _CompaniesFilterDialogState();
}

class _CompaniesFilterDialogState extends State<CompaniesFilterDialog> {
  late bool? _selectedIsActive;
  late DateTime? _startDate;
  late DateTime? _endDate;
  late String? _selectedPreset;

  @override
  void initState() {
    super.initState();
    _selectedIsActive = widget.initialCriteria.isActive;
    _startDate = widget.initialCriteria.startDate;
    _endDate = widget.initialCriteria.endDate;
    _selectedPreset = widget.initialCriteria.datePreset ??
        (_startDate == null && _endDate == null ? 'all' : 'custom');
  }

  void _onPresetSelected(String preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    setState(() {
      _selectedPreset = preset;
      switch (preset) {
        case 'all':
          _startDate = null;
          _endDate = null;
          break;
        case 'today':
          _startDate = today;
          _endDate = today;
          break;
        case 'last7days':
          _startDate = today.subtract(const Duration(days: 6));
          _endDate = today;
          break;
        case 'thisMonth':
          _startDate = DateTime(today.year, today.month, 1);
          _endDate = today;
          break;
        case 'custom':
          _startDate ??= DateTime(today.year, today.month, 1);
          _endDate ??= today;
          break;
      }
    });
  }

  void _resetAll() {
    setState(() {
      _selectedIsActive = null;
      _startDate = null;
      _endDate = null;
      _selectedPreset = 'all';
    });
  }

  void _applyFilter() {
    final criteria = CompaniesFilterCriteria(
      isActive: _selectedIsActive,
      startDate: _startDate,
      endDate: _endDate,
      datePreset: _selectedPreset,
    );
    widget.onApply(criteria);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CompaniesDialogHeader(
                  onClose: () => Navigator.of(context).pop()),
              const SizedBox(height: 20),
              _CompaniesSectionTitle(
                title: LocaleKeys.accountStatus.tr(),
                icon: Icons.business_outlined,
              ),
              const SizedBox(height: 10),
              _CompaniesChoiceChipsRow<bool?>(
                items: [
                  _CompaniesChoiceItem<bool?>(
                      value: null, label: LocaleKeys.all.tr()),
                  _CompaniesChoiceItem<bool?>(
                      value: true, label: LocaleKeys.branchActiveStatus.tr()),
                  _CompaniesChoiceItem<bool?>(
                      value: false,
                      label: LocaleKeys.branchInactiveStatus.tr()),
                ],
                selectedValue: _selectedIsActive,
                onSelected: (val) {
                  setState(() {
                    _selectedIsActive = val;
                  });
                },
              ),
              const SizedBox(height: 20),
              _CompaniesSectionTitle(
                title: LocaleKeys.registrationDate.tr(),
                icon: Icons.calendar_today_rounded,
              ),
              const SizedBox(height: 10),
              _CompaniesDatePresetChips(
                selectedPreset: _selectedPreset,
                onPresetSelected: _onPresetSelected,
              ),
              if (_selectedPreset == 'custom') ...[
                const SizedBox(height: 12),
                _CompaniesCustomDateRangePickerRow(
                  startDate: _startDate,
                  endDate: _endDate,
                  onStartDateChanged: (date) {
                    setState(() {
                      _startDate = date;
                      if (_endDate != null && _startDate!.isAfter(_endDate!)) {
                        _endDate = _startDate;
                      }
                    });
                  },
                  onEndDateChanged: (date) {
                    setState(() {
                      _endDate = date;
                      if (_startDate != null &&
                          _endDate!.isBefore(_startDate!)) {
                        _startDate = _endDate;
                      }
                    });
                  },
                ),
              ],
              const SizedBox(height: 28),
              _CompaniesDialogFooterActions(
                onReset: _resetAll,
                onApply: _applyFilter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompaniesDialogHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _CompaniesDialogHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.orangeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: AppColors.orangeColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.filterCompanies.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
              Text(
                LocaleKeys.selectFilterCriteriaCompanies.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.darkGreyColor,
                ),
              ),
            ],
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.darkGreyColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CompaniesSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _CompaniesSectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.orangeColor),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.darkColor,
          ),
        ),
      ],
    );
  }
}

class _CompaniesChoiceItem<T> {
  final T value;
  final String label;

  const _CompaniesChoiceItem({required this.value, required this.label});
}

class _CompaniesChoiceChipsRow<T> extends StatelessWidget {
  final List<_CompaniesChoiceItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  const _CompaniesChoiceChipsRow({
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final bool isSelected = item.value == selectedValue;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onSelected(item.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.orangeColor
                    : AppColors.scaffoldColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppColors.orangeColor
                      : AppColors.lightGreyColor,
                ),
              ),
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color:
                      isSelected ? AppColors.whiteColor : AppColors.darkColor,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CompaniesDatePresetChips extends StatelessWidget {
  final String? selectedPreset;
  final ValueChanged<String> onPresetSelected;

  const _CompaniesDatePresetChips({
    required this.selectedPreset,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final presets = [
      {'key': 'all', 'label': LocaleKeys.all.tr()},
      {'key': 'today', 'label': LocaleKeys.todayLabel.tr()},
      {'key': 'last7days', 'label': LocaleKeys.last7Days.tr()},
      {'key': 'thisMonth', 'label': LocaleKeys.thisMonth.tr()},
      {'key': 'custom', 'label': LocaleKeys.customRange.tr()},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((p) {
        final isSelected = selectedPreset == p['key'];
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onPresetSelected(p['key']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.orangeColor
                    : AppColors.scaffoldColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppColors.orangeColor
                      : AppColors.lightGreyColor,
                ),
              ),
              child: Text(
                p['label']!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color:
                      isSelected ? AppColors.whiteColor : AppColors.darkColor,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CompaniesCustomDateRangePickerRow extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;

  const _CompaniesCustomDateRangePickerRow({
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  Future<void> _pickDate(
    BuildContext context,
    DateTime? initialDate,
    ValueChanged<DateTime?> onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.orangeColor,
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.darkColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Row(
      children: [
        Expanded(
          child: _CompaniesDatePickerTile(
            label: LocaleKeys.fromDate.tr(),
            valueText: startDate != null
                ? dateFormat.format(startDate!)
                : LocaleKeys.selectDateHint.tr(),
            onTap: () => _pickDate(context, startDate, onStartDateChanged),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CompaniesDatePickerTile(
            label: LocaleKeys.toDate.tr(),
            valueText: endDate != null
                ? dateFormat.format(endDate!)
                : LocaleKeys.selectDateHint.tr(),
            onTap: () => _pickDate(context, endDate, onEndDateChanged),
          ),
        ),
      ],
    );
  }
}

class _CompaniesDatePickerTile extends StatelessWidget {
  final String label;
  final String valueText;
  final VoidCallback onTap;

  const _CompaniesDatePickerTile({
    required this.label,
    required this.valueText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.lightGreyColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.darkGreyColor,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 14,
                    color: AppColors.orangeColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    valueText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompaniesDialogFooterActions extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  const _CompaniesDialogFooterActions({
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: OutlinedButton(
              onPressed: onReset,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkGreyColor,
                side: const BorderSide(color: AppColors.lightGreyColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                LocaleKeys.resetFilter.tr(),
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                foregroundColor: AppColors.whiteColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                LocaleKeys.applyFilter.tr(),
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
