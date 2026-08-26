import 'package:flutter/material.dart';
import '../../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../../core/language/language.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';

class DurationTypeView extends StatelessWidget {
  final int? durationTypeId;
  final String? text;
  final double? width;

  const DurationTypeView({
    super.key,
    required this.durationTypeId,
    this.text,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final durationType = DurationType.all.where(
          (type) => type.id == durationTypeId,
    );

    final String durationName = durationType.isNotEmpty
        ? durationType.first.name
        : AppLanguageKeys.unknownType;

    final controller = TextEditingController(
      text: AppLocalizations.of(context).translate(durationName),
    );

    return UserTextFieldWidget(
      controller: controller,
      text: text ?? AppLanguageKeys.durationType,
      readOnly: true,
      width: width ?? 250,
    );
  }
}