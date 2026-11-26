import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/permissions/presentation/widgets/text_with_container_as_column_widget.dart';
import 'package:web_admin_san/feature/permissions/presentation/widgets/text_with_text_form_field_as_column_widget.dart';

class MobileOfDataContainerInListDataFirstScreenPermissions
    extends StatelessWidget {
  const MobileOfDataContainerInListDataFirstScreenPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //row_
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
          ],
        ),
        Row(
          children: [
            TextWithTextFormFieldAsColumnWidget(
              text: LocaleKeys.accountStatus,
              hint: LocaleKeys.accountStatus,
              options: [LocaleKeys.active, LocaleKeys.inactive],
            ),
          ],
        ),
        Row(
          children: [
            TextWithTextFormFieldAsColumnWidget(
              text: LocaleKeys.Email,
              hint: LocaleKeys.Email,
            ),
          ],
        ),
        Row(
          children: [
            TextWithTextFormFieldAsColumnWidget(
              text: LocaleKeys.phoneNumber,
              hint: LocaleKeys.phoneNumber,
            ),
          ],
        ),
        Row(
          children: [
            TextWithContainerAsColumnWidget(
              title: LocaleKeys.picture,
              textContainer: LocaleKeys.uploadPicture,
            ),
          ],
        )
      ],
    );
  }
}
