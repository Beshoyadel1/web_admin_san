import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/orders_page/data/model/orders_filter_criteria.dart';

class OrdersFilterDialog extends StatefulWidget {
  final OrdersFilterCriteria initialCriteria;
  final ValueChanged<OrdersFilterCriteria> onApply;

  const OrdersFilterDialog({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required OrdersFilterCriteria initialCriteria,
    required ValueChanged<OrdersFilterCriteria> onApply,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => OrdersFilterDialog(
        initialCriteria: initialCriteria,
        onApply: onApply,
      ),
    );
  }

  @override
  State<OrdersFilterDialog> createState() => _OrdersFilterDialogState();
}

class _OrdersFilterDialogState extends State<OrdersFilterDialog> {
  late int? _selectedOrderType;
  late int? _selectedUserType;
  late DateTime? _startDate;
  late DateTime? _endDate;
  late String? _selectedPreset;

  @override
  void initState() {
    super.initState();
    _selectedOrderType = widget.initialCriteria.orderType;
    _selectedUserType = widget.initialCriteria.userType;
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
      _selectedOrderType = null;
      _selectedUserType = null;
      _startDate = null;
      _endDate = null;
      _selectedPreset = 'all';
    });
  }

  void _applyFilter() {
    final criteria = OrdersFilterCriteria(
      orderType: _selectedOrderType,
      userType: _selectedUserType,
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
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _DialogHeader(onClose: () => Navigator.of(context).pop()),
              const SizedBox(height: 20),

              // Section 1: Date Range Presets
              const _SectionTitle(
                title: 'نطاق التاريخ',
                icon: Icons.calendar_today_rounded,
              ),
              const SizedBox(height: 10),
              _DatePresetChips(
                selectedPreset: _selectedPreset,
                onPresetSelected: _onPresetSelected,
              ),
              if (_selectedPreset == 'custom') ...[
                const SizedBox(height: 12),
                _CustomDateRangePickerRow(
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
              const SizedBox(height: 20),

              // Section 2: Order Category / Status
              const _SectionTitle(
                title: 'حالة الطلب',
                icon: Icons.assignment_outlined,
              ),
              const SizedBox(height: 10),
              _ChoiceChipsRow<int?>(
                items: const [
                  _ChoiceItem<int?>(value: null, label: 'جميع الحالات'),
                  _ChoiceItem<int?>(value: 1, label: 'طلبات جديدة'),
                  _ChoiceItem<int?>(value: 2, label: 'طلبات جارية'),
                  _ChoiceItem<int?>(value: 3, label: 'طلبات منتهية'),
                ],
                selectedValue: _selectedOrderType,
                onSelected: (val) {
                  setState(() {
                    _selectedOrderType = val;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Section 3: Customer Type
              const _SectionTitle(
                title: 'نوع العميل / صاحب الطلب',
                icon: Icons.people_outline_rounded,
              ),
              const SizedBox(height: 10),
              _ChoiceChipsRow<int?>(
                items: const [
                  _ChoiceItem<int?>(value: null, label: 'الكل'),
                  _ChoiceItem<int?>(value: 1, label: 'أفراد'),
                  _ChoiceItem<int?>(value: 2, label: 'شركات'),
                ],
                selectedValue: _selectedUserType,
                onSelected: (val) {
                  setState(() {
                    _selectedUserType = val;
                  });
                },
              ),
              const SizedBox(height: 28),

              // Footer Actions
              _DialogFooterActions(
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

class _DialogHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _DialogHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.orangeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: AppColors.orangeColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'تصفية الطلبات المتقدمة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
            ),
          ],
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
                size: 20,
                color: AppColors.darkGreyColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
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

class _DatePresetChips extends StatelessWidget {
  final String? selectedPreset;
  final ValueChanged<String> onPresetSelected;

  const _DatePresetChips({
    required this.selectedPreset,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final presets = [
      const _PresetItem(id: 'all', label: 'الكل'),
      const _PresetItem(id: 'today', label: 'اليوم'),
      const _PresetItem(id: 'last7days', label: 'آخر 7 أيام'),
      const _PresetItem(id: 'thisMonth', label: 'هذا الشهر'),
      const _PresetItem(id: 'custom', label: 'نطاق مخصص'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((p) {
        final isSelected = selectedPreset == p.id;
        return _FilterOptionChip(
          label: p.label,
          isSelected: isSelected,
          onTap: () => onPresetSelected(p.id),
        );
      }).toList(),
    );
  }
}

class _PresetItem {
  final String id;
  final String label;

  const _PresetItem({required this.id, required this.label});
}

class _CustomDateRangePickerRow extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onEndDateChanged;

  const _CustomDateRangePickerRow({
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightGreyColor.withValues(alpha: 0.8),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _MiniDatePickerBox(
              label: 'من تاريخ',
              selectedDate: startDate,
              onDateSelected: onStartDateChanged,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _MiniDatePickerBox(
              label: 'إلى تاريخ',
              selectedDate: endDate,
              onDateSelected: onEndDateChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniDatePickerBox extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _MiniDatePickerBox({
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.orangeColor,
              onPrimary: AppColors.whiteColor,
              surface: AppColors.whiteColor,
              onSurface: AppColors.darkColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
        : 'اختر تاريخ';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _pickDate(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGreyColor,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.lightGreyColor),
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: selectedDate != null
                            ? AppColors.darkColor
                            : AppColors.darkGreyColor,
                      ),
                    ),
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                      color: AppColors.orangeColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceItem<T> {
  final T value;
  final String label;

  const _ChoiceItem({required this.value, required this.label});
}

class _ChoiceChipsRow<T> extends StatelessWidget {
  final List<_ChoiceItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  const _ChoiceChipsRow({
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
        final isSelected = selectedValue == item.value;
        return _FilterOptionChip(
          label: item.label,
          isSelected: isSelected,
          onTap: () => onSelected(item.value),
        );
      }).toList(),
    );
  }
}

class _FilterOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orangeColor : AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected ? AppColors.orangeColor : AppColors.lightGreyColor,
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.orangeColor.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.whiteColor : AppColors.darkColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogFooterActions extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  const _DialogFooterActions({
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: onReset,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(color: AppColors.lightGreyColor),
            ),
            child: const Text(
              'إعادة تعيين',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreyColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_rounded, size: 18),
                SizedBox(width: 6),
                Text(
                  'تطبيق الفلتر',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
