import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:web_admin_san/core/pages_widgets/text_form_field_widget.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/providers/data/model/facility_provider_model/get_provider_branches_model/provider_branch_model.dart';
import 'package:web_admin_san/features/providers/data/request/facility_provider_request/add_branch_request/add_branch_request.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/branch_cubit/branch_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/branch_cubit/branch_state.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/location_provider_cubit/location_provider_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/location_provider_cubit/location_provider_state.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/branches_providers/screens/square_map_provider_widget.dart';


class AddBranchUI extends StatefulWidget {
  final int providerId;
  const AddBranchUI({super.key,required this.providerId});

  @override
  State<AddBranchUI> createState() => _AddBranchUIState();
}

class _AddBranchUIState extends State<AddBranchUI> {
  final _formKey = GlobalKey<FormState>();

  final nationalAddressController = TextEditingController();
  final nameController = TextEditingController();
  final latinController = TextEditingController();
  final addressTextController = TextEditingController();
  final addressLatinController = TextEditingController();
  final searchTheMapController = TextEditingController();

  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BranchCubit, BranchState>(
      listener: (context, state) {
        if (state is BranchSuccess && state.fromSubmit) {
          AppSnackBar.showSuccess(AppLanguageKeys.success);
          nationalAddressController.clear();
          nameController.clear();
          latinController.clear();
          addressTextController.clear();
          addressLatinController.clear();
          searchTheMapController.clear();
          isInit = false;
        }

        if (state is BranchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is BranchLoading;
        final successState = state is BranchSuccess ? state : null;

        final editingId = successState?.editingBranchId;
        final branches = successState?.branches ?? [];

        ProviderBranchModel? branch;

        if (editingId != null) {
          branch = branches.firstWhere(
                (e) => e.branchId == editingId,
            orElse: () => ProviderBranchModel(),
          );
        }

        if (branch != null && editingId != null && !isInit) {
          nationalAddressController.text =
              branch.nationalAddress ?? '';

          nameController.text =
              branch.branchName ?? '';

          latinController.text =
              branch.branchLatinName ?? '';

          addressTextController.text =
              branch.addressText ?? '';

          addressLatinController.text =
              branch.addressLatinText ?? '';

          searchTheMapController.text =
          "${branch.lat ?? ''}, ${branch.long ?? ''}";

          debugPrint(
            'Lat: ${branch.lat} , Long: ${branch.long}',
          );

          if (branch.lat != null &&
              branch.long != null &&
              branch.lat != 0 &&
              branch.long != 0) {
            context.read<LocationProviderCubit>().setLocation(
              branch.lat!,
              branch.long!,
            );
          }

          isInit = true;
        }

        return Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInAppWidget(
                text: editingId != null
                    ? AppLanguageKeys.editKey
                    : AppLanguageKeys.addMainBranchKey,
                textSize: 20,
              ),

              /// Branch Name
              TextFormFieldWidget(
                readOnly: true,
                textFormController: nameController,
                text: AppLanguageKeys.branchName,
                hintText: AppLanguageKeys.branchName,
                isColumn: true,
                textSize: 16,
                textColor: AppColors.darkColor,
                borderColor: AppColors.darkGreyColor,
                fillColor: AppColors.whiteColor,
                textFormHeight: 35,
                validator: (value) =>
                value == null || value.isEmpty
                    ? AppLanguageKeys.enterYourData
                    : null,
              ),

              /// Latin Name
              TextFormFieldWidget(
                readOnly: true,
                textFormController: latinController,
                text: AppLanguageKeys.branchLatinName,
                hintText: AppLanguageKeys.branchLatinName,
                isColumn: true,
                textSize: 16,
                textColor: AppColors.darkColor,
                borderColor: AppColors.darkGreyColor,
                fillColor: AppColors.whiteColor,
                textFormHeight: 35,
                validator: (value) =>
                value == null || value.isEmpty
                    ? AppLanguageKeys.enterYourData
                    : null,
              ),

              /// Address Text
              TextFormFieldWidget(
                readOnly: true,
                textFormController: addressTextController,
                text: AppLanguageKeys.addressText,
                hintText: AppLanguageKeys.addressText,
                isColumn: true,
                textSize: 16,
                textColor: AppColors.darkColor,
                borderColor: AppColors.darkGreyColor,
                fillColor: AppColors.whiteColor,
                textFormHeight: 35,
                validator: (value) =>
                value == null || value.isEmpty
                    ? AppLanguageKeys.enterYourData
                    : null,
              ),

              /// Address Latin
              TextFormFieldWidget(
                readOnly: true,
                textFormController: addressLatinController,
                text: AppLanguageKeys.addressLatinText,
                hintText: AppLanguageKeys.addressLatinText,
                isColumn: true,
                textSize: 16,
                textColor: AppColors.darkColor,
                borderColor: AppColors.darkGreyColor,
                fillColor: AppColors.whiteColor,
                textFormHeight: 35,
                validator: (value) =>
                value == null || value.isEmpty
                    ? AppLanguageKeys.enterYourData
                    : null,
              ),

              TextFormFieldWidget(
                readOnly: true,
                textFormController: nationalAddressController,
                text: AppLanguageKeys.branchNationalAddress ,
                hintText: AppLanguageKeys.branchNationalAddress ,
                isColumn: true,
                textSize: 16,
                textColor: AppColors.darkColor,
                borderColor: AppColors.darkGreyColor,
                fillColor: AppColors.whiteColor,
                textFormHeight: 35,
                maxLength: 8,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLanguageKeys.enterYourData;
                  }

                  if (value.trim().length != 8) {
                    return AppLanguageKeys.nationalAddressMustBe8CharactersAndDigits;
                  }

                  return null;
                },
              ),

              /// Address
              TextFormFieldWidget(
                readOnly: true,
                textFormController: searchTheMapController,
                text: AppLanguageKeys.searchTheMap,
                hintText: AppLanguageKeys.searchTheMap,
                isColumn: true,
                textSize: 16,
                textColor: AppColors.darkColor,
                borderColor: AppColors.darkGreyColor,
                fillColor: AppColors.whiteColor,
                textFormHeight: 35,
                validator: (value) =>
                value == null || value.isEmpty
                    ? AppLanguageKeys.enterYourData
                    : null,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    context
                        .read<LocationProviderCubit>()
                        .searchLocation(value.trim());
                  }
                },
              ),

              const TextInAppWidget(
                text: AppLanguageKeys.confirmBranchLocationKey,
                textSize: 18,
              ),

              SizedBox(
                height: 370,
                width: 408,
                child: SquareMapProviderWidget(),
              ),

              /// Buttons
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  // CustomContainer(
                  //   isSelected: false,
                  //   onTap: isLoading
                  //       ? null
                  //       : () {
                  //     if (nationalAddressController.text.trim().length != 8) {
                  //       AppSnackBar.showError(
                  //         AppLanguageKeys.nationalAddressMustBe8CharactersAndDigits,
                  //       );
                  //       return;
                  //     }
                  //     if (!_formKey.currentState!.validate()) {
                  //       AppSnackBar.showError(
                  //           AppLanguageKeys.enterYourData);
                  //       return;
                  //     }
                  //     final locationState =
                  //         context.read<LocationProviderCubit>().state;
                  //
                  //     if (locationState is! LocationLoaded) {
                  //       AppSnackBar.showError(
                  //           AppLanguageKeys.enterYourData);
                  //       return;
                  //     }
                  //
                  //     /// ✅ EDIT
                  //     if (editingId != null && branch != null) {
                  //       final request = AddBranchRequest(
                  //         branchId: branch.branchId,
                  //         branchName: nameController.text,
                  //         branchLatinName: latinController.text,
                  //         lat: locationState.latLng.latitude,
                  //         long: locationState.latLng.longitude,
                  //         addressText: addressTextController.text,
                  //         addressLatinText: addressLatinController.text,
                  //         nationalAddress: nationalAddressController.text,
                  //         isActive: branch.isActive ?? true,
                  //       );
                  //       context
                  //           .read<BranchCubit>()
                  //           .updateBranch(providerId:widget.providerId,request);
                  //     }
                  //
                  //     else {
                  //       final request = AddBranchRequest(
                  //         branchName: nameController.text,
                  //         branchLatinName: latinController.text,
                  //         lat: locationState.latLng.latitude,
                  //         long: locationState.latLng.longitude,
                  //         addressText: addressTextController.text,
                  //         addressLatinText: addressLatinController.text,
                  //         nationalAddress: nationalAddressController.text,
                  //         isActive: true,
                  //       );
                  //
                  //       context
                  //           .read<BranchCubit>()
                  //           .addBranch(providerId:widget.providerId,request);
                  //     }
                  //   },
                  //   typeWidget: isLoading
                  //       ? const SizedBox(
                  //     height: 20,
                  //     width: 20,
                  //     child: CircularProgressIndicator(
                  //       strokeWidth: 2,
                  //       color: Colors.white,
                  //     ),
                  //   )
                  //       : TextInAppWidget(
                  //     text: editingId != null
                  //         ? AppLanguageKeys.editKey
                  //         : AppLanguageKeys.saveKey,
                  //     textSize: 16,
                  //     textColor: AppColors.whiteColor,
                  //   ),
                  //   containerColor: AppColors.orangeColor,
                  // ),

                  CustomContainer(
                    isSelected: false,
                    onTap: () {
                      isInit = false;
                      context.read<BranchCubit>().back();
                    },
                    text: AppLanguageKeys.cancel,
                    containerColor: AppColors.blackColor,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}