import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import '../../../../../../features/banner/presentation/bloc/banner_cubit/banner_cubit.dart';
import '../../../../../../features/banner/presentation/bloc/banner_cubit/banner_state.dart';
import '../../../../../../features/banner/presentation/custom_widget/design_container_advertisements_uploaded_widget.dart';
import '../../../../../../features/banner/presentation/pages/add_advertisements_admin_sun/add_advertisements_admin_sun.dart';
import '../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RowViewAllAdvertisementsUploaded extends StatelessWidget {
  const RowViewAllAdvertisementsUploaded({super.key});

  Widget _buildBannerCard(
      BuildContext context,
      banner,
      ) {
    return DesignContainerAdvertisementsUploadedWidget(
      loadImage: banner.image,
      startDate: banner.startDate,
      endDate: banner.endDate,
      onPressedDelete: () {
        showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const TextInAppWidget(
                text: AppLanguageKeys.delete,
                textSize: 18,
                textColor: AppColors.redColor,
              ),
              content: const TextInAppWidget(
                text: AppLanguageKeys.confirmDelete,
                textSize: 14,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const TextInAppWidget(
                    text: AppLanguageKeys.cancel,
                    textSize: 14,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redColor,
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    context.read<BannerCubit>().deleteBanner(
                      id: banner.imageId!,
                    );
                  },
                  child: const TextInAppWidget(
                    text: AppLanguageKeys.delete,
                    textSize: 14,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ],
            );
          },
        );
      },
      onPressedEdit: () async {
        final result = await Navigator.of(context).push(
          NavigateToPageWidget(
            AddAdvertisementsAdminSun(
              banner: banner,
            ),
          ),
        );

        if (result == true && context.mounted) {
          context.read<BannerCubit>().getBanner();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is! BannerSuccess) {
          return const SizedBox();
        }

        if (state.banners.isEmpty) {
          return const TextEmptyViewData();
        }

        final banners = state.banners;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 900;

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isMobile
                  ? banners.length
                  : (banners.length / 2).ceil(),
              separatorBuilder: (_, __) =>
              const SizedBox(height: 10),
              itemBuilder: (context, rowIndex) {
                if (isMobile) {
                  return _buildBannerCard(
                    context,
                    banners[rowIndex],
                  );
                }

                final firstIndex = rowIndex * 2;
                final secondIndex = firstIndex + 1;

                return Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildBannerCard(
                        context,
                        banners[firstIndex],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: secondIndex < banners.length
                          ? _buildBannerCard(
                        context,
                        banners[secondIndex],
                      )
                          : const SizedBox(),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}