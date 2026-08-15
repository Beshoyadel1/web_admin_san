import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/text_form_field_widget.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

import 'package:web_admin_san/features/coupon/data/model/coupon_model/coupon_model.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_cubit.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_state.dart';

class CreateCouponDialog extends StatefulWidget {
  const CreateCouponDialog({
    super.key,
  });

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

  int selectedDiscountType = 1;

  bool isActive = true;

  DateTime? startDate;

  DateTime? endDate;

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
  Widget build(
    BuildContext context,
  ) {
    return BlocListener<CouponCubit, CouponState>(
      listener: (
        context,
        state,
      ) {
        if (state is CouponCreateSuccess) {
          Navigator.pop(
            context,
            true,
          );
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const TextInAppWidget(
          text: AppLanguageKeys.createCoupon,
          textSize: 20,
          textColor: AppColors.orangeColor,
          isTextCenter: true,
        ),
        content: SizedBox(
          width: 550,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  // =================================
                  // CODE
                  // =================================

                  _field(
                    AppLanguageKeys.couponCode,
                    couponCodeController,
                  ),

                  _discountType(),

                  _field(
                    AppLanguageKeys.discountValue,
                    discountValueController,
                    isDouble: true,
                  ),

                  _field(
                    AppLanguageKeys.maxDiscountValue,
                    maxDiscountController,
                    isDouble: true,
                  ),

                  _field(
                    AppLanguageKeys.minValueToApply,
                    minValueController,
                    isDouble: true,
                  ),

                  _field(
                    AppLanguageKeys.usersUseCount,
                    usersUseCountController,
                    isInt: true,
                  ),

                  _field(
                    AppLanguageKeys.oneUserUseCount,
                    oneUserUseCountController,
                    isInt: true,
                  ),

                  _buildProviders(),

                  _dateField(
                    title: AppLanguageKeys.pleaseSelectStartDate,
                    value: startDate,
                    onTap: () => _selectDate(
                      isStart: true,
                    ),
                  ),

                  _dateField(
                    title: AppLanguageKeys.pleaseSelectEndDate,
                    value: endDate,
                    onTap: () => _selectDate(
                      isStart: false,
                    ),
                  ),

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
                    : const TextInAppWidget(
                        text: AppLanguageKeys.create,
                        textSize: 15,
                        textColor: AppColors.whiteColor,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FIELD
  // =========================================================

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

  // =========================================================
  // DISCOUNT TYPE
  // =========================================================

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
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: TextInAppWidget(
                    text: 'Percentage',
                    textSize: 14,
                  ),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: TextInAppWidget(
                    text: 'Fixed',
                    textSize: 14,
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

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

  // =========================================================
  // DATE FIELD
  // =========================================================

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
                  text: value == null ? 'Select date' : _formatDate(value),
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
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? startDate ?? DateTime.now()
          : endDate ?? startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        startDate = picked;
      } else {
        endDate = picked;
      }
    });
  }

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

    if (startDate == null || endDate == null) {
      return;
    }

    // =========================================
    // PROVIDERS
    // =========================================

    final providers = providerControllers
        .map(
          (controller) =>
          int.tryParse(controller.text.trim()),
    )
        .whereType<int>()
        .where((id) => id > 0)
        .toList();

    if (providers.isEmpty) {
      return;
    }

    // =========================================
    // CREATE
    // =========================================

    context.read<CouponCubit>().createCoupon(
      coupon: CouponModel(
        couponCode:
        couponCodeController.text.trim(),

        discountType:
        selectedDiscountType,

        discountValue:
        double.tryParse(
          discountValueController.text.trim(),
        ) ??
            0,

        isActive:
        isActive,

        maxDiscountValue:
        double.tryParse(
          maxDiscountController.text.trim(),
        ) ??
            0,

        minValueToApply:
        double.tryParse(
          minValueController.text.trim(),
        ) ??
            0,

        couponStartDate:
        startDate,

        couponEndDate:
        endDate,

        usersUseCount:
        int.tryParse(
          usersUseCountController.text.trim(),
        ) ??
            0,

        oneUserUseCount:
        int.tryParse(
          oneUserUseCountController.text.trim(),
        ) ??
            0,
      ),

      providers: providers,
    );
  }

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
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      textFormController:
                      providerControllers[index],

                      isDigit: true,

                      hintText: 'Provider ${index + 1}',

                      fillColor:
                      AppColors.transparent,

                      borderColor:
                      AppColors.darkColor
                          .withOpacity(0.2),

                      hintTextSize: 12,

                      hintTextColor:
                      AppColors.orangeColor,

                      textSize: 15,

                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return '';
                        }

                        final id =
                        int.tryParse(value.trim());

                        if (id == null || id <= 0) {
                          return 'Invalid provider ID';
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  // REMOVE
                  if (providerControllers.length > 1)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          final controller =
                          providerControllers.removeAt(index);

                          controller.dispose();
                        });
                      },
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),

                  // ADD
                  if (index ==
                      providerControllers.length - 1)
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
                        color: AppColors.orangeColor,
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
