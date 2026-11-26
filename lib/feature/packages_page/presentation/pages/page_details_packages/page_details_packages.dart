import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/error_state_view.dart';
import 'package:web_admin_san/core/widgets/show_delete_confirmation_dialog_in_app.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/page_details_packages/widgets/package_details_dashboard_view.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/page_details_packages/widgets/package_details_skeleton.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/edit_package_dialog.dart';
import 'package:web_admin_san/feature/packages_page/view_model/packages_cubit/packages_cubit.dart';
import 'package:web_admin_san/feature/packages_page/view_model/packages_cubit/packages_state.dart';

class PageDetailsPackages extends StatelessWidget {
  final int? packageID;

  const PageDetailsPackages({
    super.key,
    this.packageID,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = PackagesCubit();
        if (packageID != null && packageID! > 0) {
          cubit.getPackageById(packageId: packageID!);
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          surfaceTintColor: AppColors.transparent,
          elevation: 0.5,
          leading: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.darkColor,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ),
          title: TextInAppWidget(
            text: LocaleKeys.details.tr(),
            textSize: 18,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            textColor: AppColors.darkColor,
          ),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              return BlocConsumer<PackagesCubit, PackagesState>(
                listener: (context, state) {
                  if (state is PackagesDeleteSuccess) {
                    AppSnackBar.showSuccess(state.message);
                    Navigator.pop(context, true);
                  } else if (state is PackagesUpdateSuccess) {
                    AppSnackBar.showSuccess(LocaleKeys.success.tr());
                  } else if (state is PackagesFailure) {
                    AppSnackBar.showError(state.message);
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<PackagesCubit>();

                  if (state is PackagesLoading &&
                      cubit.selectedPackage == null) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: PackageDetailsSkeleton(),
                    );
                  }

                  if (state is PackagesFailure &&
                      cubit.selectedPackage == null) {
                    return ErrorStateView(
                      message: state.message,
                      onRetry: () {
                        if (packageID != null && packageID! > 0) {
                          cubit.getPackageById(packageId: packageID!);
                        }
                      },
                    );
                  }

                  final package = cubit.selectedPackage;

                  if (package == null) {
                    return const SizedBox();
                  }

                  return PackageDetailsDashboardView(
                    package: package,
                    onEdit: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: EditPackageDialog(
                            package: package,
                          ),
                        ),
                      );

                      if (result == true && context.mounted) {
                        if (packageID != null && packageID! > 0) {
                          await cubit.getPackageById(packageId: packageID!);
                        }
                      }
                    },
                    onDelete: () async {
                      final confirmed =
                          await showDeleteConfirmationDialogInApp(context);

                      if (confirmed != true) return;
                      if (!context.mounted) return;
                      if (package.packageid == null) return;

                      await cubit.deletePackage(
                        packageId: package.packageid!,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
