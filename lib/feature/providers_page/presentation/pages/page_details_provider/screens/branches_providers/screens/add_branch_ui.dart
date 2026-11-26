import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/detail_section_card.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/feature/providers_page/data/model/facility_provider_model/get_provider_branches_model/provider_branch_model.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/branches_providers/screens/square_map_provider_widget.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/branch_cubit/branch_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/branch_cubit/branch_state.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/location_provider_cubit/location_provider_cubit.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class AddBranchUI extends StatefulWidget {
  final int providerId;

  const AddBranchUI({super.key, required this.providerId});

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
  void dispose() {
    nationalAddressController.dispose();
    nameController.dispose();
    latinController.dispose();
    addressTextController.dispose();
    addressLatinController.dispose();
    searchTheMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BranchCubit, BranchState>(
      listener: (context, state) {
        if (state is BranchSuccess && state.fromSubmit) {
          AppSnackBar.showSuccess(LocaleKeys.success);
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
          nationalAddressController.text = branch.nationalAddress ?? '';
          nameController.text = branch.branchName ?? '';
          latinController.text = branch.branchLatinName ?? '';
          addressTextController.text = branch.addressText ?? '';
          addressLatinController.text = branch.addressLatinText ?? '';
          searchTheMapController.text =
              "${branch.lat ?? ''}, ${branch.long ?? ''}";

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

        final branchTitle =
            (branch?.branchName != null && branch!.branchName!.isNotEmpty)
                ? branch.branchName!
                : (branch?.branchLatinName ?? LocaleKeys.branchName.tr());

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BranchDetailsHeaderBar(
                branchTitle: branchTitle,
                onBack: () {
                  isInit = false;
                  context.read<BranchCubit>().back();
                },
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 950;

                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 11,
                          child: BranchInfoFormCard(
                            nameController: nameController,
                            latinController: latinController,
                            addressTextController: addressTextController,
                            addressLatinController: addressLatinController,
                            nationalAddressController:
                                nationalAddressController,
                            searchTheMapController: searchTheMapController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 9,
                          child: BranchMapPreviewCard(
                            coordinatesText: searchTheMapController.text,
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      BranchInfoFormCard(
                        nameController: nameController,
                        latinController: latinController,
                        addressTextController: addressTextController,
                        addressLatinController: addressLatinController,
                        nationalAddressController: nationalAddressController,
                        searchTheMapController: searchTheMapController,
                      ),
                      const SizedBox(height: 16),
                      BranchMapPreviewCard(
                        coordinatesText: searchTheMapController.text,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class BranchDetailsHeaderBar extends StatelessWidget {
  final String branchTitle;
  final VoidCallback onBack;

  const BranchDetailsHeaderBar({
    super.key,
    required this.branchTitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGreyColor),
      ),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: AppColors.orangeColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      LocaleKeys.branches.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.orangeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 20,
            width: 1,
            color: AppColors.lightGreyColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              branchTitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class BranchInfoFormCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController latinController;
  final TextEditingController addressTextController;
  final TextEditingController addressLatinController;
  final TextEditingController nationalAddressController;
  final TextEditingController searchTheMapController;

  const BranchInfoFormCard({
    super.key,
    required this.nameController,
    required this.latinController,
    required this.addressTextController,
    required this.addressLatinController,
    required this.nationalAddressController,
    required this.searchTheMapController,
  });

  @override
  Widget build(BuildContext context) {
    return DetailSectionCard(
      title: LocaleKeys.branchName.tr(),
      icon: Icons.store_mall_directory_rounded,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMultiColumn = constraints.maxWidth >= 550;

          if (isMultiColumn) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: UserTextFieldWidget(
                        controller: nameController,
                        text: LocaleKeys.branchName,
                        readOnly: true,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: UserTextFieldWidget(
                        controller: latinController,
                        text: LocaleKeys.branchLatinName,
                        readOnly: true,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: UserTextFieldWidget(
                        controller: addressTextController,
                        text: LocaleKeys.addressText,
                        readOnly: true,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: UserTextFieldWidget(
                        controller: addressLatinController,
                        text: LocaleKeys.addressLatinText,
                        readOnly: true,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: UserTextFieldWidget(
                        controller: nationalAddressController,
                        text: LocaleKeys.branchNationalAddress,
                        readOnly: true,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: UserTextFieldWidget(
                        controller: searchTheMapController,
                        text: LocaleKeys.searchTheMap,
                        readOnly: true,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserTextFieldWidget(
                controller: nameController,
                text: LocaleKeys.branchName,
                readOnly: true,
                width: double.infinity,
              ),
              const SizedBox(height: 12),
              UserTextFieldWidget(
                controller: latinController,
                text: LocaleKeys.branchLatinName,
                readOnly: true,
                width: double.infinity,
              ),
              const SizedBox(height: 12),
              UserTextFieldWidget(
                controller: addressTextController,
                text: LocaleKeys.addressText,
                readOnly: true,
                width: double.infinity,
              ),
              const SizedBox(height: 12),
              UserTextFieldWidget(
                controller: addressLatinController,
                text: LocaleKeys.addressLatinText,
                readOnly: true,
                width: double.infinity,
              ),
              const SizedBox(height: 12),
              UserTextFieldWidget(
                controller: nationalAddressController,
                text: LocaleKeys.branchNationalAddress,
                readOnly: true,
                width: double.infinity,
              ),
              const SizedBox(height: 12),
              UserTextFieldWidget(
                controller: searchTheMapController,
                text: LocaleKeys.searchTheMap,
                readOnly: true,
                width: double.infinity,
              ),
            ],
          );
        },
      ),
    );
  }
}

class BranchMapPreviewCard extends StatelessWidget {
  final String coordinatesText;

  const BranchMapPreviewCard({
    super.key,
    required this.coordinatesText,
  });

  @override
  Widget build(BuildContext context) {
    final hasCoords = coordinatesText.trim().isNotEmpty &&
        coordinatesText.trim() != ',' &&
        coordinatesText.trim() != '0, 0';

    return DetailSectionCard(
      title: LocaleKeys.confirmBranchLocationKey.tr(),
      icon: Icons.location_on_outlined,
      trailing: hasCoords
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.orangeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.orangeColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.my_location_rounded,
                    size: 13,
                    color: AppColors.orangeColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    coordinatesText.trim(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.orangeColor,
                    ),
                  ),
                ],
              ),
            )
          : null,
      child: SquareMapProviderWidget(height: 320),
    );
  }
}
