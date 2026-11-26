import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/providers_page/data/model/providers_filter_criteria.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ProvidersFilterDialog extends StatefulWidget {
  final ProvidersFilterCriteria initialCriteria;
  final ValueChanged<ProvidersFilterCriteria> onApply;

  const ProvidersFilterDialog({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required ProvidersFilterCriteria initialCriteria,
    required ValueChanged<ProvidersFilterCriteria> onApply,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => ProvidersFilterDialog(
        initialCriteria: initialCriteria,
        onApply: onApply,
      ),
    );
  }

  @override
  State<ProvidersFilterDialog> createState() => _ProvidersFilterDialogState();
}

class _ProvidersFilterDialogState extends State<ProvidersFilterDialog> {
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
    final criteria = ProvidersFilterCriteria(
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
              _ProvidersDialogHeader(
                  onClose: () => Navigator.of(context).pop()),
              const SizedBox(height: 20),
              _ProvidersSectionTitle(
                title: LocaleKeys.accountStatus.tr(),
                icon: Icons.storefront_outlined,
              ),
              const SizedBox(height: 10),
              _ProvidersChoiceChipsRow<bool?>(
                items: [
                  _ProvidersChoiceItem<bool?>(
                      value: null, label: LocaleKeys.all.tr()),
                  _ProvidersChoiceItem<bool?>(
                      value: true, label: LocaleKeys.branchActiveStatus.tr()),
                  _ProvidersChoiceItem<bool?>(
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
              _ProvidersSectionTitle(
                title: LocaleKeys.joinAndRegistrationDate.tr(),
                icon: Icons.calendar_today_rounded,
              ),
              const SizedBox(height: 10),
              _ProvidersDatePresetChips(
                selectedPreset: _selectedPreset,
                onPresetSelected: _onPresetSelected,
              ),
              if (_selectedPreset == 'custom') ...[
                const SizedBox(height: 12),
                _ProvidersCustomDateRangePickerRow(
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
              _ProvidersDialogFooterActions(
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

class _ProvidersDialogHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _ProvidersDialogHeader({required this.onClose});

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
                LocaleKeys.filterProviders.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
              Text(
                LocaleKeys.selectFilterCriteriaProviders.tr(),
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

class _ProvidersSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ProvidersSectionTitle({
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

class _ProvidersChoiceItem<T> {
  final T value;
  final String label;

  const _ProvidersChoiceItem({required this.value, required this.label});
}

class _ProvidersChoiceChipsRow<T> extends StatelessWidget {
  final List<_ProvidersChoiceItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  const _ProvidersChoiceChipsRow({
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

class _ProvidersDatePresetChips extends StatelessWidget {
  final String? selectedPreset;
  final ValueChanged<String> onPresetSelected;

  const _ProvidersDatePresetChips({
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

class _ProvidersCustomDateRangePickerRow extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;

  const _ProvidersCustomDateRangePickerRow({
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
          child: _ProvidersDatePickerTile(
            label: LocaleKeys.fromDate.tr(),
            valueText: startDate != null
                ? dateFormat.format(startDate!)
                : LocaleKeys.selectDateHint.tr(),
            onTap: () => _pickDate(context, startDate, onStartDateChanged),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ProvidersDatePickerTile(
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

class _ProvidersDatePickerTile extends StatelessWidget {
  final String label;
  final String valueText;
  final VoidCallback onTap;

  const _ProvidersDatePickerTile({
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

class _ProvidersDialogFooterActions extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  const _ProvidersDialogFooterActions({
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
