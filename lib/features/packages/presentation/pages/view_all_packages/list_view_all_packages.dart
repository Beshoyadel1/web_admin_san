import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';

import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';

import 'package:web_admin_san/features/packages/presentation/bloc/packages_cubit/packages_cubit.dart';
import 'package:web_admin_san/features/packages/presentation/bloc/packages_cubit/packages_state.dart';

import 'package:web_admin_san/features/packages/presentation/custom_widget/widget_design_list_package.dart';

import 'package:web_admin_san/features/packages/presentation/pages/page_details_packages/page_details_packages.dart';

class ListViewAllPackages extends StatelessWidget {
  const ListViewAllPackages({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocBuilder<PackagesCubit, PackagesState>(
      builder: (
        context,
        state,
      ) {
        if (state is PackagesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is PackagesFailure) {
          return Center(
            child: Text(
              state.message,
            ),
          );
        }

        if (state is PackagesGetSuccess) {
          if (state.packages.isEmpty) {
            return const Center(
              child: TextEmptyViewData(),
            );
          }

          return CustomContainer(
            isSelected: false,
            onTap: () {},
            typeWidget: ListView.separated(
              itemCount: state.packages.length,
              separatorBuilder: (
                _,
                __,
              ) {
                return const SizedBox(
                  height: 20,
                );
              },
              itemBuilder: (
                context,
                index,
              ) {
                final package = state.packages[index];

                return WidgetDesignListPackage(
                  packageId: package.packageid?.toString(),
                  packageName: package.packagename,
                  packageLatinName: package.packagelatinname,
                  monthlyPrice: package.monthprice,
                  annualPrice: package.annualprice,
                  description: package.packagedisc,
                  latinDescription: package.packagelatindisc,
                  onTapDetails: () async {
                    final result = await Navigator.push(
                      context,
                      NavigateToPageWidget(
                        PageDetailsPackages(
                          packageID: package.packageid ?? 0,
                        ),
                      ),
                    );

                    if (result == true && context.mounted) {
                      await context.read<PackagesCubit>().getPackages();
                    }
                  },
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
