import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/di/sl.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/app_pagination.dart';
import 'package:web_admin_san/core/widgets/empty_state_view.dart';
import 'package:web_admin_san/core/widgets/error_state_view.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../view_model/car_approval_cubit.dart';
import '../../view_model/car_approval_state.dart';
import '../custom_widget/car_approval_filter_tabs.dart';
import '../custom_widget/car_approval_mobile_card.dart';
import '../custom_widget/car_approval_table.dart';
import '../custom_widget/car_request_inspection_dialog.dart';

class CarApprovalPage extends StatelessWidget {
  const CarApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CarApprovalCubit>()..fetchRequests(),
      child: const CarApprovalView(),
    );
  }
}

class CarApprovalView extends StatefulWidget {
  const CarApprovalView({super.key});

  @override
  State<CarApprovalView> createState() => _CarApprovalViewState();
}

class _CarApprovalViewState extends State<CarApprovalView> {
  bool _isInspectionDialogShowing = false;

  Future<void> _openInspectionDialog(int requestId) async {
    if (_isInspectionDialogShowing) return;
    _isInspectionDialogShowing = true;
    final cubit = context.read<CarApprovalCubit>();
    if (cubit.state.selectedDetails?.requestId != requestId) {
      cubit.loadRequestDetails(requestId);
    }
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: CarRequestInspectionDialog(requestId: requestId),
      ),
    );
    _isInspectionDialogShowing = false;
    cubit.clearSelectedDetails();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile =
        MediaQuery.of(context).size.width < ValuesOfAllApp.mobileWidth;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<CarApprovalCubit, CarApprovalState>(
            listener: (context, state) {
              if (state.selectedDetails != null &&
                  !_isInspectionDialogShowing) {
                _openInspectionDialog(state.selectedDetails!.requestId);
              }
            },
            builder: (context, state) {
              final cubit = context.read<CarApprovalCubit>();

              return RefreshIndicator(
                color: AppColors.orangeColor,
                onRefresh: () => cubit.fetchRequests(silent: false),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Filter Tabs (Status + Request Type)
                    CarApprovalFilterTabs(
                      selectedStatus: state.selectedStatus,
                      selectedRequestType: state.selectedRequestType,
                      pendingCount: state.pendingCount,
                      onStatusChanged: (status) =>
                          cubit.changeStatusFilter(status),
                      onRequestTypeChanged: (type) =>
                          cubit.changeRequestTypeFilter(type),
                    ),
                    const SizedBox(height: 16),

                    // Content Area (Table or Cards based on screen width)
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (state.listStatus ==
                                  CarApprovalListStatus.loading &&
                              state.requests.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                      color: AppColors.orangeColor),
                                  const SizedBox(height: 12),
                                  Text(
                                    LocaleKeys.loadingCarApprovals.tr(),
                                    style: const TextStyle(
                                        color: AppColors.darkGreyColor),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state.listStatus == CarApprovalListStatus.error &&
                              state.requests.isEmpty) {
                            return ErrorStateView(
                              message: state.errorMessage ??
                                  LocaleKeys.errorLoadingCarApprovals.tr(),
                              onRetry: () => cubit.fetchRequests(),
                            );
                          }

                          if (state.requests.isEmpty) {
                            return const EmptyStateView(
                              message: LocaleKeys.noCarApprovalsFound,
                              icon: Icons.directions_car_outlined,
                            );
                          }

                          if (isMobile) {
                            return ListView.builder(
                              itemCount: state.requests.length,
                              itemBuilder: (context, index) {
                                final item = state.requests[index];
                                return CarApprovalMobileCard(
                                  item: item,
                                  onInspect: () =>
                                      _openInspectionDialog(item.requestId),
                                );
                              },
                            );
                          }

                          return CarApprovalTable(
                            requests: state.requests,
                            onInspect: (item) =>
                                _openInspectionDialog(item.requestId),
                          );
                        },
                      ),
                    ),

                    // Pagination
                    if (state.pageCount > 1) ...[
                      const SizedBox(height: 14),
                      AppPagination(
                        totalPages: state.pageCount,
                        currentPage: state.currentPage,
                        onPageChanged: (page) =>
                            cubit.fetchRequests(page: page),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
