import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/approved_centers_page/data/model/approved_centers_filter_criteria.dart';

class ApprovedCentersFilterDialog extends StatefulWidget {
  final ApprovedCentersFilterCriteria initialCriteria;
  final ValueChanged<ApprovedCentersFilterCriteria> onApply;

  const ApprovedCentersFilterDialog({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required ApprovedCentersFilterCriteria initialCriteria,
    required ValueChanged<ApprovedCentersFilterCriteria> onApply,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => ApprovedCentersFilterDialog(
        initialCriteria: initialCriteria,
        onApply: onApply,
      ),
    );
  }

  @override
  State<ApprovedCentersFilterDialog> createState() =>
      _ApprovedCentersFilterDialogState();
}

class _ApprovedCentersFilterDialogState
    extends State<ApprovedCentersFilterDialog> {
  late bool? _selectedIsActive;

  @override
  void initState() {
    super.initState();
    _selectedIsActive = widget.initialCriteria.isActive;
  }

  void _resetAll() {
    setState(() {
      _selectedIsActive = null;
    });
  }

  void _applyFilter() {
    final criteria = ApprovedCentersFilterCriteria(
      isActive: _selectedIsActive,
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
              _ApprovedCentersDialogHeader(
                onClose: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 20),

              const _ApprovedCentersSectionTitle(
                title: 'حالة اعتماد وتفعيل المركز',
                icon: Icons.verified_outlined,
              ),
              const SizedBox(height: 10),
              _ApprovedCentersChoiceChipsRow<bool?>(
                items: const [
                  _ApprovedCentersChoiceItem<bool?>(
                    value: null,
                    label: 'الكل',
                  ),
                  _ApprovedCentersChoiceItem<bool?>(
                    value: true,
                    label: 'نشط ومعتمد',
                  ),
                  _ApprovedCentersChoiceItem<bool?>(
                    value: false,
                    label: 'غير نشط',
                  ),
                ],
                selectedValue: _selectedIsActive,
                onSelected: (val) {
                  setState(() {
                    _selectedIsActive = val;
                  });
                },
              ),
              const SizedBox(height: 28),

              _ApprovedCentersDialogFooterActions(
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

class _ApprovedCentersDialogHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _ApprovedCentersDialogHeader({required this.onClose});

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
                'تصفية المراكز المعتمدة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
              Text(
                'حدد حالة المركز لتصفية المراكز المعتمدة',
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

class _ApprovedCentersSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ApprovedCentersSectionTitle({
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

class _ApprovedCentersChoiceItem<T> {
  final T value;
  final String label;

  const _ApprovedCentersChoiceItem({required this.value, required this.label});
}

class _ApprovedCentersChoiceChipsRow<T> extends StatelessWidget {
  final List<_ApprovedCentersChoiceItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  const _ApprovedCentersChoiceChipsRow({
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

class _ApprovedCentersDialogFooterActions extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  const _ApprovedCentersDialogFooterActions({
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
