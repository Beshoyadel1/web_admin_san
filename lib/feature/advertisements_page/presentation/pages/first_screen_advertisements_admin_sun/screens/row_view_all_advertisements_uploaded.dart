import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/advertisements_page/presentation/widgets/add_edit_banner_dialog.dart';
import 'package:web_admin_san/feature/advertisements_page/presentation/widgets/banner_card_widget.dart';
import 'package:web_admin_san/feature/advertisements_page/presentation/widgets/banners_empty_state_widget.dart';
import 'package:web_admin_san/feature/advertisements_page/view_model/banner_cubit/banner_cubit.dart';
import 'package:web_admin_san/feature/advertisements_page/view_model/banner_cubit/banner_state.dart';

class RowViewAllAdvertisementsUploaded extends StatelessWidget {
  const RowViewAllAdvertisementsUploaded({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.orangeColor),
              ),
            ),
          );
        }

        if (state is! BannerSuccess) {
          return const SizedBox();
        }

        final banners = state.banners;

        if (banners.isEmpty) {
          return BannersEmptyStateWidget(
            onAddBanner: () async {
              final result = await AddEditBannerDialog.show(context);
              if (result == true && context.mounted) {
                context.read<BannerCubit>().getBanner();
              }
            },
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: banners.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 520,
                mainAxisExtent: 320,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                final banner = banners[index];
                return BannerCardWidget(
                  banner: banner,
                  onEdit: () async {
                    final result = await AddEditBannerDialog.show(
                      context,
                      banner: banner,
                    );
                    if (result == true && context.mounted) {
                      context.read<BannerCubit>().getBanner();
                    }
                  },
                  onDelete: () {
                    context.read<BannerCubit>().deleteBanner(
                          id: banner.imageId!,
                        );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
