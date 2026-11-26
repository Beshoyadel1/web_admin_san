import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/core/widgets/text_form_field_widget.dart';
import 'package:web_admin_san/feature/accounts_management_page/data/request/create_settlement_request/create_settlement_request.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/settlement_cubit/settlement_cubit.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/settlement_cubit/settlement_state.dart';
import 'package:web_admin_san/feature/auth_page/data/datasource/get_user_info_datasource/get_user_info_datasource.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/feature/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class StartSettlementDialog extends StatefulWidget {
  final ProviderDetailsRequest providerDetailsRequest;
  final double currentBalance;
  final VoidCallback onSettlementCompleted;

  const StartSettlementDialog({
    super.key,
    required this.providerDetailsRequest,
    required this.currentBalance,
    required this.onSettlementCompleted,
  });

  @override
  State<StartSettlementDialog> createState() => _StartSettlementDialogState();
}

class _StartSettlementDialogState extends State<StartSettlementDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ibanController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  DateTime? _startDate;
  DateTime? _endDate;
  bool _hasRegisteredIban = false;

  @override
  void initState() {
    super.initState();
    final initialIban = (widget.providerDetailsRequest.iban ?? '').trim();
    if (initialIban.isNotEmpty) {
      _hasRegisteredIban = true;
    }

    _ibanController = TextEditingController(text: initialIban);
    _amountController = TextEditingController(
      text: widget.currentBalance > 0
          ? widget.currentBalance.toStringAsFixed(2)
          : '',
    );
    _notesController = TextEditingController();

    // Auto-resolve IBAN from settlements history or backend if initially empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolveProviderIban();
    });
  }

  Future<void> _resolveProviderIban() async {
    if (_ibanController.text.trim().isNotEmpty) {
      if (!_hasRegisteredIban) {
        setState(() => _hasRegisteredIban = true);
      }
      return;
    }

    // 1. Check SettlementCubit loaded settlements for a recent IBAN
    try {
      final settlementState = context.read<SettlementCubit>().state;
      if (settlementState is SettlementSuccess &&
          settlementState.settlements.isNotEmpty) {
        for (final item in settlementState.settlements) {
          final sIban = item.iban.trim();
          if (sIban.isNotEmpty) {
            if (mounted) {
              setState(() {
                _ibanController.text = sIban;
                _hasRegisteredIban = true;
              });
            }
            return;
          }
        }
      }
    } catch (_) {}

    // 2. Query getUserInfo API for provider's full profile
    final providerId = widget.providerDetailsRequest.id ??
        widget.providerDetailsRequest.provid ??
        0;
    if (providerId > 0) {
      try {
        final userInfo = await getUserInfoFunction(
          request: GetUserInfoRequest(userId: providerId, userType: 4),
        );
        final fetchedIban = (userInfo.providerDetails?.iban ?? '').trim();
        if (mounted &&
            fetchedIban.isNotEmpty &&
            _ibanController.text.trim().isEmpty) {
          setState(() {
            _ibanController.text = fetchedIban;
            _hasRegisteredIban = true;
          });
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _ibanController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _submitSettlement() async {
    if (!_formKey.currentState!.validate()) return;

    final providerId = widget.providerDetailsRequest.id ??
        widget.providerDetailsRequest.provid ??
        0;
    final iban = _ibanController.text.trim();
    final parsedAmount = double.tryParse(_amountController.text.trim());
    final notes = _notesController.text.trim();

    final request = CreateSettlementRequest(
      toUserId: providerId,
      toUserType: 4,
      fromUserId: 1, // Admin user ID
      iban: iban,
      startDate: _startDate,
      endDate: _endDate,
      amount: parsedAmount,
      notes: notes.isNotEmpty ? notes : null,
    );

    final cubit = context.read<SettlementCubit>();
    final success = await cubit.createSettlement(
      request: request,
      providerId: providerId,
    );

    if (!mounted) return;

    if (success) {
      AppSnackBar.showSuccess(LocaleKeys.settlementSuccessMessage.tr());
      widget.onSettlementCompleted();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettlementCubit, SettlementState>(
      listener: (context, state) {
        if (state is SettlementActionError) {
          AppSnackBar.showError(state.message);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.whiteColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.orangeColor
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.handshake_outlined,
                                color: AppColors.orangeColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            TextInAppWidget(
                              text: LocaleKeys.startSettlement.tr(),
                              textSize: 18,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                              textColor: AppColors.darkColor,
                            ),
                          ],
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.darkGreyColor,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.cardStroke, height: 1),
                    const SizedBox(height: 18),

                    // Balance overview pill
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardStroke),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextInAppWidget(
                                text: LocaleKeys.serviceProvider.tr(),
                                textSize: 11,
                                textColor: AppColors.greyColor,
                              ),
                              const SizedBox(height: 2),
                              TextInAppWidget(
                                text: widget.providerDetailsRequest.name ??
                                    '#${widget.providerDetailsRequest.id}',
                                textSize: 13,
                                fontWeightIndex:
                                    FontSelectionData.boldFontFamily,
                                textColor: AppColors.darkColor,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextInAppWidget(
                                text: LocaleKeys.netBalance.tr(),
                                textSize: 11,
                                textColor: AppColors.greyColor,
                              ),
                              const SizedBox(height: 2),
                              TextInAppWidget(
                                text:
                                    '${widget.currentBalance.toStringAsFixed(2)} ${LocaleKeys.sarCurrency.tr()}',
                                textSize: 14,
                                fontWeightIndex:
                                    FontSelectionData.boldFontFamily,
                                textColor: AppColors.orangeColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 1. IBAN Input Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextInAppWidget(
                          text: LocaleKeys.bankIbanNumber.tr(),
                          textSize: 13,
                          fontWeightIndex: FontSelectionData.boldFontFamily,
                          textColor: AppColors.darkColor,
                        ),
                        if (_hasRegisteredIban ||
                            _ibanController.text.trim().isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.greenColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 13,
                                  color: AppColors.greenColor,
                                ),
                                const SizedBox(width: 4),
                                TextInAppWidget(
                                  text: LocaleKeys.registeredWithProvider.tr(),
                                  textSize: 11,
                                  textColor: AppColors.greenColor,
                                  fontWeightIndex:
                                      FontSelectionData.boldFontFamily,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormFieldWidget(
                      textFormController: _ibanController,
                      hintText: 'SA00 0000 0000 0000 0000 0000',
                      isColumn: true,
                      fillColor: AppColors.scaffoldColor,
                      borderColor: AppColors.cardStroke,
                      focusBorderColor: AppColors.orangeColor,
                      enabledBorderRadius: BorderRadius.circular(10),
                      focusedBorderRadius: BorderRadius.circular(10),
                      textFormHeight: 46,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      isValidator: true,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return LocaleKeys.ibanRequired.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 2. Period Pickers (From / To)
                    TextInAppWidget(
                      text: LocaleKeys.settlementPeriodOrdersIncluded.tr(),
                      textSize: 13,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: InkWell(
                              onTap: _pickStartDate,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 46,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.scaffoldColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.cardStroke),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 16,
                                      color: AppColors.orangeColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextInAppWidget(
                                        text: _startDate != null
                                            ? OrderFunctions
                                                .formatDateFromDateTime(
                                                _startDate,
                                              )
                                            : LocaleKeys.fromPeriod.tr(),
                                        textSize: 12,
                                        textColor: _startDate != null
                                            ? AppColors.darkColor
                                            : AppColors.darkGreyColor,
                                      ),
                                    ),
                                    if (_startDate != null)
                                      GestureDetector(
                                        onTap: () =>
                                            setState(() => _startDate = null),
                                        child: const Icon(
                                          Icons.clear,
                                          size: 14,
                                          color: AppColors.greyColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: InkWell(
                              onTap: _pickEndDate,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 46,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.scaffoldColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.cardStroke),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.event_available_outlined,
                                      size: 16,
                                      color: AppColors.orangeColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextInAppWidget(
                                        text: _endDate != null
                                            ? OrderFunctions
                                                .formatDateFromDateTime(
                                                _endDate,
                                              )
                                            : LocaleKeys.toPeriod.tr(),
                                        textSize: 12,
                                        textColor: _endDate != null
                                            ? AppColors.darkColor
                                            : AppColors.darkGreyColor,
                                      ),
                                    ),
                                    if (_endDate != null)
                                      GestureDetector(
                                        onTap: () =>
                                            setState(() => _endDate = null),
                                        child: const Icon(
                                          Icons.clear,
                                          size: 14,
                                          color: AppColors.greyColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 3. Amount Input Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextInAppWidget(
                          text: LocaleKeys.settlementAmountSar.tr(),
                          textSize: 13,
                          fontWeightIndex: FontSelectionData.boldFontFamily,
                          textColor: AppColors.darkColor,
                        ),
                        if (widget.currentBalance > 0)
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _amountController.text =
                                      widget.currentBalance.toStringAsFixed(2);
                                });
                              },
                              child: TextInAppWidget(
                                text: LocaleKeys.useFullBalance.tr(),
                                textSize: 11,
                                textColor: AppColors.orangeColor,
                                fontWeightIndex:
                                    FontSelectionData.boldFontFamily,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormFieldWidget(
                      textFormController: _amountController,
                      hintText: LocaleKeys.enterSettlementAmountHint.tr(),
                      isColumn: true,
                      fillColor: AppColors.scaffoldColor,
                      borderColor: AppColors.cardStroke,
                      focusBorderColor: AppColors.orangeColor,
                      enabledBorderRadius: BorderRadius.circular(10),
                      focusedBorderRadius: BorderRadius.circular(10),
                      textFormHeight: 46,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      isDigitDot: true,
                      isValidator: true,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return LocaleKeys.enterSettlementAmountRequired.tr();
                        }
                        final num = double.tryParse(val.trim());
                        if (num == null || num <= 0) {
                          return LocaleKeys.enterValidSettlementAmount.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 4. Notes Input Section
                    TextInAppWidget(
                      text: LocaleKeys.operationNotesOptional.tr(),
                      textSize: 13,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                    const SizedBox(height: 8),
                    TextFormFieldWidget(
                      textFormController: _notesController,
                      hintText: LocaleKeys.settlementNotesHint.tr(),
                      isColumn: true,
                      fillColor: AppColors.scaffoldColor,
                      borderColor: AppColors.cardStroke,
                      focusBorderColor: AppColors.orangeColor,
                      enabledBorderRadius: BorderRadius.circular(10),
                      focusedBorderRadius: BorderRadius.circular(10),
                      textFormHeight: 74,
                      maxLines: 2,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    BlocBuilder<SettlementCubit, SettlementState>(
                      builder: (context, state) {
                        final isLoading = state is SettlementActionLoading;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: OutlinedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(
                                    color: AppColors.cardStroke,
                                  ),
                                ),
                                child: TextInAppWidget(
                                  text: LocaleKeys.cancel.tr(),
                                  textSize: 13,
                                  textColor: AppColors.darkGreyColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _submitSettlement,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.orangeColor,
                                  foregroundColor: AppColors.whiteColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.whiteColor,
                                        ),
                                      )
                                    : TextInAppWidget(
                                        text: LocaleKeys.confirmSettlement.tr(),
                                        textSize: 14,
                                        fontWeightIndex:
                                            FontSelectionData.boldFontFamily,
                                        textColor: AppColors.whiteColor,
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
          ),
        ),
      ),
    );
  }
}
