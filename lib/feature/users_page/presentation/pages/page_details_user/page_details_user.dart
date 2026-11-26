import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/users_page/view_model/user_details_cubit/user_details_cubit.dart';
import 'package:web_admin_san/feature/users_page/presentation/pages/page_details_user/screens/list_data_page_details_user.dart';

import '../../../../../../core/helpers/colors/app_colors.dart';

class PageDetailsUser extends StatelessWidget {
  final int userId;

  const PageDetailsUser({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserDetailsCubit()..getUserDetails(userId: userId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppBar(),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RefreshIndicator(
                  color: AppColors.orangeColor,
                  onRefresh: () async {
                    await context.read<UserDetailsCubit>().getUserDetails(
                          userId: userId,
                        );
                  },
                  child: const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: ListDataPageDetailsUser(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
