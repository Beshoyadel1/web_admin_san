import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:web_admin_san/core/language/language_constant.dart';

import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../features/rates/data/request/update_rate_request/update_rate_request.dart';
import '../../../../../../features/rates/presentation/bloc/update_rate_cubit/update_rate_cubit.dart';

class EditRateDialog extends StatefulWidget {
  final int rateId;
  final int orderId;
  final int providerId;
  final int userId;
  final int userType;
  final int serviceId;

  final double currentRate;
  final String currentMessage;

  const EditRateDialog({
    super.key,
    required this.rateId,
    required this.orderId,
    required this.providerId,
    required this.userId,
    required this.userType,
    required this.serviceId,
    required this.currentRate,
    required this.currentMessage,
  });

  @override
  State<EditRateDialog> createState() => _EditRateDialogState();
}

class _EditRateDialogState extends State<EditRateDialog> {
  late double selectedRate;

  @override
  void initState() {
    super.initState();

    selectedRate = widget.currentRate;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateRateCubit, UpdateRateState>(
      listener: (context, state) {
        if (state is UpdateRateSuccess) {
          Navigator.of(context).pop(true);
        }

        if (state is UpdateRateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is UpdateRateLoading;

        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextInAppWidget(
                  text: AppLanguageKeys.edit,
                  textSize: 14,
                  textColor: AppColors.darkColor,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                ),

                const SizedBox(height: 20),

                RatingBar.builder(
                  initialRating: selectedRate,
                  minRating: 1,
                  maxRating: 5,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, index) {
                    return const Icon(
                      Icons.star,
                      color: AppColors.orangeColor,
                    );
                  },
                  onRatingUpdate: (value) {
                    setState(() {
                      selectedRate = value;
                    });
                  },
                ),

                const SizedBox(height: 10),

                TextInAppWidget(
                  text: selectedRate.toStringAsFixed(0),
                  textSize: 16,
                  textColor: AppColors.orangeColor,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                Navigator.pop(context);
              },
              child: const TextInAppWidget(
              text: AppLanguageKeys.cancel,
              textSize: 14,
              textColor: AppColors.blackColor,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              ),
            ),

            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                final request = UpdateRateRequest(
                  id: widget.rateId,
                  orderId: widget.orderId,
                  providerId: widget.providerId,
                  userId: widget.userId,
                  userType: widget.userType,
                  message: widget.currentMessage,
                  rate: selectedRate,
                  serviceId: widget.serviceId,
                );

                context.read<UpdateRateCubit>().updateRate(
                  request: request,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const TextInAppWidget(
                text: AppLanguageKeys.edit,
                textSize: 14,
                textColor: AppColors.whiteColor,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
              ),

            ),
          ],
        );
      },
    );
  }
}
