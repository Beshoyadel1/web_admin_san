import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/features/warranty/presentation/bloc/warranty_cubit.dart';
import 'package:web_admin_san/features/warranty/presentation/pages/page_details_warranty/page_details_warranty.dart';
import 'package:web_admin_san/features/warranty/presentation/pages/view_all_warranty/list_view_all_warranty.dart';

class ViewAllWarranty extends StatelessWidget {
  const ViewAllWarranty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WarrantyCubit()..getApprovals(),

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
                        .read<WarrantyCubit>()
                        .getApprovals();
                  },

                  child: const ListViewAllWarranty(),
                ),
              ),
            ),

            // ============================================
            // CREATE WARRANTY
            // ============================================

            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.orangeColor,

              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  NavigateToPageWidget(
                    const PageDetailsWarranty(),
                  ),
                );


                if (result == true && context.mounted) {
                  await context
                      .read<WarrantyCubit>()
                      .getApprovals();
                }
              },

              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}