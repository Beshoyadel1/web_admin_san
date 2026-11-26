import 'package:equatable/equatable.dart';
import '../data/model/car_approval_request_details_model.dart';
import '../data/model/car_approval_request_item_model.dart';

enum CarApprovalListStatus { initial, loading, success, error }

class CarApprovalState extends Equatable {
  final CarApprovalListStatus listStatus;
  final List<CarApprovalRequestItemModel> requests;
  final int totalCount;
  final int pageCount;
  final int currentPage;
  final int?
      selectedStatus; // 1 = Pending, 2 = Approved, 3 = Rejected, null = All
  final int? selectedRequestType; // 1 = Create, 2 = Update, null = All
  final String searchTerm;
  final int pendingCount;
  final String? errorMessage;

  // Actions (Approve / Reject)
  final bool isActionLoading;
  final String? actionSuccessMessage;
  final String? actionErrorMessage;

  // Details Modal
  final bool isLoadingDetails;
  final CarApprovalRequestDetailsModel? selectedDetails;
  final String? detailsErrorMessage;

  const CarApprovalState({
    this.listStatus = CarApprovalListStatus.initial,
    this.requests = const [],
    this.totalCount = 0,
    this.pageCount = 0,
    this.currentPage = 1,
    this.selectedStatus = 1, // Default to Pending
    this.selectedRequestType,
    this.searchTerm = '',
    this.pendingCount = 0,
    this.errorMessage,
    this.isActionLoading = false,
    this.actionSuccessMessage,
    this.actionErrorMessage,
    this.isLoadingDetails = false,
    this.selectedDetails,
    this.detailsErrorMessage,
  });

  CarApprovalState copyWith({
    CarApprovalListStatus? listStatus,
    List<CarApprovalRequestItemModel>? requests,
    int? totalCount,
    int? pageCount,
    int? currentPage,
    int? selectedStatus,
    bool clearStatus = false,
    int? selectedRequestType,
    bool clearRequestType = false,
    String? searchTerm,
    int? pendingCount,
    String? errorMessage,
    bool clearError = false,
    bool? isActionLoading,
    String? actionSuccessMessage,
    bool clearActionSuccess = false,
    String? actionErrorMessage,
    bool clearActionError = false,
    bool? isLoadingDetails,
    CarApprovalRequestDetailsModel? selectedDetails,
    bool clearDetails = false,
    String? detailsErrorMessage,
    bool clearDetailsError = false,
  }) {
    return CarApprovalState(
      listStatus: listStatus ?? this.listStatus,
      requests: requests ?? this.requests,
      totalCount: totalCount ?? this.totalCount,
      pageCount: pageCount ?? this.pageCount,
      currentPage: currentPage ?? this.currentPage,
      selectedStatus:
          clearStatus ? null : (selectedStatus ?? this.selectedStatus),
      selectedRequestType: clearRequestType
          ? null
          : (selectedRequestType ?? this.selectedRequestType),
      searchTerm: searchTerm ?? this.searchTerm,
      pendingCount: pendingCount ?? this.pendingCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isActionLoading: isActionLoading ?? this.isActionLoading,
      actionSuccessMessage: clearActionSuccess
          ? null
          : (actionSuccessMessage ?? this.actionSuccessMessage),
      actionErrorMessage: clearActionError
          ? null
          : (actionErrorMessage ?? this.actionErrorMessage),
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      selectedDetails:
          clearDetails ? null : (selectedDetails ?? this.selectedDetails),
      detailsErrorMessage: clearDetailsError
          ? null
          : (detailsErrorMessage ?? this.detailsErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
        listStatus,
        requests,
        totalCount,
        pageCount,
        currentPage,
        selectedStatus,
        selectedRequestType,
        searchTerm,
        pendingCount,
        errorMessage,
        isActionLoading,
        actionSuccessMessage,
        actionErrorMessage,
        isLoadingDetails,
        selectedDetails,
        detailsErrorMessage,
      ];
}
