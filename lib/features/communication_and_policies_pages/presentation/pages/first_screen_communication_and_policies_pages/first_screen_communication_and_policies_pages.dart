import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/presentation/cubit/all_pages_about_cubit/all_pages_about_cubit.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/presentation/pages/first_screen_communication_and_policies_pages/screens/communication_tabs.dart';
import '../../../../../../core/theming/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstScreenCommunicationAndPoliciesPages extends StatelessWidget {
  const FirstScreenCommunicationAndPoliciesPages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllPagesAboutCubit()..getAllPagesAbout(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RefreshIndicator(
                  color: AppColors.orangeColor,
                  onRefresh: () async {
                    await context
                        .read<AllPagesAboutCubit>()
                        .getAllPagesAbout();
                  },
                  child: const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: CommunicationTabs(),
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