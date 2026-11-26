import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/permissions/presentation/widgets/text_with_container_as_column_widget.dart';
import 'package:web_admin_san/feature/permissions/presentation/widgets/text_with_text_form_field_as_column_widget.dart';

class WebOfDataContainerInListDataFirstScreenPermissions
    extends StatelessWidget {
  const WebOfDataContainerInListDataFirstScreenPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 5,
          children: [
            TextWithTextFormFieldAsColumnWidget(
              text: LocaleKeys.employeeName,
              hint: LocaleKeys.employeeName,
            ),
            TextWithTextFormFieldAsColumnWidget(
              text: LocaleKeys.jobTitle,
              hint: LocaleKeys.jobTitle,
            ),
            TextWithTextFormFieldAsColumnWidget(
              text: LocaleKeys.accountStatus,
              hint: LocaleKeys.accountStatus,
              options: [LocaleKeys.active, LocaleKeys.inactive],
            ),
          ],
        ),
        Row(
          spacing: 5,
          children: [
            TextWithTextFormFieldAsColumnWidget(
              text: LocaleKeys.Email,
              hint: LocaleKeys.Email,
            ),
            TextWithTextFormFieldAsColumnWidget(
              text: LocaleKeys.phoneNumber,
              hint: LocaleKeys.phoneNumber,
            ),
            TextWithContainerAsColumnWidget(
              title: LocaleKeys.picture,
              textContainer: LocaleKeys.uploadPicture,
            )
          ],
        ),
      ],
    );
  }
}
