import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/data/model/get_all_pages_about_model/get_all_pages_about_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class PolicyContentEditorCard extends StatefulWidget {
  final AboutPageModel page;
  final Future<bool> Function(AboutPageModel updatedPage) onSave;
  final bool isSaving;

  const PolicyContentEditorCard({
    super.key,
    required this.page,
    required this.onSave,
    required this.isSaving,
  });

  @override
  State<PolicyContentEditorCard> createState() =>
      _PolicyContentEditorCardState();
}

class _PolicyContentEditorCardState extends State<PolicyContentEditorCard> {
  late TextEditingController _titleArController;
  late TextEditingController _titleEnController;
  late TextEditingController _contentArController;
  late TextEditingController _contentEnController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _titleArController =
        TextEditingController(text: widget.page.titleText ?? '');
    _titleEnController =
        TextEditingController(text: widget.page.titleTextEn ?? '');
    _contentArController =
        TextEditingController(text: widget.page.contentText ?? '');
    _contentEnController =
        TextEditingController(text: widget.page.contentTextEn ?? '');

    _titleArController.addListener(_onTextChanged);
    _titleEnController.addListener(_onTextChanged);
    _contentArController.addListener(_onTextChanged);
    _contentEnController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final changed = _titleArController.text != (widget.page.titleText ?? '') ||
        _titleEnController.text != (widget.page.titleTextEn ?? '') ||
        _contentArController.text != (widget.page.contentText ?? '') ||
        _contentEnController.text != (widget.page.contentTextEn ?? '');

    if (changed != _hasChanges) {
      setState(() {
        _hasChanges = changed;
      });
    }
  }

  @override
  void didUpdateWidget(covariant PolicyContentEditorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page.id != widget.page.id) {
      _titleArController.text = widget.page.titleText ?? '';
      _titleEnController.text = widget.page.titleTextEn ?? '';
      _contentArController.text = widget.page.contentText ?? '';
      _contentEnController.text = widget.page.contentTextEn ?? '';
      _hasChanges = false;
    }
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _contentArController.dispose();
    _contentEnController.dispose();
    super.dispose();
  }

  void _resetFields() {
    setState(() {
      _titleArController.text = widget.page.titleText ?? '';
      _titleEnController.text = widget.page.titleTextEn ?? '';
      _contentArController.text = widget.page.contentText ?? '';
      _contentEnController.text = widget.page.contentTextEn ?? '';
      _hasChanges = false;
    });
  }

  Future<void> _handleSave() async {
    final updated = AboutPageModel(
      id: widget.page.id,
      titleText: _titleArController.text.trim(),
      titleTextEn: _titleEnController.text.trim(),
      contentText: _contentArController.text.trim(),
      contentTextEn: _contentEnController.text.trim(),
      lastModified: widget.page.lastModified,
    );

    final success = await widget.onSave(updated);
    if (success && mounted) {
      setState(() {
        _hasChanges = false;
      });
      AppSnackBar.showSuccess(LocaleKeys.success);
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'غير محدد';
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y/$m/$d $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: const [
          BoxShadow(
            color: AppColors.greyColor200,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCardHeader(),
          const Divider(height: 1, thickness: 1, color: AppColors.cardStroke),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 880;

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PolicyLanguageEditorColumn(
                          isArabic: true,
                          titleController: _titleArController,
                          contentController: _contentArController,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Container(
                        width: 1,
                        height: 520,
                        color: AppColors.cardStroke,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: PolicyLanguageEditorColumn(
                          isArabic: false,
                          titleController: _titleEnController,
                          contentController: _contentEnController,
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    PolicyLanguageEditorColumn(
                      isArabic: true,
                      titleController: _titleArController,
                      contentController: _contentArController,
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: AppColors.cardStroke),
                    const SizedBox(height: 24),
                    PolicyLanguageEditorColumn(
                      isArabic: false,
                      titleController: _titleEnController,
                      contentController: _contentEnController,
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.cardStroke),
          _buildCardFooter(),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.blueColor100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextInAppWidget(
              text: 'ID: ${widget.page.id}',
              textSize: 12,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              textColor: AppColors.seaBlueColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInAppWidget(
                  text: widget.page.titleText ?? 'صفحة غير معنونة',
                  textSize: 16,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                  textColor: AppColors.darkColor,
                ),
                if (widget.page.lastModified != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: AppColors.darkGreyColor,
                      ),
                      const SizedBox(width: 4),
                      TextInAppWidget(
                        text:
                            'آخر تحديث: ${_formatDate(widget.page.lastModified)}',
                        textSize: 12,
                        fontWeightIndex: FontSelectionData.regularFontFamily,
                        textColor: AppColors.darkGreyColor,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (_hasChanges)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.CircleLightorangeColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_note_rounded,
                    size: 14,
                    color: AppColors.darkorangeColor,
                  ),
                  SizedBox(width: 4),
                  TextInAppWidget(
                    text: 'توجد تعديلات غير محفوظة',
                    textSize: 11,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.darkorangeColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;

          const noteWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppColors.darkGreyColor,
              ),
              SizedBox(width: 6),
              Flexible(
                child: TextInAppWidget(
                  text:
                      'التعديلات تنعكس مباشرة في تطبيق المستخدم وموقع الويب فور الحفظ',
                  textSize: 12,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                  textColor: AppColors.darkGreyColor,
                ),
              ),
            ],
          );

          final actionsWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_hasChanges) ...[
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      side: const BorderSide(color: AppColors.cardStroke),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: widget.isSaving ? null : _resetFields,
                    child: const TextInAppWidget(
                      text: 'إلغاء التعديلات',
                      textSize: 13,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                      textColor: AppColors.darkGreyColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              MouseRegion(
                cursor: widget.isSaving
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.click,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: widget.isSaving ? null : _handleSave,
                  child: widget.isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.whiteColor,
                            ),
                          ),
                        )
                      : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.save_rounded,
                              size: 16,
                              color: AppColors.whiteColor,
                            ),
                            SizedBox(width: 6),
                            TextInAppWidget(
                              text: 'حفظ التعديلات',
                              textSize: 13,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                              textColor: AppColors.whiteColor,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                noteWidget,
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [actionsWidget],
                ),
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: noteWidget),
              const SizedBox(width: 16),
              actionsWidget,
            ],
          );
        },
      ),
    );
  }
}

class PolicyLanguageEditorColumn extends StatelessWidget {
  final bool isArabic;
  final TextEditingController titleController;
  final TextEditingController contentController;

  const PolicyLanguageEditorColumn({
    super.key,
    required this.isArabic,
    required this.titleController,
    required this.contentController,
  });

  @override
  Widget build(BuildContext context) {
    final languageName = isArabic ? 'العربية' : 'English';
    final badgeColor =
        isArabic ? AppColors.lightGreenColor : AppColors.blueColor100;
    final badgeTextColor =
        isArabic ? AppColors.greenColor : AppColors.seaBlueColor;
    final flag = isArabic ? '🇸🇦' : '🇬🇧';
    final textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(flag, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  TextInAppWidget(
                    text: languageName,
                    textSize: 12,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                    textColor: badgeTextColor,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextInAppWidget(
              text: isArabic ? '(النسخة الرئيسية)' : '(النسخة الإنجليزية)',
              textSize: 12,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.darkGreyColor,
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextInAppWidget(
          text: isArabic ? 'عنوان الصفحة' : 'Page Title',
          textSize: 13,
          fontWeightIndex: FontSelectionData.boldFontFamily,
          textColor: AppColors.darkColor,
        ),
        const SizedBox(height: 6),
        Directionality(
          textDirection: textDirection,
          child: TextFormField(
            controller: titleController,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.darkColor,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: isArabic
                  ? 'أدخل عنوان الصفحة بالعربية'
                  : 'Enter page title in English',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AppColors.darkGreyColor,
              ),
              filled: true,
              fillColor: AppColors.scaffoldColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.cardStroke),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.cardStroke),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.orangeColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextInAppWidget(
          text: isArabic ? 'محتوى الصفحة' : 'Page Content',
          textSize: 13,
          fontWeightIndex: FontSelectionData.boldFontFamily,
          textColor: AppColors.darkColor,
        ),
        const SizedBox(height: 6),
        Directionality(
          textDirection: textDirection,
          child: TextFormField(
            controller: contentController,
            minLines: 12,
            maxLines: 20,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.darkColor,
              height: 1.6,
            ),
            decoration: InputDecoration(
              hintText: isArabic
                  ? 'أدخل نص ومحتوى الصفحة بالتفصيل...'
                  : 'Enter page body content in detail...',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AppColors.darkGreyColor,
              ),
              filled: true,
              fillColor: AppColors.scaffoldColor,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.cardStroke),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.cardStroke),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.orangeColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
