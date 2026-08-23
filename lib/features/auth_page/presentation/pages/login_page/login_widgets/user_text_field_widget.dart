import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../core/theming/colors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


enum UserFieldType {
  normal,
  email,
  phone,
  name,
  password,
  gender,
  number,
}

class UserTextFieldWidget extends StatelessWidget {
  const UserTextFieldWidget({
    super.key,
    required this.controller,
    this.text,
    this.type = UserFieldType.normal,
    this.readOnly = false,
    this.width,
    this.height = 40,
    this.maxLines,
    this.borderColor,
    this.fillColor,
    this.focusedBorderColor,

    // ⭐ New
    this.digitOnly = false,
  });

  final TextEditingController controller;
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

  @override
  Widget build(BuildContext context) {
    final bool isMobile =
        MediaQuery.of(context).size.width < 600;

    final fieldHeight = height ?? 40;

    Widget child;

    switch (type) {
      case UserFieldType.phone:
        if (readOnly) {
          child = TextFormFieldWidget(
            textFormController: controller,
            text: text ?? "",
            isColumn: true,
            readOnly: true,
            textSize: 16,
            borderColor:
            borderColor ?? AppColors.darkGreyColor,
            fillColor:
            fillColor ?? AppColors.whiteColor,
            textFormHeight: fieldHeight,
            maxLines: 1,
            isDigit: true,
          );
        } else {
          child = PhoneTextField(
            controller: controller,
            aboveText: text,
            height: fieldHeight,
            borderColor:
            borderColor ?? AppColors.darkGreyColor,
            fillColor:
            fillColor ?? AppColors.whiteColor,
            focusedBorderColor:
            focusedBorderColor ??
                borderColor ??
                AppColors.darkGreyColor,
          );
        }
        break;

    // =========================================================
    // GENDER
    // =========================================================
      case UserFieldType.gender:
        child = GenderField(
          controller: controller,
          text: text,
          readOnly: readOnly,
          borderColor:
          borderColor ?? AppColors.darkGreyColor,
          fillColor:
          fillColor ?? AppColors.whiteColor,
        );
        break;

    // =========================================================
    // PASSWORD
    // =========================================================
      case UserFieldType.password:
        child = TextFormFieldWidget(
          textFormController: controller,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 16,
          borderColor:
          borderColor ?? AppColors.darkGreyColor,
          fillColor:
          fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: 1,
          isDigit: false,
          obscureText: true,
        );
        break;

    // =========================================================
    // NUMBER
    // =========================================================
      case UserFieldType.number:
        child = TextFormFieldWidget(
          textFormController: controller,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 16,
          borderColor:
          borderColor ?? AppColors.darkGreyColor,
          fillColor:
          fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: 1,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          isDigit: true,
        );
        break;

    // =========================================================
    // EMAIL
    // =========================================================
      case UserFieldType.email:
        child = TextFormFieldWidget(
          textFormController: controller,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 16,
          borderColor:
          borderColor ?? AppColors.darkGreyColor,
          fillColor:
          fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: 1,
          isDigit: false,
        );
        break;

    // =========================================================
    // NAME
    // =========================================================
      case UserFieldType.name:
        child = TextFormFieldWidget(
          textFormController: controller,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 16,
          borderColor:
          borderColor ?? AppColors.darkGreyColor,
          fillColor:
          fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: 1,
          isDigit: false,
        );
        break;

    // =========================================================
    // NORMAL
    // =========================================================
      case UserFieldType.normal:
        child = TextFormFieldWidget(
          textFormController: controller,
          text: text ?? "",
          isColumn: true,
          readOnly: readOnly,
          textSize: 16,
          borderColor:
          borderColor ?? AppColors.darkGreyColor,
          fillColor:
          fillColor ?? AppColors.whiteColor,
          textFormHeight: fieldHeight,
          maxLines: maxLines ?? 1,
          inputFormatters: digitOnly
              ? [
            FilteringTextInputFormatter.digitsOnly,
          ]
              : null,
          isDigit: digitOnly,
        );
        break;
    }

    return SizedBox(
      width: isMobile
          ? double.infinity
          : (width ?? 500),
      child: child,
    );
  }
}

class GenderField extends StatefulWidget {
  final TextEditingController controller;
  final String? text;
  final bool readOnly;

  final Color borderColor;
  final Color fillColor;

  const GenderField({
    super.key,
    required this.controller,
    this.text,
    required this.readOnly,
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
    if (widget.controller.text == "0") {
      selectedValue = "0";
    } else if (widget.controller.text == "1") {
      selectedValue = "1";
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
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
              hint: const TextInAppWidget(
                text: AppLanguageKeys.selectGender,
                textSize: 14,
              ),
              items: const [
                DropdownMenuItem(
                  value: "0",
                  child: TextInAppWidget(
                    text: AppLanguageKeys.male,
                    textSize: 14,
                  ),
                ),
                DropdownMenuItem(
                  value: "1",
                  child: TextInAppWidget(
                    text: AppLanguageKeys.female,
                    textSize: 14,
                  ),
                ),
              ],
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


class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    required this.controller,
    this.aboveText,
    this.isReadOnly = false,
    this.height,
    // NEW
    this.borderColor = AppColors.darkGreyColor,
    this.fillColor = AppColors.whiteColor,
    this.focusedBorderColor = AppColors.darkGreyColor,
  });

  final TextEditingController controller;
  final String? aboveText;
  final bool isReadOnly;
  final double? height;

  final Color borderColor;
  final Color fillColor;
  final Color focusedBorderColor;

  @override
  Widget build(BuildContext context) {
    // الرقم الموجود بالفعل في controller
    final String phoneValue = controller.text.trim();

    // IntlPhoneField يحتاج + في initialValue
    final String? initialPhone = phoneValue.isEmpty
        ? null
        : phoneValue.startsWith('+')
        ? phoneValue
        : '+$phoneValue';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (aboveText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: TextInAppWidget(
              text: aboveText!,
              textSize: 14,
            ),
          ),

        SizedBox(
          height: (height!+20),
          child: IntlPhoneField(
            initialValue: initialPhone,

            initialCountryCode: 'SA',
            disableLengthCheck: false,
            readOnly: isReadOnly,
            keyboardType: TextInputType.number,

            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],

            style: const TextStyle(fontSize: 14, height: 1.2),
            dropdownTextStyle: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,

              isDense: true,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: focusedBorderColor,
                  width: 1.5,
                ),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor,
                ),
              ),
            ),

            flagsButtonPadding: const EdgeInsets.only(left: 6, right: 4),
            dropdownIconPosition: IconPosition.trailing,
            dropdownIcon: const Icon(Icons.arrow_drop_down, size: 18),

            onChanged: isReadOnly
                ? null
                : (phone) {
              controller.text =
                  phone.completeNumber.replaceFirst("+", "");
            },
          ),
        ),
      ],
    );
  }
}