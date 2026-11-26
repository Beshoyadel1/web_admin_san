import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/admins_page/presentation/pages/page_details_admins/screens/admin_details_content.dart';
import 'package:web_admin_san/feature/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class PageDetailsAdmin extends StatelessWidget {
  final int adminId;

  const PageDetailsAdmin({
    super.key,
    required this.adminId,
  });

  static const int adminUserType = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: const TextInAppWidget(
          text: LocaleKeys.adminDetails,
          textSize: 15,
          textColor: AppColors.blackColor,
        ),
      ),
      body: BlocProvider(
        create: (_) => GetUserInfoCubit()
          ..getUserInfo(
            request: GetUserInfoRequest(
              userId: adminId,
              userType: adminUserType,
            ),
          ),
        child: AdminDetailsContent(
          adminId: adminId,
        ),
      ),
    );
  }
}
