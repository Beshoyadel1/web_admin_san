import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/advertisements_page/data/model/get_banners_models/banner_model.dart';
import 'package:web_admin_san/feature/advertisements_page/presentation/pages/add_advertisements_admin_sun/screens/container_add_advertisements_admin_sun.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class AddAdvertisementsAdminSun extends StatefulWidget {
  final BannerModel? banner;

  const AddAdvertisementsAdminSun({
    super.key,
    this.banner,
  });

  @override
  State<AddAdvertisementsAdminSun> createState() =>
      _AddAdvertisementsAdminSunState();
}

class _AddAdvertisementsAdminSunState extends State<AddAdvertisementsAdminSun> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.banner != null;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: TextInAppWidget(
          text: isEdit ? LocaleKeys.updateBannerAd : LocaleKeys.createBannerAd,
          textSize: 18,
          fontWeightIndex: FontSelectionData.boldFontFamily,
          textColor: AppColors.darkColor,
        ),
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.darkColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.cardStroke,
          ),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ContainerAddAdvertisementsAdminSun(
                    banner: widget.banner,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
