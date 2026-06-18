import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is BannerSuccess) {
          if (state.banners.isEmpty) {
            return const TextEmptyViewData();
          }
          final banners = state.banners;
          return LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 900;

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    isMobile ? banners.length : (banners.length / 2).ceil(),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, rowIndex) {
                  if (isMobile) {
                    return DesignContainerAdvertisementsUploadedWidget(
                      loadImage: banners[rowIndex].image,
                      onPressedDelete: () {
                        context.read<BannerCubit>().deleteBanner(
                              id: banners[rowIndex].imageId!,
                            );
                      },
                      onPressedEdit: () async {
                        final banner = banners[rowIndex];

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

                  final firstIndex = rowIndex * 2;
                  final secondIndex = firstIndex + 1;

                  return Row(
                    children: [
                      Expanded(
                        child: DesignContainerAdvertisementsUploadedWidget(
                          loadImage: banners[firstIndex].image,
                          onPressedDelete: () {
                            context.read<BannerCubit>().deleteBanner(
                                  id: banners[rowIndex].imageId!,
                                );
                          },
                          onPressedEdit: () async {
                            final result = await Navigator.of(context).push(
                              NavigateToPageWidget(
                                AddAdvertisementsAdminSun(
                                  banner: banners[firstIndex],
                                ),
                              ),
                            );

                            if (result == true && context.mounted) {
                              context.read<BannerCubit>().getBanner();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: secondIndex < banners.length
                            ? DesignContainerAdvertisementsUploadedWidget(
                                loadImage: banners[secondIndex].image,
                                onPressedDelete: () {
                                  context.read<BannerCubit>().deleteBanner(
                                        id: banners[rowIndex].imageId!,
                                      );
                                },
                                onPressedEdit: () async {
                                  final result =
                                      await Navigator.of(context).push(
                                    NavigateToPageWidget(
                                      AddAdvertisementsAdminSun(
                                        banner: banners[firstIndex],
                                      ),
                                    ),
                                  );

                                  if (result == true && context.mounted) {
                                    context.read<BannerCubit>().getBanner();
                                  }
                                },
                              )
                            : const SizedBox(),
                      ),
                    ],
                  );
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
