import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/presentation/pages/first_screen_communication_and_policies_pages/screens/communication_tabs.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/view_model/all_pages_about_cubit/all_pages_about_cubit.dart';

class CommunicationAndPoliciesPage extends StatefulWidget {
  const CommunicationAndPoliciesPage({super.key});

  @override
  State<CommunicationAndPoliciesPage> createState() =>
      _CommunicationAndPoliciesPageState();
}

class _CommunicationAndPoliciesPageState
    extends State<CommunicationAndPoliciesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllPagesAboutCubit()..getAllPagesAbout(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: SafeArea(
              child: RefreshIndicator(
                color: AppColors.orangeColor,
                onRefresh: () async {
                  await context.read<AllPagesAboutCubit>().getAllPagesAbout();
                },
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: const Padding(
                      padding: EdgeInsets.all(24),
                      child: CommunicationTabs(),
                    ),
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
