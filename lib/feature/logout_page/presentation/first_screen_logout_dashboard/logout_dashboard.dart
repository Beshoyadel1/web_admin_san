import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/logout_page/presentation/first_screen_logout_dashboard/screens/first_part_in_logout_dashboard.dart';
import 'package:web_admin_san/feature/logout_page/presentation/first_screen_logout_dashboard/screens/last_two_button_in_logout_dashboard.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: 400,
          height: 300,
          decoration: BoxDecoration(
            color: AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 10,
            children: [
              const FirstPartInLogoutPage(),
              LastTwoButtonInLogoutPage(
                onTapConfirm: () async {
                  await context.read<AuthCubit>().logout(context);
                },
                onTapCancel: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
