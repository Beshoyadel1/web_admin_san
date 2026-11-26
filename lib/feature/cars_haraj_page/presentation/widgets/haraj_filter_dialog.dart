import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/haraj_filter_criteria.dart';

class HarajFilterDialog extends StatefulWidget {
  final HarajFilterCriteria initialCriteria;
  final ValueChanged<HarajFilterCriteria> onApply;

  const HarajFilterDialog({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required HarajFilterCriteria initialCriteria,
    required ValueChanged<HarajFilterCriteria> onApply,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => HarajFilterDialog(
        initialCriteria: initialCriteria,
        onApply: onApply,
      ),
    );
  }

  @override
  State<HarajFilterDialog> createState() => _HarajFilterDialogState();
}

class _HarajFilterDialogState extends State<HarajFilterDialog> {
  late bool? _selectedIsNew;
  late int? _selectedStatus;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    _selectedIsNew = widget.initialCriteria.isNew;
    _selectedStatus = widget.initialCriteria.status;
    _minPriceController = TextEditingController(
      text: widget.initialCriteria.minPrice != null
          ? widget.initialCriteria.minPrice!.toStringAsFixed(0)
          : '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialCriteria.maxPrice != null
          ? widget.initialCriteria.maxPrice!.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _resetAll() {
    setState(() {
      _selectedIsNew = null;
      _selectedStatus = null;
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  void _applyFilter() {
    final double? minP = double.tryParse(_minPriceController.text.trim());
    final double? maxP = double.tryParse(_maxPriceController.text.trim());

    final criteria = HarajFilterCriteria(
      isNew: _selectedIsNew,
      status: _selectedStatus,
      minPrice: minP,
      maxPrice: maxP,
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
              _HarajDialogHeader(onClose: () => Navigator.of(context).pop()),
              const SizedBox(height: 20),

              const _HarajSectionTitle(
                title: 'حالة السيارة',
                icon: Icons.directions_car_outlined,
              ),
              const SizedBox(height: 10),
              _HarajChoiceChipsRow<bool?>(
                items: const [
                  _HarajChoiceItem<bool?>(value: null, label: 'الكل'),
                  _HarajChoiceItem<bool?>(value: true, label: 'جديدة'),
                  _HarajChoiceItem<bool?>(value: false, label: 'مستعملة'),
                ],
                selectedValue: _selectedIsNew,
                onSelected: (val) {
                  setState(() {
                    _selectedIsNew = val;
                  });
                },
              ),
              const SizedBox(height: 20),

              const _HarajSectionTitle(
                title: 'حالة الاعتماد والنشر',
                icon: Icons.verified_outlined,
              ),
              const SizedBox(height: 10),
              _HarajChoiceChipsRow<int?>(
                items: const [
                  _HarajChoiceItem<int?>(value: null, label: 'الكل'),
                  _HarajChoiceItem<int?>(value: 1, label: 'بانتظار الموافقة'),
                  _HarajChoiceItem<int?>(value: 2, label: 'مقبولة'),
                  _HarajChoiceItem<int?>(value: 3, label: 'مرفوضة'),
                ],
                selectedValue: _selectedStatus,
                onSelected: (val) {
                  setState(() {
                    _selectedStatus = val;
                  });
                },
              ),
              const SizedBox(height: 20),

              const _HarajSectionTitle(
                title: 'نطاق السعر',
                icon: Icons.payments_outlined,
              ),
              const SizedBox(height: 10),
              _HarajPriceRangeRow(
                minController: _minPriceController,
                maxController: _maxPriceController,
              ),
              const SizedBox(height: 28),

              _HarajDialogFooterActions(
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

class _HarajDialogHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _HarajDialogHeader({required this.onClose});

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
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تصفية سيارات الحراج',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
              Text(
                'حدد المعايير المطلوبة لتصفية قائمة السيارات المعروضة',
                style: TextStyle(
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

class _HarajSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _HarajSectionTitle({
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

class _HarajChoiceItem<T> {
  final T value;
  final String label;

  const _HarajChoiceItem({required this.value, required this.label});
}

class _HarajChoiceChipsRow<T> extends StatelessWidget {
  final List<_HarajChoiceItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  const _HarajChoiceChipsRow({
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
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.darkColor,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HarajPriceRangeRow extends StatelessWidget {
  final TextEditingController minController;
  final TextEditingController maxController;

  const _HarajPriceRangeRow({
    required this.minController,
    required this.maxController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: minController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 13, color: AppColors.darkColor),
            decoration: InputDecoration(
              labelText: 'الحد الأدنى',
              labelStyle: const TextStyle(
                fontSize: 12,
                color: AppColors.darkGreyColor,
              ),
              hintText: '0',
              filled: true,
              fillColor: AppColors.scaffoldColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.lightGreyColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.lightGreyColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.orangeColor),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: maxController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 13, color: AppColors.darkColor),
            decoration: InputDecoration(
              labelText: 'الحد الأقصى',
              labelStyle: const TextStyle(
                fontSize: 12,
                color: AppColors.darkGreyColor,
              ),
              hintText: 'مثال: 150000',
              filled: true,
              fillColor: AppColors.scaffoldColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.lightGreyColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.lightGreyColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.orangeColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HarajDialogFooterActions extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  const _HarajDialogFooterActions({
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
              child: const Text(
                'إعادة تعيين',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
              child: const Text(
                'تطبيق الفلتر',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
