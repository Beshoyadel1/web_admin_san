import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/feature/permissions/presentation/pages/first_screen_permissions/screens/mobile_as_part_user_select_permissions.dart';
import 'package:web_admin_san/feature/permissions/presentation/pages/first_screen_permissions/screens/web_as_part_user_select_permissions.dart';

class PartUserSelectPermissions extends StatelessWidget {
  const PartUserSelectPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth + 200;
    return isMobile
        ? MobileAsPartUserSelectPermissions()
        : WebAsPartUserSelectPermissions();
  }
}
