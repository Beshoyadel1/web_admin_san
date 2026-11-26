import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/packages_page/data/model/packages_filter_criteria.dart';

class PackagesFilterDialog extends StatefulWidget {
  final PackagesFilterCriteria initialCriteria;
  final ValueChanged<PackagesFilterCriteria> onApply;

  const PackagesFilterDialog({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required PackagesFilterCriteria initialCriteria,
    required ValueChanged<PackagesFilterCriteria> onApply,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => PackagesFilterDialog(
        initialCriteria: initialCriteria,
        onApply: onApply,
      ),
    );
  }

  @override
  State<PackagesFilterDialog> createState() => _PackagesFilterDialogState();
}

class _PackagesFilterDialogState extends State<PackagesFilterDialog> {
  late String _selectedBillingType;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    _selectedBillingType = widget.initialCriteria.billingType ?? 'all';
    _minPriceController = TextEditingController(
      text: widget.initialCriteria.minPrice?.toStringAsFixed(0) ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialCriteria.maxPrice?.toStringAsFixed(0) ?? '',
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
      _selectedBillingType = 'all';
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  void _applyFilter() {
    final minPrice = double.tryParse(_minPriceController.text.trim());
    final maxPrice = double.tryParse(_maxPriceController.text.trim());

    final criteria = PackagesFilterCriteria(
      minPrice: minPrice,
      maxPrice: maxPrice,
      billingType: _selectedBillingType,
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
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PackagesDialogHeader(onClose: () => Navigator.of(context).pop()),
              const SizedBox(height: 20),

              const _PackagesSectionTitle(
                title: 'نوع الاشتراك المفضل',
                icon: Icons.layers_outlined,
              ),
              const SizedBox(height: 10),
              _PackagesChoiceChipsRow<String>(
                items: const [
                  _PackagesChoiceItem<String>(value: 'all', label: 'الكل'),
                  _PackagesChoiceItem<String>(value: 'monthly', label: 'شهري'),
                  _PackagesChoiceItem<String>(value: 'annual', label: 'سنوي'),
                ],
                selectedValue: _selectedBillingType,
                onSelected: (val) {
                  setState(() {
                    _selectedBillingType = val;
                  });
                },
              ),
              const SizedBox(height: 20),

              const _PackagesSectionTitle(
                title: 'نطاق السعر (ريال)',
                icon: Icons.payments_outlined,
              ),
              const SizedBox(height: 10),
              _PackagesPriceRangeFields(
                minPriceController: _minPriceController,
                maxPriceController: _maxPriceController,
              ),
              const SizedBox(height: 28),

              _PackagesDialogFooterActions(
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

class _PackagesDialogHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _PackagesDialogHeader({required this.onClose});

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
                'تصفية الباقات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
              Text(
                'حدد نطاق الأسعار ونوع الاشتراك لتصفية الباقات',
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

class _PackagesSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PackagesSectionTitle({
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

class _PackagesChoiceItem<T> {
  final T value;
  final String label;

  const _PackagesChoiceItem({required this.value, required this.label});
}

class _PackagesChoiceChipsRow<T> extends StatelessWidget {
  final List<_PackagesChoiceItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  const _PackagesChoiceChipsRow({
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

class _PackagesPriceRangeFields extends StatelessWidget {
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;

  const _PackagesPriceRangeFields({
    required this.minPriceController,
    required this.maxPriceController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: minPriceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'الحد الأدنى',
              labelStyle: const TextStyle(
                fontSize: 12,
                color: AppColors.darkGreyColor,
              ),
              hintText: '0',
              prefixIcon: const Icon(
                Icons.arrow_downward_rounded,
                size: 16,
                color: AppColors.orangeColor,
              ),
              filled: true,
              fillColor: AppColors.scaffoldColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
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
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: maxPriceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'الحد الأقصى',
              labelStyle: const TextStyle(
                fontSize: 12,
                color: AppColors.darkGreyColor,
              ),
              hintText: 'غير محدد',
              prefixIcon: const Icon(
                Icons.arrow_upward_rounded,
                size: 16,
                color: AppColors.orangeColor,
              ),
              filled: true,
              fillColor: AppColors.scaffoldColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
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

class _PackagesDialogFooterActions extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  const _PackagesDialogFooterActions({
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
