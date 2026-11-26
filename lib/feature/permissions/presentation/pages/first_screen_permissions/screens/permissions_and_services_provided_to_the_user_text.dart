import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

class PermissionsAndServicesProvidedToTheUserText extends StatelessWidget {
  const PermissionsAndServicesProvidedToTheUserText({super.key});

  @override
  Widget build(BuildContext context) {
    return TextInAppWidget(
      text: LocaleKeys.permissionsFromServices,
      textSize: 16,
      fontWeightIndex: FontSelectionData.mediumFontFamily,
      textColor: AppColors.blackColor,
    );
  }
}
