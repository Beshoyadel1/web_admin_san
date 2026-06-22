import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/get_all_providers_cubit/get_all_providers_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/pages/view_all_providers/screens/list_data_view_all_provider.dart';
import 'package:web_admin_san/features/rates/presentation/bloc/providers_rate_cubit/providers_rate_cubit.dart';
import 'package:web_admin_san/features/users/presentation/bloc/get_all_users_cubit/get_all_users_cubit.dart';
import 'package:web_admin_san/features/users/presentation/pages/page_details_user/screens/list_data_page_details_user.dart';
import 'package:web_admin_san/features/users/presentation/pages/view_all_users/screens/list_data_view_all_users.dart';
import '../../../../../../core/theming/colors.dart';

class PageDetailsUser extends StatelessWidget {
  final int userId;
  const PageDetailsUser({super.key,required this.userId});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: ListDataPageDetailsUser(userId:userId),
          ),
        ),
      ),
    );
  }
}
