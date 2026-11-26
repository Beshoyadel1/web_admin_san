import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/advertisements_page/data/model/get_banners_models/banner_model.dart';
import 'package:web_admin_san/feature/advertisements_page/view_model/banner_cubit/banner_cubit.dart';
import 'package:web_admin_san/feature/advertisements_page/view_model/banner_cubit/banner_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class AddEditBannerDialog extends StatelessWidget {
  final BannerModel? banner;

  const AddEditBannerDialog({
    super.key,
    this.banner,
  });

  static Future<bool?> show(BuildContext context, {BannerModel? banner}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddEditBannerDialog(banner: banner),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = BannerCubit();
        if (banner != null) {
          cubit.setBannerData(banner!);
        }
        return cubit;
      },
      child: BannerDialogContent(banner: banner),
    );
  }
}

class BannerDialogContent extends StatefulWidget {
  final BannerModel? banner;

  const BannerDialogContent({
    super.key,
    this.banner,
  });

  @override
  State<BannerDialogContent> createState() => _BannerDialogContentState();
}

class _BannerDialogContentState extends State<BannerDialogContent> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.banner?.startDate;
    _endDate = widget.banner?.endDate;
  }

  Future<void> _pickDate({
    required BuildContext context,
    required bool isStart,
  }) async {
    final now = DateTime.now();
    final initialDate =
        isStart ? (_startDate ?? now) : (_endDate ?? (_startDate ?? now));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.orangeColor,
              onPrimary: AppColors.whiteColor,
              surface: AppColors.whiteColor,
              onSurface: AppColors.darkColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          context.read<BannerCubit>().setStartDate(picked);
        } else {
          _endDate = picked;
          context.read<BannerCubit>().setEndDate(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.banner != null;

    return BlocListener<BannerCubit, BannerState>(
      listener: (context, state) {
        if (state is BannerCreateSuccess || state is BannerUpdateSuccess) {
          AppSnackBar.showSuccess(LocaleKeys.success.tr());
          Navigator.of(context).pop(true);
        } else if (state is BannerError) {
          AppSnackBar.showError(state.message);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.whiteColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 680,
            maxHeight: 780,
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BannerDialogHeader(isEdit: isEdit),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BannerImageDropzone(
                          banner: widget.banner,
                        ),
                        const SizedBox(height: 24),
                        const TextInAppWidget(
                          text: LocaleKeys.durationFromTo,
                          textSize: 14,
                          fontWeightIndex: FontSelectionData.boldFontFamily,
                          textColor: AppColors.darkColor,
                        ),
                        const SizedBox(height: 12),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isNarrow = constraints.maxWidth < 500;
                            if (isNarrow) {
                              return Column(
                                children: [
                                  BannerDatePickerTile(
                                    label: 'تاريخ البدء',
                                    date: _startDate,
                                    onTap: () => _pickDate(
                                      context: context,
                                      isStart: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  BannerDatePickerTile(
                                    label: 'تاريخ الانتهاء',
                                    date: _endDate,
                                    onTap: () => _pickDate(
                                      context: context,
                                      isStart: false,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Row(
                              children: [
                                Expanded(
                                  child: BannerDatePickerTile(
                                    label: 'تاريخ البدء',
                                    date: _startDate,
                                    onTap: () => _pickDate(
                                      context: context,
                                      isStart: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: BannerDatePickerTile(
                                    label: 'تاريخ الانتهاء',
                                    date: _endDate,
                                    onTap: () => _pickDate(
                                      context: context,
                                      isStart: false,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BannerDialogActionButtons(
                  isEdit: isEdit,
                  onSave: () {
                    final cubit = context.read<BannerCubit>();
                    if (isEdit) {
                      cubit.updateBanner(imageId: widget.banner!.imageId!);
                    } else {
                      cubit.createBanner();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BannerDialogHeader extends StatelessWidget {
  final bool isEdit;

  const BannerDialogHeader({
    super.key,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.CircleLightorangeColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.campaign_rounded,
            color: AppColors.orangeColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInAppWidget(
                text: isEdit
                    ? LocaleKeys.updateBannerAd
                    : LocaleKeys.createBannerAd,
                textSize: 18,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.darkColor,
              ),
              const SizedBox(height: 2),
              const TextInAppWidget(
                text: 'يرجى رفع صورة الإعلان وتحديد فترة الظهور على التطبيق',
                textSize: 12,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.darkGreyColor,
              ),
            ],
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            icon:
                const Icon(Icons.close_rounded, color: AppColors.darkGreyColor),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'إغلاق',
          ),
        ),
      ],
    );
  }
}

class BannerImageDropzone extends StatelessWidget {
  final BannerModel? banner;

  const BannerImageDropzone({
    super.key,
    this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        final cubit = context.read<BannerCubit>();
        final Uint8List? currentImage = cubit.imageBytes ?? banner?.image;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextInAppWidget(
              text: 'صورة الإعلان',
              textSize: 14,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              textColor: AppColors.darkColor,
            ),
            const SizedBox(height: 8),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: cubit.pickImage,
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.greyColorSearch,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.cardStroke,
                      width: 1.5,
                    ),
                  ),
                  child: currentImage != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.memory(
                                currentImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.darkColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit_rounded,
                                      size: 14,
                                      color: AppColors.whiteColor,
                                    ),
                                    SizedBox(width: 6),
                                    TextInAppWidget(
                                      text: 'تغيير الصورة',
                                      textSize: 12,
                                      fontWeightIndex:
                                          FontSelectionData.mediumFontFamily,
                                      textColor: AppColors.whiteColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 48,
                              color: AppColors.orangeColor,
                            ),
                            SizedBox(height: 12),
                            TextInAppWidget(
                              text: LocaleKeys.uploadImageWithData,
                              textSize: 14,
                              fontWeightIndex:
                                  FontSelectionData.mediumFontFamily,
                              textColor: AppColors.darkColor,
                            ),
                            SizedBox(height: 6),
                            TextInAppWidget(
                              text:
                                  'يدعم صيغ PNG, JPG, WEBP (الحجم الأمثل 16:9)',
                              textSize: 12,
                              fontWeightIndex:
                                  FontSelectionData.regularFontFamily,
                              textColor: AppColors.darkGreyColor,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BannerDatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const BannerDatePickerTile({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  String _format(DateTime? d) {
    if (d == null) return 'اختر التاريخ';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = date != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: label,
          textSize: 13,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.darkGreyColor,
        ),
        const SizedBox(height: 6),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? AppColors.orangeColor : AppColors.cardStroke,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: isSelected
                        ? AppColors.orangeColor
                        : AppColors.darkGreyColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextInAppWidget(
                      text: _format(date),
                      textSize: 14,
                      fontWeightIndex: isSelected
                          ? FontSelectionData.mediumFontFamily
                          : FontSelectionData.regularFontFamily,
                      textColor: isSelected
                          ? AppColors.darkColor
                          : AppColors.darkGreyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BannerDialogActionButtons extends StatelessWidget {
  final bool isEdit;
  final VoidCallback onSave;

  const BannerDialogActionButtons({
    super.key,
    required this.isEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        final isLoading =
            state is BannerCreateLoading || state is BannerUpdateLoading;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  side: const BorderSide(color: AppColors.cardStroke),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                child: const TextInAppWidget(
                  text: LocaleKeys.cancel,
                  textSize: 14,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.darkGreyColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            MouseRegion(
              cursor: isLoading
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.click,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : onSave,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.whiteColor,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: AppColors.whiteColor,
                          ),
                          const SizedBox(width: 8),
                          TextInAppWidget(
                            text: isEdit
                                ? LocaleKeys.updateBannerAd
                                : LocaleKeys.createBannerAd,
                            textSize: 14,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.whiteColor,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
