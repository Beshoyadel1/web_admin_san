import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/coupons_page/data/model/coupon_model/coupon_model.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/widgets/coupon_basic_info_section.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/widgets/coupon_dialog_actions.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/widgets/coupon_dialog_header.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/widgets/coupon_discount_details_section.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/widgets/coupon_provider_selection_section.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/widgets/coupon_status_toggle_section.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/widgets/coupon_usage_limits_section.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/widgets/coupon_validity_dates_section.dart';
import 'package:web_admin_san/feature/coupons_page/view_model/coupon_cubit/coupon_cubit.dart';
import 'package:web_admin_san/feature/coupons_page/view_model/coupon_cubit/coupon_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

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
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _couponCodeController = TextEditingController();
  final TextEditingController _discountValueController =
      TextEditingController();
  final TextEditingController _maxDiscountController = TextEditingController();
  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _usersUseCountController =
      TextEditingController();
  final TextEditingController _oneUserUseCountController =
      TextEditingController();

  int? _selectedDiscountType;
  bool _isActive = true;
  DateTime? _startDate;
  DateTime? _endDate;
  List<int> _selectedProviderIds = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CouponCubit>().loadAllProviders();
    });
  }

  void _loadInitialData() {
    final data = widget.couponData;
    if (data == null) {
      _selectedDiscountType = DiscountType.fixedAmount;
      return;
    }

    final coupon = data.coupon;
    _couponCodeController.text = coupon.couponCode?.toString() ?? '';
    _selectedDiscountType = coupon.discountType ?? DiscountType.fixedAmount;
    _discountValueController.text = coupon.discountValue?.toString() ?? '';
    _maxDiscountController.text = coupon.maxDiscountValue?.toString() ?? '';
    _minValueController.text = coupon.minValueToApply?.toString() ?? '';
    _usersUseCountController.text = coupon.usersUseCount?.toString() ?? '';
    _oneUserUseCountController.text = coupon.oneUserUseCount?.toString() ?? '';
    _isActive = coupon.isActive ?? true;
    _startDate = coupon.couponStartDate;
    _endDate = coupon.couponEndDate;
    _selectedProviderIds = List<int>.from(data.providers);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _couponCodeController.dispose();
    _discountValueController.dispose();
    _maxDiscountController.dispose();
    _minValueController.dispose();
    _usersUseCountController.dispose();
    _oneUserUseCountController.dispose();
    super.dispose();
  }

  DateTime _stripTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  Future<void> _selectDate({required bool isStart}) async {
    final now = _stripTime(DateTime.now());

    if (isStart) {
      final initialDate = _startDate != null ? _stripTime(_startDate!) : now;
      final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          _startDate = _stripTime(picked);
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        });
      }
      return;
    }

    // End date picker
    if (_startDate == null) {
      AppSnackBar.showError(LocaleKeys.pleaseSelectStartDate);
      return;
    }

    final initialEndDate = _endDate != null && !_endDate!.isBefore(_startDate!)
        ? _stripTime(_endDate!)
        : _startDate!;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialEndDate,
      firstDate: _startDate!,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final chosen = _stripTime(picked);
      if (chosen.isBefore(_startDate!)) {
        AppSnackBar.showError(LocaleKeys.endDateMustBeAfterStartDate);
        return;
      }
      setState(() {
        _endDate = chosen;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDiscountType == null) {
      AppSnackBar.showError(LocaleKeys.pleaseSelectDiscountType);
      return;
    }

    if (_startDate == null) {
      AppSnackBar.showError(LocaleKeys.pleaseSelectStartDate);
      return;
    }

    if (_endDate == null) {
      AppSnackBar.showError(LocaleKeys.pleaseSelectEndDate);
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      AppSnackBar.showError(LocaleKeys.endDateMustBeAfterStartDate);
      return;
    }

    final coupon = CouponModel(
      couponId: widget.couponData?.coupon.couponId,
      couponCode: _couponCodeController.text.trim(),
      discountType: _selectedDiscountType!,
      discountValue: double.tryParse(_discountValueController.text.trim()) ?? 0,
      isActive: _isActive,
      maxDiscountValue:
          double.tryParse(_maxDiscountController.text.trim()) ?? 0,
      minValueToApply: double.tryParse(_minValueController.text.trim()) ?? 0,
      couponStartDate: _startDate,
      couponEndDate: _endDate,
      usersUseCount: int.tryParse(_usersUseCountController.text.trim()) ?? 0,
      oneUserUseCount:
          int.tryParse(_oneUserUseCountController.text.trim()) ?? 0,
    );

    if (widget.isEditMode) {
      context.read<CouponCubit>().updateCoupon(
            couponData: CouponWithProviderModel(
              coupon: coupon,
              providers: _selectedProviderIds,
            ),
          );
      return;
    }

    context.read<CouponCubit>().createCoupon(
          coupon: coupon,
          providers: _selectedProviderIds,
        );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = (screenWidth * 0.75).clamp(380.0, 740.0);
    final isTwoColumn = dialogWidth >= 620;

    return BlocConsumer<CouponCubit, CouponState>(
      listener: (context, state) {
        if (state is CouponCreateSuccess || state is CouponUpdateSuccess) {
          if (!mounted) return;
          Navigator.of(context).pop(true);
        } else if (state is CouponFailure) {
          AppSnackBar.showError(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is CouponLoading;
        final cubit = context.read<CouponCubit>();

        return Dialog(
          backgroundColor: AppColors.scaffoldColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dialogWidth,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Header
                CouponDialogHeader(
                  isEditMode: widget.isEditMode,
                  onClose: () => Navigator.of(context).pop(false),
                ),

                // Dialog Content Body
                Flexible(
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (isTwoColumn) ...[
                              // Row 1: Basic Info & Discount Details
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CouponBasicInfoSection(
                                      codeController: _couponCodeController,
                                      selectedDiscountType:
                                          _selectedDiscountType,
                                      onDiscountTypeChanged: (type) {
                                        setState(() {
                                          _selectedDiscountType = type;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: CouponDiscountDetailsSection(
                                      discountValueController:
                                          _discountValueController,
                                      maxDiscountController:
                                          _maxDiscountController,
                                      minValueController: _minValueController,
                                      isPercentage: _selectedDiscountType ==
                                          DiscountType.percentage,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Row 2: Usage Limits & Dates
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CouponUsageLimitsSection(
                                      usersUseCountController:
                                          _usersUseCountController,
                                      oneUserUseCountController:
                                          _oneUserUseCountController,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: CouponValidityDatesSection(
                                      startDate: _startDate,
                                      endDate: _endDate,
                                      onSelectStartDate: () =>
                                          _selectDate(isStart: true),
                                      onSelectEndDate: () =>
                                          _selectDate(isStart: false),
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              // Single-column layout on mobile / narrow screens
                              CouponBasicInfoSection(
                                codeController: _couponCodeController,
                                selectedDiscountType: _selectedDiscountType,
                                onDiscountTypeChanged: (type) {
                                  setState(() {
                                    _selectedDiscountType = type;
                                  });
                                },
                              ),
                              const SizedBox(height: 14),
                              CouponDiscountDetailsSection(
                                discountValueController:
                                    _discountValueController,
                                maxDiscountController: _maxDiscountController,
                                minValueController: _minValueController,
                                isPercentage: _selectedDiscountType ==
                                    DiscountType.percentage,
                              ),
                              const SizedBox(height: 14),
                              CouponUsageLimitsSection(
                                usersUseCountController:
                                    _usersUseCountController,
                                oneUserUseCountController:
                                    _oneUserUseCountController,
                              ),
                              const SizedBox(height: 14),
                              CouponValidityDatesSection(
                                startDate: _startDate,
                                endDate: _endDate,
                                onSelectStartDate: () =>
                                    _selectDate(isStart: true),
                                onSelectEndDate: () =>
                                    _selectDate(isStart: false),
                              ),
                            ],

                            const SizedBox(height: 16),

                            // Status Toggle
                            CouponStatusToggleSection(
                              isActive: _isActive,
                              onToggle: (val) {
                                setState(() {
                                  _isActive = val;
                                });
                              },
                            ),

                            const SizedBox(height: 16),

                            // Multi-Select Providers Search Dropdown
                            CouponProviderSelectionSection(
                              providers: cubit.availableProviders,
                              selectedProviderIds: _selectedProviderIds,
                              onSelectionChanged: (ids) {
                                setState(() {
                                  _selectedProviderIds = ids;
                                });
                              },
                              isLoading: cubit.isLoadingProviders,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Dialog Actions
                CouponDialogActions(
                  isEditMode: widget.isEditMode,
                  isLoading: isLoading,
                  onCancel: () => Navigator.of(context).pop(false),
                  onSubmit: _submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
