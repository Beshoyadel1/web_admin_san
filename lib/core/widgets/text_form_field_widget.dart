import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../helpers/colors/app_colors.dart';
import '../helpers/themes/fonts.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    required this.textFormController,
    this.textFormWidth,
    this.text,
    this.isValidator,
    this.validator,
    this.enabled,
    this.suffixOnPressed,
    this.suffixIcon,
    this.textWidth,
    this.textSize,
    this.onChanged,
    this.isDatePicker,
    this.onPressedDate,
    this.readOnly,
    this.isDigit,
    this.isDigitDot,
    this.onEditingComplete,
    this.textHeight,
    this.textFormHeight,
    this.fontWeightIndex,
    this.hintText,
    this.textAlign,
    this.contentPadding,
    this.prefixIcon,
    this.suffixIconSize,
    this.prefixIconSize,
    this.prefixOnPressed,
    this.fillColor,
    this.borderColor,
    this.textColor,
    this.contentTextColor,
    this.focusBorderColor,
    this.maxLength,
    this.selectionColor,
    this.focusNode,
    this.nextFocusNode,
    this.maxLines,
    this.inputFormatters,
    this.isColumn,
    this.hintTextColor,
    this.isSpaceAfterText,
    this.obscureText,
    this.enabledBorderRadius,
    this.focusedBorderRadius,
    this.hintTextSize,
    this.prefixIconWidth,
    this.prefixIconHeight,
    this.autovalidateMode,
    this.formFieldKey,
  });

  final GlobalKey<FormFieldState<String>>? formFieldKey;
  final TextEditingController textFormController;

  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

  final String? text;
  final bool? isValidator;
  final bool? enabled;
  final bool? isDigit;
  final bool? isDigitDot;
  final bool? readOnly;
  final void Function()? suffixOnPressed;
  final void Function()? prefixOnPressed;
  final void Function()? onPressedDate;
  final IconData? suffixIcon;
  final double? suffixIconSize;
  final String? prefixIcon;
  final double? prefixIconSize;
  final bool? isDatePicker;
  final double? textWidth;
  final double? textHeight;
  final double? textFormHeight;
  final double? textFormWidth;
  final double? textSize;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final int? fontWeightIndex;
  final String? hintText;
  final Color? hintTextColor;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? textColor;
  final Color? contentTextColor;
  final int? maxLength;
  final Color? selectionColor;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isColumn;
  final bool? isSpaceAfterText;
  final bool? obscureText;
  final BorderRadius? enabledBorderRadius;
  final BorderRadius? focusedBorderRadius;
  final double? hintTextSize;
  final double? prefixIconWidth;
  final double? prefixIconHeight;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  FocusNode? _internalFocusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant TextFormFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      _effectiveFocusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.greenColor,
          selectionColor: widget.selectionColor ??
              AppColors.defaultColor.withValues(alpha: 0.4),
        ),
      ),
      child: widget.isColumn == true
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.text != null) widgetText(),
                widgetTextFormField(),
              ],
            )
          : Row(
              children: [
                if (widget.text != null) widgetText(),
                Expanded(child: widgetTextFormField()),
              ],
            ),
    );
  }

  Widget widgetText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        (widget.text ?? '').tr(),
        style: TextStyle(
          fontSize: widget.textSize ?? 14,
          fontWeight:
              fontWeightSelection(fontWeightIndex: widget.fontWeightIndex),
          fontFamily: fontSelection(),
          color: widget.textColor ?? AppColors.darkColor,
        ),
      ),
    );
  }

  Widget widgetTextFormField() {
    final isMultiline = widget.maxLines != null && widget.maxLines! > 1;
    final double fieldHeight = widget.textFormHeight ?? 35;

    return FormField<String>(
      key: widget.formFieldKey,
      initialValue: widget.textFormController.text,
      autovalidateMode: widget.autovalidateMode,
      validator: (_) {
        final text = widget.textFormController.text;
        if (widget.validator != null) {
          return widget.validator!(text);
        }

        if (widget.isValidator == true) {
          if (text.trim().isEmpty) {
            return LocaleKeys.common_required_field.tr();
          }
        }

        return null;
      },
      builder: (formFieldState) {
        final hasError = formFieldState.hasError;
        final isFocused = _effectiveFocusNode.hasFocus;

        final Color borderColor = hasError
            ? AppColors.redColor
            : (isFocused
                ? (widget.focusBorderColor ??
                    widget.borderColor ??
                    AppColors.greenColor)
                : (widget.borderColor ?? AppColors.greyColor));

        return SizedBox(
          width: widget.textFormWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: isMultiline ? widget.textFormHeight : fieldHeight,
                width: widget.textFormWidth,
                decoration: BoxDecoration(
                  color: widget.fillColor ?? AppColors.greyColor,
                  borderRadius:
                      widget.enabledBorderRadius ?? BorderRadius.circular(10),
                  border: Border.all(
                    color: borderColor,
                    width: (hasError || isFocused) ? 1.5 : 1.0,
                  ),
                ),
                alignment: isMultiline ? Alignment.topLeft : Alignment.center,
                child: TextField(
                  controller: widget.textFormController,
                  focusNode: _effectiveFocusNode,
                  readOnly: widget.readOnly ?? false,
                  maxLines: widget.maxLines ?? 1,
                  obscureText: widget.obscureText ?? false,
                  enabled: widget.enabled ?? true,
                  maxLength: widget.maxLength,
                  textAlign: widget.textAlign ?? TextAlign.start,
                  inputFormatters: widget.inputFormatters ??
                      [
                        if (widget.isDigit == true)
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        else if (widget.isDigitDot == true)
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9]+\.?\d{0,4}')),
                      ],
                  onChanged: (val) {
                    formFieldState.didChange(val);
                    if (widget.onChanged != null) widget.onChanged!(val);
                  },
                  onEditingComplete: widget.onEditingComplete,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: fontWeightSelection(
                        fontWeightIndex: widget.fontWeightIndex),
                    fontFamily: fontSelection(),
                    color: widget.contentTextColor ?? AppColors.darkColor,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: widget.contentPadding ??
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                    hintText: widget.hintText?.tr(),
                    hintStyle: TextStyle(
                      fontSize: widget.hintTextSize ?? 14,
                      color: widget.hintTextColor ??
                          AppColors.darkColor.withValues(alpha: 0.6),
                    ),
                    suffixIcon: widget.suffixIcon != null
                        ? IconButton(
                            icon: Icon(
                              widget.suffixIcon,
                              size: widget.suffixIconSize ?? 18,
                              color: widget.contentTextColor ??
                                  AppColors.darkColor,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 35,
                              minHeight: 35,
                            ),
                            onPressed: widget.suffixOnPressed,
                          )
                        : null,
                  ),
                ),
              ),
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 8, left: 8),
                  child: Text(
                    formFieldState.errorText ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.redColor,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
