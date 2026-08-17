import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/admins/presentation/bloc/admins_cubit/admins_cubit.dart';
import 'package:web_admin_san/features/admins/presentation/pages/page_details_admins/screens/admin_details_content.dart';
import 'package:web_admin_san/features/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/features/auth_page/presentation/bloc/get_user_info_cubit/get_user_info_cubit.dart';

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
        title: const TextInAppWidget(
          text: AppLanguageKeys.adminDetails,
          textSize: 15,
          textColor: AppColors.blackColor,
        ),
      ),

      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => GetUserInfoCubit()
              ..getUserInfo(
                request: GetUserInfoRequest(
                  userId: adminId,
                  userType: adminUserType,
                ),
              ),
          ),

          BlocProvider(
            create: (_) => AdminsCubit(),
          ),
        ],

        child: const AdminDetailsContent(),
      ),
    );
  }
}