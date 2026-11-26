import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/permissions/presentation/widgets/check_box_with_text_widget.dart';

class WebAsPartUserSelectPermissions extends StatelessWidget {
  const WebAsPartUserSelectPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CheckBoxWithText(text: LocaleKeys.statistics),
        CheckBoxWithText(text: LocaleKeys.servicesSettings),
        CheckBoxWithText(text: LocaleKeys.carModelSettings),
        CheckBoxWithText(text: LocaleKeys.accountManagement),
        CheckBoxWithText(text: LocaleKeys.permissionsManagement),
        CheckBoxWithText(text: LocaleKeys.organizationManagement),
      ],
    );
  }
}
