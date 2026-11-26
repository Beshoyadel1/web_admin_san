import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../data/model/delivery_setting_model.dart';

class DeliverySettingsCard extends StatefulWidget {
  final DeliverySettingModel? initialSetting;
  final bool isUpdating;
  final void Function({
    required double deliveryCost,
    required double deliveryPrice,
    required bool isDeliveryEnabled,
  }) onSave;

  const DeliverySettingsCard({
    super.key,
    required this.initialSetting,
    required this.isUpdating,
    required this.onSave,
  });

  @override
  State<DeliverySettingsCard> createState() => _DeliverySettingsCardState();
}

class _DeliverySettingsCardState extends State<DeliverySettingsCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;
  late TextEditingController _costController;
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _initValues();
  }

  @override
  void didUpdateWidget(covariant DeliverySettingsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSetting != widget.initialSetting &&
        !widget.isUpdating) {
      _initValues();
    }
  }

  void _initValues() {
    final setting = widget.initialSetting;
    _priceController = TextEditingController(
      text: setting != null ? setting.deliveryPrice.toStringAsFixed(2) : '0.00',
    );
    _costController = TextEditingController(
      text: setting != null ? setting.deliveryCost.toStringAsFixed(2) : '0.00',
    );
    _isEnabled = setting?.isDeliveryEnabled ?? false;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final cost = double.tryParse(_costController.text.trim()) ?? 0.0;

    widget.onSave(
      deliveryCost: cost,
      deliveryPrice: price,
      isDeliveryEnabled: _isEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.CircleLightorangeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune_outlined,
                    color: AppColors.orangeColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.deliverySettings.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        LocaleKeys.deliveryStatus.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Switch(
                    value: _isEnabled,
                    activeThumbColor: AppColors.orangeColor,
                    onChanged: widget.isUpdating
                        ? null
                        : (val) {
                            setState(() {
                              _isEnabled = val;
                            });
                          },
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.veryLightGreyColor, height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 650;

                return isNarrow
                    ? Column(
                        children: [
                          DeliveryInputField(
                            label: LocaleKeys.deliveryPrice.tr(),
                            controller: _priceController,
                            enabled: !widget.isUpdating,
                          ),
                          const SizedBox(height: 16),
                          DeliveryInputField(
                            label: LocaleKeys.deliveryCost.tr(),
                            controller: _costController,
                            enabled: !widget.isUpdating,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: DeliveryInputField(
                              label: LocaleKeys.deliveryPrice.tr(),
                              controller: _priceController,
                              enabled: !widget.isUpdating,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DeliveryInputField(
                              label: LocaleKeys.deliveryCost.tr(),
                              controller: _costController,
                              enabled: !widget.isUpdating,
                            ),
                          ),
                        ],
                      );
              },
            ),
            const SizedBox(height: 24),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton.icon(
                  onPressed: widget.isUpdating ? null : _handleSave,
                  icon: widget.isUpdating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.whiteColor),
                          ),
                        )
                      : const Icon(Icons.check, size: 18),
                  label: Text(
                    LocaleKeys.saveSettings.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeColor,
                    foregroundColor: AppColors.whiteColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const DeliveryInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.darkColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.whiteGreyColor,
            suffixText: 'SAR',
            suffixStyle: const TextStyle(
              color: AppColors.darkGreyColor,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardStroke),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardStroke),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.orangeColor, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Required';
            }
            final numVal = double.tryParse(value.trim());
            if (numVal == null || numVal < 0) {
              return 'Must be >= 0';
            }
            return null;
          },
        ),
      ],
    );
  }
}
