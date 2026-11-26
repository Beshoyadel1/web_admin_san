import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';

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
        : LocaleKeys.unknownType;

    final controller = TextEditingController(
      text: durationName.tr(),
    );

    return UserTextFieldWidget(
      controller: controller,
      text: text ?? LocaleKeys.durationType,
      readOnly: true,
      width: width ?? 250,
    );
  }
}
