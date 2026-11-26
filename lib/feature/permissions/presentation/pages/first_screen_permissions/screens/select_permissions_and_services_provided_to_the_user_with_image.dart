import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/permissions/presentation/widgets/check_box_with_text_widget.dart';

class SelectPermissionsAndServicesProvidedToTheUserWithImage
    extends StatelessWidget {
  const SelectPermissionsAndServicesProvidedToTheUserWithImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CheckBoxWithText(
              text: LocaleKeys.maintenanceServices,
              imageSelect: AppImageKeys.service33,
            ),
            CheckBoxWithText(
              text: LocaleKeys.maintenanceServices,
              imageSelect: AppImageKeys.service44,
            )
          ],
        )
      ],
    );
  }
}
