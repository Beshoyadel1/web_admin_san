import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import '../../../../../core/helpers/colors/app_colors.dart';
import 'sign_up_sizes_widget/sign_up_web_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.scaffoldColor,
          ),
          child: const SignUpWebWidget(),
        ),
      ),
    );
  }
}
