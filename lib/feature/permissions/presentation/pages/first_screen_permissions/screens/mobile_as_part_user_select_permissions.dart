import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/feature/permissions/presentation/widgets/check_box_with_text_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
class MobileAsPartUserSelectPermissions extends StatelessWidget {
  const MobileAsPartUserSelectPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Row(
          children: [
            CheckBoxWithText(text: LocaleKeys.statistics),
            CheckBoxWithText(text: LocaleKeys.servicesSettings),
          ],
        ),
        Row(
          children: [
            CheckBoxWithText(text: LocaleKeys.carModelSettings),
            CheckBoxWithText(text: LocaleKeys.accountManagement),
          ],
        ),
        Row(
          children: [
            CheckBoxWithText(text: LocaleKeys.permissionsManagement),
            CheckBoxWithText(text: LocaleKeys.organizationManagement),
          ],
        )
      ],
    );
  }
}
