import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/country_selection_dialog.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class NationalityPickerField extends StatefulWidget {
  const NationalityPickerField({
    super.key,
    required this.controller,
    this.aboveText,
    this.readOnly = false,
    this.height = 35,
    this.width,
    this.borderColor = AppColors.darkGreyColor,
    this.fillColor = AppColors.whiteColor,
    this.onCountrySelected,
  });

  final TextEditingController controller;
  final String? aboveText;
  final bool readOnly;
  final double? height;
  final double? width;
  final Color? borderColor;
  final Color? fillColor;
  final ValueChanged<Country>? onCountrySelected;

  static Country? findCountry(String text, String lang) {
    if (text.trim().isEmpty) return null;
    final clean = text.trim().toLowerCase();
    for (final c in countries) {
      if (c.code.toLowerCase() == clean) return c;
      if (c.name.toLowerCase() == clean) return c;
      if (c.localizedName(lang).toLowerCase() == clean) return c;
      for (final val in c.nameTranslations.values) {
        if (val.toLowerCase() == clean) return c;
      }
    }
    return null;
  }

  @override
  State<NationalityPickerField> createState() => _NationalityPickerFieldState();
}

class _NationalityPickerFieldState extends State<NationalityPickerField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant NationalityPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _openPicker() async {
    if (widget.readOnly) return;

    final selected = await showDialog<Country>(
      context: context,
      useRootNavigator: true,
      builder: (_) => CountrySelectionDialog(
        title: LocaleKeys.selectNationality,
        showDialCode: false,
        initialCountryCode: widget.controller.text,
      ),
    );

    if (!mounted || selected == null) return;

    final lang = context.locale.languageCode;
    final name = selected.localizedName(lang);
    widget.controller.text = name;
    widget.onCountrySelected?.call(selected);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final country = NationalityPickerField.findCountry(
      widget.controller.text,
      lang,
    );

    final currentText = widget.controller.text.trim();
    final hasSelection = currentText.isNotEmpty;
    final displayName =
        country != null ? country.localizedName(lang) : currentText;

    final fieldHeight = widget.height ?? 35;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.aboveText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: TextInAppWidget(
              text: widget.aboveText!,
              textSize: 14,
              textColor: AppColors.darkColor,
              fontWeightIndex: FontSelectionData.regularFontFamily,
            ),
          ),
        MouseRegion(
          cursor: widget.readOnly
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _openPicker,
            child: Container(
              height: fieldHeight,
              width: widget.width,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: widget.fillColor ?? AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.borderColor ?? AppColors.darkGreyColor,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  if (country != null) ...[
                    Text(
                      country.flag,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      hasSelection
                          ? displayName
                          : LocaleKeys.selectNationality.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: hasSelection
                            ? AppColors.darkColor
                            : AppColors.darkColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.darkGreyColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
