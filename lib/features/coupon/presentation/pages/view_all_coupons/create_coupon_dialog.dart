import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:web_admin_san/core/pages_widgets/text_form_field_widget.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

import 'package:web_admin_san/features/coupon/data/model/coupon_model/coupon_model.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_cubit.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_state.dart';

class CreateCouponDialog extends StatefulWidget {
  final CouponWithProviderModel? couponData;

  const CreateCouponDialog({
    super.key,
    this.couponData,
  });

  bool get isEditMode => couponData != null;

  @override
  State<CreateCouponDialog> createState() => _CreateCouponDialogState();
}

class _CreateCouponDialogState extends State<CreateCouponDialog> {
  final _formKey = GlobalKey<FormState>();

  // =========================================
  // CONTROLLERS
  // =========================================

  final couponCodeController = TextEditingController();

  final discountValueController = TextEditingController();

  final maxDiscountController = TextEditingController();

  final minValueController = TextEditingController();

  final usersUseCountController = TextEditingController();

  final oneUserUseCountController = TextEditingController();

  final List<TextEditingController> providerControllers = [
    TextEditingController(),
  ];

  // =========================================
  // VALUES
  // =========================================

  int? selectedDiscountType;

  bool isActive = true;

  DateTime? startDate;

  DateTime? endDate;

  // =========================================
  // DISPOSE
  // =========================================

  @override
  void dispose() {
    couponCodeController.dispose();
    discountValueController.dispose();
    maxDiscountController.dispose();
    minValueController.dispose();
    usersUseCountController.dispose();
    oneUserUseCountController.dispose();

    for (final controller in providerControllers) {
      controller.dispose();
    }

    super.dispose();
  }
  @override
  void initState() {
    super.initState();

    _loadCouponData();
  }

  void _loadCouponData() {
    final data = widget.couponData;

    if (data == null) {
      return;
    }

    final coupon = data.coupon;

    couponCodeController.text =
        coupon.couponCode?.toString() ?? '';

    selectedDiscountType =
        coupon.discountType;

    discountValueController.text =
        coupon.discountValue?.toString() ?? '';

    maxDiscountController.text =
        coupon.maxDiscountValue?.toString() ?? '';

    minValueController.text =
        coupon.minValueToApply?.toString() ?? '';

    usersUseCountController.text =
        coupon.usersUseCount?.toString() ?? '';

    oneUserUseCountController.text =
        coupon.oneUserUseCount?.toString() ?? '';

    isActive =
        coupon.isActive ?? true;

    startDate =
        coupon.couponStartDate;

    endDate =
        coupon.couponEndDate;

    // =========================================
    // PROVIDERS
    // =========================================

    for (final controller in providerControllers) {
      controller.dispose();
    }

    providerControllers.clear();

    for (final providerId in data.providers) {
      providerControllers.add(
        TextEditingController(
          text: providerId.toString(),
        ),
      );
    }

    if (providerControllers.isEmpty) {
      providerControllers.add(
        TextEditingController(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CouponCubit, CouponState>(
      listener: (
        context,
        state,
      ) {
        if (state is CouponCreateSuccess ||
            state is CouponUpdateSuccess) {

          if (!mounted) {
            return;
          }

          Navigator.of(context).pop(true);
          return;
        }

        if (state is CouponFailure) {
          AppSnackBar.showError(
            state.message,
          );
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        title: TextInAppWidget(
          text: widget.isEditMode
              ? AppLanguageKeys.edit
              : AppLanguageKeys.createCoupon,
          textSize: 20,
          textColor: AppColors.orangeColor,
          isTextCenter: true,
        ),

        content: SizedBox(
          width: 550,

          // Important:
          // Keep actions visible and make
          // only the content scrollable.
          height: MediaQuery.of(context).size.height * 0.65,

          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  // =================================
                  // COUPON CODE
                  // =================================

                  _field(
                    AppLanguageKeys.couponCode,
                    couponCodeController,
                  ),

                  // =================================
                  // DISCOUNT TYPE
                  // =================================

                  _discountType(),

                  // =================================
                  // DISCOUNT VALUE
                  // =================================

                  _field(
                    AppLanguageKeys.discountValue,
                    discountValueController,
                    isDouble: true,
                  ),

                  // =================================
                  // MAX DISCOUNT
                  // =================================

                  _field(
                    AppLanguageKeys.maxDiscountValue,
                    maxDiscountController,
                    isDouble: true,
                  ),

                  // =================================
                  // MIN VALUE
                  // =================================

                  _field(
                    AppLanguageKeys.minValueToApply,
                    minValueController,
                    isDouble: true,
                  ),

                  // =================================
                  // USERS USE COUNT
                  // =================================

                  _field(
                    AppLanguageKeys.usersUseCount,
                    usersUseCountController,
                    isInt: true,
                  ),

                  // =================================
                  // ONE USER USE COUNT
                  // =================================

                  _field(
                    AppLanguageKeys.oneUserUseCount,
                    oneUserUseCountController,
                    isInt: true,
                  ),

                  // =================================
                  // PROVIDERS
                  // =================================

                  _buildProviders(),

                  // =================================
                  // START DATE
                  // =================================

                  _dateField(
                    title: AppLanguageKeys.pleaseSelectStartDate,
                    value: startDate,
                    onTap: () => _selectDate(
                      isStart: true,
                    ),
                  ),

                  // =================================
                  // END DATE
                  // =================================

                  _dateField(
                    title: AppLanguageKeys.pleaseSelectEndDate,
                    value: endDate,
                    onTap: () => _selectDate(
                      isStart: false,
                    ),
                  ),

                  // =================================
                  // ACTIVE
                  // =================================

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextInAppWidget(
                        text: AppLanguageKeys.active,
                        textSize: 14,
                      ),
                      Switch(
                        value: isActive,
                        activeColor: AppColors.orangeColor,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // =========================================
        // ACTIONS
        // =========================================

        actions: [
          // =================================
          // CANCEL
          // =================================

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const TextInAppWidget(
              text: AppLanguageKeys.cancel,
              textSize: 15,
            ),
          ),

          // =================================
          // CREATE
          // =================================

          BlocBuilder<CouponCubit, CouponState>(
            builder: (
              context,
              state,
            ) {
              final isLoading = state is CouponLoading;

              return ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeColor,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : TextInAppWidget(
                          text: widget.isEditMode
                              ? AppLanguageKeys.edit
                              : AppLanguageKeys.create,
                          textSize: 15,
                          textColor: AppColors.whiteColor,
                        ));
            },
          ),
        ],
      ),
    );
  }

  Widget _field(
    String title,
    TextEditingController controller, {
    bool isDouble = false,
    bool isInt = false,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: title,
          textSize: 13,
          textColor: AppColors.darkColor.withOpacity(0.6),
        ),
        const SizedBox(height: 5),
        TextFormFieldWidget(
          textFormController: controller,
          isDigitDot: isDouble,
          isDigit: isInt,
          hintText: hint,
          fillColor: AppColors.transparent,
          borderColor: AppColors.darkColor.withOpacity(0.2),
          hintTextSize: 12,
          hintTextColor: AppColors.orangeColor,
          textSize: 15,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '';
            }

            return null;
          },
        ),
      ],
    );
  }


  Widget _discountType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.discountType,
          textSize: 13,
          textColor: AppColors.greyColor,
        ),
        const SizedBox(height: 5),
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.darkColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedDiscountType,
              hint: const TextInAppWidget(
                text: AppLanguageKeys.chooseTheCategory,
                textSize: 14,
                textColor: AppColors.greyColor,
              ),
              isExpanded: true,
              items: const [
                DropdownMenuItem<int>(
                  value: DiscountType.fixedAmount,
                  child: TextInAppWidget(
                    text: AppLanguageKeys.fixedAmount,
                    textSize: 14,
                  ),
                ),
                DropdownMenuItem<int>(
                  value: DiscountType.percentage,
                  child: TextInAppWidget(
                    text: AppLanguageKeys.percentage,
                    textSize: 14,
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedDiscountType = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
  

  Widget _dateField({
    required String title,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: title,
          textSize: 13,
          textColor: AppColors.greyColor,
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.darkColor.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextInAppWidget(
                  text: value == null
                      ? AppLanguageKeys.selectDate
                      : _formatDate(value),
                  textSize: 14,
                  textColor:
                      value == null ? AppColors.greyColor : AppColors.darkColor,
                ),
                const Icon(
                  Icons.calendar_month,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // DATE PICKER
  // =========================================================

  Future<void> _selectDate({
    required bool isStart,
  }) async {
    DateTime dateOnly(DateTime date) {
      return DateTime(
        date.year,
        date.month,
        date.day,
      );
    }

    // =========================================================
    // START DATE
    // =========================================================

    if (isStart) {
      final DateTime today = dateOnly(DateTime.now());

      final DateTime initialStartDate = startDate != null
          ? dateOnly(startDate!)
          : today;

      final DateTime? pickedStartDate = await showDatePicker(
        context: context,
        initialDate: initialStartDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );

      if (pickedStartDate == null) {
        return;
      }

      final DateTime newStartDate = dateOnly(pickedStartDate);

      setState(() {
        startDate = newStartDate;

        // =====================================================
        // VERY IMPORTANT
        //
        // If the current end date is now invalid,
        // remove it.
        // =====================================================

        if (endDate != null) {
          final DateTime currentEndDate = dateOnly(endDate!);

          if (currentEndDate.isBefore(newStartDate)) {
            endDate = null;
          } else {
            endDate = currentEndDate;
          }
        }
      });

      return;
    }

    // =========================================================
    // END DATE
    // =========================================================

    if (startDate == null) {
      AppSnackBar.showError(
        AppLanguageKeys.pleaseSelectStartDate,
      );

      return;
    }

    // Always get the CURRENT start date.
    final DateTime currentStartDate = dateOnly(startDate!);

    // =========================================================
    // IMPORTANT:
    // If edit mode contains an old invalid end date,
    // don't allow it to be used.
    // =========================================================

    DateTime? currentEndDate;

    if (endDate != null) {
      final DateTime tempEndDate = dateOnly(endDate!);

      if (!tempEndDate.isBefore(currentStartDate)) {
        currentEndDate = tempEndDate;
      } else {
        // Old end date is invalid.
        // Clear it.
        setState(() {
          endDate = null;
        });
      }
    }

    // =========================================================
    // INITIAL DATE
    // =========================================================

    final DateTime initialEndDate =
        currentEndDate ?? currentStartDate;

    // =========================================================
    // END DATE PICKER
    // =========================================================

    final DateTime? pickedEndDate = await showDatePicker(
      context: context,

      // Never allow initial date before start date.
      initialDate: initialEndDate,

      // THIS IS THE ACTUAL RESTRICTION.
      // User cannot select anything before startDate.
      firstDate: currentStartDate,

      lastDate: DateTime(2100),
    );

    if (pickedEndDate == null) {
      return;
    }

    final DateTime newEndDate = dateOnly(pickedEndDate);

    // =========================================================
    // FINAL SAFETY CHECK
    // =========================================================

    if (newEndDate.isBefore(currentStartDate)) {
      AppSnackBar.showError(
        AppLanguageKeys.endDateMustBeAfterStartDate,
      );

      return;
    }

    setState(() {
      endDate = newEndDate;
    });
  }

  // =========================================================
  // FORMAT DATE
  // =========================================================

  String _formatDate(
    DateTime date,
  ) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  // =========================================================
  // SUBMIT
  // =========================================================

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // =========================================
    // DISCOUNT TYPE
    // =========================================

    if (selectedDiscountType == null) {
      AppSnackBar.showError(
        AppLanguageKeys.pleaseSelectDiscountType,
      );
      return;
    }

    // =========================================
    // START DATE
    // =========================================

    if (startDate == null) {
      AppSnackBar.showError(
        AppLanguageKeys.pleaseSelectStartDate,
      );
      return;
    }

    // =========================================
    // END DATE
    // =========================================

    if (endDate == null) {
      AppSnackBar.showError(
        AppLanguageKeys.pleaseSelectEndDate,
      );
      return;
    }

    // =========================================
    // DATE VALIDATION
    // =========================================

    if (endDate!.isBefore(startDate!)) {
      AppSnackBar.showError(
        AppLanguageKeys.endDateMustBeAfterStartDate,
      );
      return;
    }

    // =========================================
    // PROVIDERS
    // =========================================

    final List<int> providers = [];

    for (final controller in providerControllers) {
      final value = controller.text.trim();

      // آخر خانة الإضافة ممكن تكون فاضية
      if (value.isEmpty) {
        continue;
      }

      final providerId = int.tryParse(value);

      if (providerId == null || providerId <= 0) {
        AppSnackBar.showError(
          AppLanguageKeys.invalidProviderId,
        );
        return;
      }

      providers.add(providerId);
    }

    if (providers.isEmpty) {
      AppSnackBar.showError(
        AppLanguageKeys.pleaseEnterAtLeastOneProvider,
      );
      return;
    }

    // =========================================
    // BUILD COUPON
    // =========================================

    final coupon = CouponModel(
      // Keep ID when editing
      couponId: widget.couponData?.coupon.couponId,

      couponCode: couponCodeController.text.trim(),

      discountType: selectedDiscountType!,

      discountValue: double.tryParse(
            discountValueController.text.trim(),
          ) ??
          0,

      isActive: isActive,

      maxDiscountValue: double.tryParse(
            maxDiscountController.text.trim(),
          ) ??
          0,

      minValueToApply: double.tryParse(
            minValueController.text.trim(),
          ) ??
          0,

      couponStartDate: startDate,

      couponEndDate: endDate,

      usersUseCount: int.tryParse(
            usersUseCountController.text.trim(),
          ) ??
          0,

      oneUserUseCount: int.tryParse(
            oneUserUseCountController.text.trim(),
          ) ??
          0,
    );

    // =========================================
    // EDIT
    // =========================================

    if (widget.isEditMode) {
      context.read<CouponCubit>().updateCoupon(
            couponData: CouponWithProviderModel(
              coupon: coupon,
              providers: providers,
            ),
          );

      return;
    }

    // =========================================
    // CREATE
    // =========================================

    context.read<CouponCubit>().createCoupon(
          coupon: coupon,
          providers: providers,
        );
  }

  // =========================================================
  // PROVIDERS
  // =========================================================

  Widget _buildProviders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.providerNo,
          textSize: 13,
          textColor: AppColors.greyColor,
        ),

        const SizedBox(height: 8),

        ...List.generate(
          providerControllers.length,
              (index) {
            final controller =
            providerControllers[index];

            final isLast =
                index == providerControllers.length - 1;

            final canRemove =
                providerControllers.length > 1;

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      textFormController: controller,
                      isDigit: true,
                      hintText:
                      'Provider ${index + 1}',
                      fillColor:
                      AppColors.transparent,
                      borderColor:
                      AppColors.darkColor
                          .withOpacity(0.2),
                      hintTextSize: 12,
                      hintTextColor:
                      AppColors.greyColor,
                      textSize: 15,

                      validator: (value) {
                        final text =
                            value?.trim() ?? '';

                        // Empty extra field is allowed
                        if (text.isEmpty) {
                          return null;
                        }

                        final id =
                        int.tryParse(text);

                        if (id == null || id <= 0) {
                          return AppLanguageKeys
                              .invalidProviderId;
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ==========================
                  // REMOVE
                  // ==========================

                  if (canRemove)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          final controller =
                          providerControllers
                              .removeAt(index);

                          controller.dispose();
                        });
                      },
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),

                  // ==========================
                  // ADD
                  // ==========================

                  if (isLast)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          providerControllers.add(
                            TextEditingController(),
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        color:
                        AppColors.orangeColor,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

}
