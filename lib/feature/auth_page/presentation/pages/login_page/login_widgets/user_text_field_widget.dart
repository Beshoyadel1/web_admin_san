import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/gender_constants.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/helpers/validators/app_validators.dart';
import 'package:web_admin_san/core/widgets/country_selection_dialog.dart';
import 'package:web_admin_san/core/widgets/nationality_picker_field.dart';
import 'package:web_admin_san/core/widgets/text_form_field_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

enum UserFieldType {
  normal,
  email,
  phone,
  name,
  password,
  confirmPassword,
  gender,
  nationality,
  number,
  birthDate,
}

class UserTextFieldWidget extends StatelessWidget {
  const UserTextFieldWidget({
    super.key,
    this.controller,
    this.initialValue,
    this.text,
    this.type = UserFieldType.normal,
    this.readOnly = false,
    this.width,
    this.height = 35,
    this.maxLines,
    this.borderColor,
    this.fillColor,
    this.focusedBorderColor,
    this.digitOnly = false,
    this.validator,
    this.passwordToMatch,
    this.passwordControllerToMatch,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.isOptional = false,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? text;
  final UserFieldType type;
  final bool readOnly;

  final double? width;
  final double? height;
  final int? maxLines;

  final Color? borderColor;
  final Color? fillColor;
  final Color? focusedBorderColor;

  final bool digitOnly;

  final FormFieldValidator<String>? validator;
  final String? passwordToMatch;
  final TextEditingController? passwordControllerToMatch;
  final AutovalidateMode autovalidateMode;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final fieldHeight = height ?? 35;

    // Fast-path for read-only fields: zero TextEditingController overhead
    if (readOnly && (controller == null || initialValue != null)) {
      final value = initialValue ?? controller?.text ?? '';
      return ReadOnlyDisplayField(
        label: text,
        value: value,
        height: fieldHeight,
        width: isMobile ? double.infinity : (width ?? 500),
        borderColor: borderColor ?? AppColors.lightGreyColor,
        fillColor: fillColor ?? AppColors.whiteColor,
      );
    }

    final effectiveController =
        controller ?? TextEditingController(text: initialValue ?? '');

    Widget child;

    switch (type) {
      case UserFieldType.phone:
        child = PhoneTextField(
          controller: effectiveController,
          aboveText: text,
          isReadOnly: readOnly,
          height: fieldHeight,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          focusedBorderColor:
              focusedBorderColor ?? borderColor ?? AppColors.darkGreyColor,
          autovalidateMode: autovalidateMode,
          validator: validator,
          isOptional: isOptional,
        );
        break;

      case UserFieldType.gender:
        child = GenderField(
          controller: effectiveController,
          text: text,
          readOnly: readOnly,
          height: fieldHeight,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
        );
        break;

      case UserFieldType.birthDate:
        child = BirthDateField(
          controller: effectiveController,
          text: text,
          readOnly: readOnly,
          height: fieldHeight,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
        );
        break;

      case UserFieldType.nationality:
        child = NationalityPickerField(
          controller: effectiveController,
          aboveText: text,
          readOnly: readOnly,
          height: fieldHeight,
          width: isMobile ? double.infinity : (width ?? 500),
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
        );
        break;

      // =========================================================
      // PASSWORD
      // =========================================================
      case UserFieldType.password:
        child = _PasswordTextField(
          controller: effectiveController,
          text: text ?? "",
          readOnly: readOnly,
          height: fieldHeight,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          autovalidateMode: autovalidateMode,
          validator: validator ??
              (isOptional ? null : AppValidators.passwordValidator),
        );
        break;

      // =========================================================
      // CONFIRM PASSWORD
      // =========================================================
      case UserFieldType.confirmPassword:
        child = _PasswordTextField(
          controller: effectiveController,
          text: text ?? "",
          readOnly: readOnly,
          height: fieldHeight,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          autovalidateMode: autovalidateMode,
          passwordControllerToMatch: passwordControllerToMatch,
          passwordToMatch: passwordToMatch,
          validator: validator ??
              (isOptional
                  ? null
                  : (val) {
                      final match = passwordControllerToMatch != null
                          ? passwordControllerToMatch!.text
                          : passwordToMatch;
                      return AppValidators.confirmPasswordValidator(
                        val,
                        match,
                      );
                    }),
        );
        break;

      // =========================================================
      // NUMBER
      // =========================================================
      case UserFieldType.number:
        child = TextFormFieldWidget(
          textFormController: effectiveController,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 14,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: 1,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          isDigit: true,
          autovalidateMode: autovalidateMode,
          validator: validator,
        );
        break;

      // =========================================================
      // EMAIL
      // =========================================================
      case UserFieldType.email:
        child = TextFormFieldWidget(
          textFormController: effectiveController,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 14,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: 1,
          isDigit: false,
          autovalidateMode: autovalidateMode,
          validator:
              validator ?? (isOptional ? null : AppValidators.emailValidator),
        );
        break;

      // =========================================================
      // NAME
      // =========================================================
      case UserFieldType.name:
        child = TextFormFieldWidget(
          textFormController: effectiveController,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 14,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: 1,
          isDigit: false,
          autovalidateMode: autovalidateMode,
          validator: validator,
        );
        break;

      // =========================================================
      // NORMAL
      // =========================================================
      case UserFieldType.normal:
        child = TextFormFieldWidget(
          textFormController: effectiveController,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 14,
          borderColor: borderColor ?? AppColors.darkGreyColor,
          fillColor: fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: maxLines ?? 1,
          inputFormatters: digitOnly
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : null,
          isDigit: digitOnly,
          autovalidateMode: autovalidateMode,
          validator: validator,
        );
        break;
    }

    return SizedBox(
      width: isMobile ? double.infinity : (width ?? 500),
      child: child,
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    required this.controller,
    required this.text,
    required this.readOnly,
    required this.height,
    required this.borderColor,
    required this.fillColor,
    this.validator,
    this.autovalidateMode,
    this.passwordControllerToMatch,
    this.passwordToMatch,
  });

  final TextEditingController controller;
  final String text;
  final bool readOnly;
  final double height;
  final Color borderColor;
  final Color fillColor;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? passwordControllerToMatch;
  final String? passwordToMatch;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool _obscureText = true;
  final GlobalKey<FormFieldState<String>> _formFieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    widget.passwordControllerToMatch?.addListener(_onMatchedPasswordChanged);
  }

  @override
  void didUpdateWidget(covariant _PasswordTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.passwordControllerToMatch !=
        widget.passwordControllerToMatch) {
      oldWidget.passwordControllerToMatch
          ?.removeListener(_onMatchedPasswordChanged);
      widget.passwordControllerToMatch?.addListener(_onMatchedPasswordChanged);
    }
  }

  @override
  void dispose() {
    widget.passwordControllerToMatch?.removeListener(_onMatchedPasswordChanged);
    super.dispose();
  }

  void _onMatchedPasswordChanged() {
    if (widget.controller.text.isNotEmpty) {
      _formFieldKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      formFieldKey: _formFieldKey,
      textFormController: widget.controller,
      text: widget.text,
      isColumn: true,
      readOnly: widget.readOnly,
      textSize: 14,
      borderColor: widget.borderColor,
      fillColor: widget.fillColor,
      textFormHeight: widget.height,
      maxLines: 1,
      isDigit: false,
      obscureText: _obscureText,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      suffixIcon: _obscureText
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
      suffixOnPressed: widget.readOnly
          ? null
          : () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
    );
  }
}

class GenderField extends StatefulWidget {
  final TextEditingController controller;
  final String? text;
  final bool readOnly;
  final double? height;

  final Color borderColor;
  final Color fillColor;

  const GenderField({
    super.key,
    required this.controller,
    this.text,
    required this.readOnly,
    this.height,
    this.borderColor = AppColors.darkGreyColor,
    this.fillColor = AppColors.whiteColor,
  });

  @override
  State<GenderField> createState() => _GenderFieldState();
}

class _GenderFieldState extends State<GenderField> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    _setValue();
  }

  @override
  void didUpdateWidget(covariant GenderField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setValue();
  }

  void _setValue() {
    final text = widget.controller.text.trim();
    if (GenderConstants.isValidGender(text)) {
      selectedValue = text;
    } else {
      selectedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.text != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: TextInAppWidget(
              text: widget.text!,
              textSize: 14,
            ),
          ),
        Container(
          height: widget.height ?? 35,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.fillColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.borderColor,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: AppColors.darkGreyColor,
              ),
              hint: const TextInAppWidget(
                text: LocaleKeys.selectGender,
                textSize: 14,
                textColor: AppColors.darkGreyColor,
              ),
              items: GenderConstants.dropdownItems,
              onChanged: widget.readOnly
                  ? null
                  : (value) {
                      setState(() {
                        selectedValue = value;
                        widget.controller.text = value ?? "";
                      });
                    },
            ),
          ),
        )
      ],
    );
  }
}

Map<String, String> parsePhoneNumber(String phone) {
  if (phone.isEmpty) return {'countryCode': 'SA', 'number': ''};

  String normalized = phone.trim();
  if (!normalized.startsWith('+')) {
    normalized = '+$normalized';
  }

  for (final country in countries) {
    final dialCode = '+${country.dialCode}';
    if (normalized.startsWith(dialCode)) {
      final number = normalized.substring(dialCode.length).trim();
      return {'countryCode': country.code, 'number': number};
    }
  }

  return {'countryCode': 'SA', 'number': normalized.replaceAll('+', '')};
}

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    super.key,
    required this.controller,
    this.aboveText,
    this.isReadOnly = false,
    this.height,
    this.borderColor = AppColors.darkGreyColor,
    this.fillColor = AppColors.whiteColor,
    this.focusedBorderColor = AppColors.darkGreyColor,
    this.borderRadius,
    this.onChanged,
    this.initialCountry = 'SA',
    this.initialNumber,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.isOptional = false,
  });

  final TextEditingController controller;
  final String? aboveText;
  final bool isReadOnly;
  final double? height;
  final Color borderColor;
  final Color fillColor;
  final Color focusedBorderColor;
  final double? borderRadius;
  final String? initialCountry;
  final String? initialNumber;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;
  final bool isOptional;
  final void Function(PhoneNumber)? onChanged;

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late Country _selectedCountry;
  late TextEditingController _numberController;
  final FocusNode _focusNode = FocusNode();
  bool _isInternalUpdating = false;

  @override
  void initState() {
    super.initState();
    _initValues();
    widget.controller.addListener(_onExternalControllerChanged);
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant PhoneTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onExternalControllerChanged);
      widget.controller.addListener(_onExternalControllerChanged);
      _initValues();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onExternalControllerChanged);
    _numberController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _initValues() {
    final parsed = parsePhoneNumber(widget.controller.text);
    final countryCode =
        (widget.initialCountry != null && widget.initialCountry!.isNotEmpty)
            ? widget.initialCountry!
            : (parsed['countryCode'] ?? 'SA');
    final number = widget.initialNumber ?? parsed['number'] ?? '';

    _selectedCountry = countries.firstWhere(
      (c) => c.code.toUpperCase() == countryCode.toUpperCase(),
      orElse: () => countries.firstWhere((c) => c.code == 'SA'),
    );

    _numberController = TextEditingController(text: number);
  }

  void _onExternalControllerChanged() {
    if (_isInternalUpdating) return;
    final parsed = parsePhoneNumber(widget.controller.text);
    final countryCode = parsed['countryCode'] ?? 'SA';
    final number = parsed['number'] ?? '';

    final newCountry = countries.firstWhere(
      (c) => c.code.toUpperCase() == countryCode.toUpperCase(),
      orElse: () => _selectedCountry,
    );

    if (newCountry.code != _selectedCountry.code ||
        _numberController.text != number) {
      setState(() {
        _selectedCountry = newCountry;
        _numberController.text = number;
      });
    }
  }

  void _syncToController(FormFieldState<String> state) {
    _isInternalUpdating = true;
    final num = _numberController.text.trim();
    if (num.isEmpty) {
      widget.controller.text = '';
    } else {
      widget.controller.text = '${_selectedCountry.dialCode}$num';
    }
    _isInternalUpdating = false;
    state.didChange(widget.controller.text);

    if (widget.onChanged != null) {
      widget.onChanged!(
        PhoneNumber(
          countryISOCode: _selectedCountry.code,
          countryCode: '+${_selectedCountry.dialCode}',
          number: num,
        ),
      );
    }
  }

  Future<void> _openCountryPicker(FormFieldState<String> state) async {
    final selected = await showDialog<Country>(
      context: context,
      useRootNavigator: true,
      builder: (_) => CountrySelectionDialog(
        initialCountryCode: _selectedCountry.code,
      ),
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedCountry = selected;
        _syncToController(state);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fieldHeight = widget.height ?? 35;

    return FormField<String>(
      autovalidateMode: widget.autovalidateMode,
      initialValue: widget.controller.text,
      validator: (_) {
        final num = _numberController.text.trim();
        if (!widget.isOptional && num.isEmpty) {
          return LocaleKeys.authPhoneNumberRequired.tr();
        }
        if (num.isNotEmpty) {
          if (num.length < _selectedCountry.minLength ||
              num.length > _selectedCountry.maxLength) {
            return LocaleKeys.authEnterCorrectPhoneNumber.tr();
          }
        }
        if (widget.validator != null) {
          return widget.validator!(widget.controller.text);
        }
        return null;
      },
      builder: (state) {
        final hasError = state.hasError;
        final isFocused = _focusNode.hasFocus;

        final borderC = hasError
            ? AppColors.redColor
            : (isFocused ? widget.focusedBorderColor : widget.borderColor);

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
                ),
              ),
            Container(
              height: fieldHeight,
              decoration: BoxDecoration(
                color: widget.fillColor,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                border: Border.all(
                  color: borderC,
                  width: hasError ? 1.5 : 1,
                ),
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    MouseRegion(
                      cursor: widget.isReadOnly
                          ? SystemMouseCursors.basic
                          : SystemMouseCursors.click,
                      child: InkWell(
                        onTap: widget.isReadOnly
                            ? null
                            : () => _openCountryPicker(state),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(widget.borderRadius ?? 10),
                          bottomLeft:
                              Radius.circular(widget.borderRadius ?? 10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedCountry.flag,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '+${_selectedCountry.dialCode}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                ),
                              ),
                              if (!widget.isReadOnly) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  size: 18,
                                  color: AppColors.darkGreyColor,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: fieldHeight * 0.6,
                      width: 1,
                      color: widget.borderColor,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _numberController,
                        focusNode: _focusNode,
                        readOnly: widget.isReadOnly,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.blackColor,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          isDense: true,
                        ),
                        onChanged: (_) => _syncToController(state),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasError && state.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1,
                    color: AppColors.redColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class BirthDateField extends StatelessWidget {
  final TextEditingController controller;
  final String? text;
  final bool readOnly;
  final double? height;
  final Color borderColor;
  final Color fillColor;

  const BirthDateField({
    super.key,
    required this.controller,
    this.text,
    required this.readOnly,
    this.height,
    this.borderColor = AppColors.darkGreyColor,
    this.fillColor = AppColors.whiteColor,
  });

  Future<void> _pickDate(BuildContext context) async {
    if (readOnly) return;
    DateTime initial =
        DateTime.tryParse(controller.text.trim()) ?? DateTime(2000, 1, 1);
    if (initial.isAfter(DateTime.now())) {
      initial = DateTime.now();
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: TextInAppWidget(
              text: text!,
              textSize: 14,
            ),
          ),
        InkWell(
          onTap: readOnly ? null : () => _pickDate(context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: height ?? 35,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextInAppWidget(
                    text: controller.text.isNotEmpty
                        ? controller.text
                        : (readOnly ? '' : LocaleKeys.birthDate),
                    textSize: 14,
                    textColor: controller.text.isNotEmpty
                        ? AppColors.blackColor
                        : AppColors.darkGreyColor,
                  ),
                ),
                if (!readOnly)
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: AppColors.darkGreyColor,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ReadOnlyDisplayField extends StatelessWidget {
  final String? label;
  final String value;
  final double height;
  final double? width;
  final Color borderColor;
  final Color fillColor;
  final Color textColor;

  const ReadOnlyDisplayField({
    super.key,
    this.label,
    required this.value,
    this.height = 35,
    this.width,
    this.borderColor = AppColors.lightGreyColor,
    this.fillColor = AppColors.whiteColor,
    this.textColor = AppColors.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                label!.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkColor,
                ),
              ),
            ),
          Container(
            height: height,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: AlignmentDirectional.centerStart,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
