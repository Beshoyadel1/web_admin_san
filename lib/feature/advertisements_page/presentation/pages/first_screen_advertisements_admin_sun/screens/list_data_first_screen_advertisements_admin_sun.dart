import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/advertisements_page/presentation/pages/first_screen_advertisements_admin_sun/screens/row_view_all_advertisements_uploaded.dart';
import 'package:web_admin_san/feature/advertisements_page/presentation/widgets/add_edit_banner_dialog.dart';
import 'package:web_admin_san/feature/advertisements_page/presentation/widgets/banners_header_bar.dart';
import 'package:web_admin_san/feature/advertisements_page/view_model/banner_cubit/banner_cubit.dart';
import 'package:web_admin_san/feature/advertisements_page/view_model/banner_cubit/banner_state.dart';

class ListDataAdvertisementsPage extends StatelessWidget {
  const ListDataAdvertisementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        final count = (state is BannerSuccess) ? state.banners.length : 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BannersHeaderBar(
              totalBanners: count,
              onAddBanner: () async {
                final result = await AddEditBannerDialog.show(context);
                if (result == true && context.mounted) {
                  context.read<BannerCubit>().getBanner();
                }
              },
            ),
            const SizedBox(height: 24),
            const RowViewAllAdvertisementsUploaded(),
          ],
        );
      },
    );
  }
}
