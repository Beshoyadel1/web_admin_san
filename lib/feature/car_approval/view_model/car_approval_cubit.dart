import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/networking/local_services.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../data/datasource/car_approval_datasource.dart';
import '../data/request/reject_car_request_dto.dart';
import 'car_approval_state.dart';

class CarApprovalCubit extends Cubit<CarApprovalState> {
  final CarApprovalDatasource datasource;

  CarApprovalCubit({
    this.datasource = const CarApprovalDatasource(),
  }) : super(const CarApprovalState());

  /// Fetches paginated car approval requests.
  Future<void> fetchRequests({int? page, bool silent = false}) async {
    final targetPage = page ?? state.currentPage;

    if (!silent) {
      emit(state.copyWith(
        listStatus: CarApprovalListStatus.loading,
        clearError: true,
      ));
    }

    try {
      final response = await datasource.getPendingRequests(
        status: state.selectedStatus,
        requestType: state.selectedRequestType,
        searchTerm: state.searchTerm,
        pageNumber: targetPage,
        pageSize: 10,
      );

      if (isClosed) return;

      int updatedPendingCount = state.pendingCount;
      if (state.selectedStatus == 1) {
        updatedPendingCount = response.totalCount;
      }

      emit(state.copyWith(
        listStatus: CarApprovalListStatus.success,
        requests: response.data,
        totalCount: response.totalCount,
        pageCount: response.pageCount,
        currentPage: response.currentPage,
        pendingCount: updatedPendingCount,
        clearError: true,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        listStatus: CarApprovalListStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Changes the status tab filter (1: Pending, 2: Approved, 3: Rejected, null: All).
  void changeStatusFilter(int? status) {
    if (state.selectedStatus == status &&
        state.listStatus == CarApprovalListStatus.success) {
      return;
    }

    if (status == null) {
      emit(state.copyWith(
        clearStatus: true,
        currentPage: 1,
      ));
    } else {
      emit(state.copyWith(
        selectedStatus: status,
        currentPage: 1,
      ));
    }

    fetchRequests(page: 1);
  }

  /// Changes the request type filter (1: Create, 2: Update, null: All).
  void changeRequestTypeFilter(int? requestType) {
    if (state.selectedRequestType == requestType) return;

    if (requestType == null) {
      emit(state.copyWith(
        clearRequestType: true,
        currentPage: 1,
      ));
    } else {
      emit(state.copyWith(
        selectedRequestType: requestType,
        currentPage: 1,
      ));
    }

    fetchRequests(page: 1);
  }

  /// Updates search query with debounce or direct submission.
  void setSearchTerm(String term) {
    final cleanTerm = term.trim();
    if (state.searchTerm == cleanTerm) return;

    emit(state.copyWith(
      searchTerm: cleanTerm,
      currentPage: 1,
    ));

    fetchRequests(page: 1);
  }

  /// Clears the search field and reloads.
  void clearSearch() {
    if (state.searchTerm.isEmpty) return;
    emit(state.copyWith(searchTerm: '', currentPage: 1));
    fetchRequests(page: 1);
  }

  /// Loads full inspection details for a car request.
  Future<void> loadRequestDetails(int requestId) async {
    emit(state.copyWith(
      isLoadingDetails: true,
      clearDetailsError: true,
    ));

    try {
      final details = await datasource.getRequestDetails(requestId: requestId);

      if (isClosed) return;

      emit(state.copyWith(
        isLoadingDetails: false,
        selectedDetails: details,
        clearDetailsError: true,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        isLoadingDetails: false,
        detailsErrorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Clears selected details when modal is dismissed.
  void clearSelectedDetails() {
    emit(state.copyWith(clearDetails: true, clearDetailsError: true));
  }

  /// Approves a pending car request.
  Future<bool> approveRequest(int requestId) async {
    emit(state.copyWith(
      isActionLoading: true,
      clearActionSuccess: true,
      clearActionError: true,
    ));

    try {
      final user = await AuthLocalStorage.getUser();
      final adminId = user?.userid;

      final successMessage = await datasource.approveRequest(
        requestId: requestId,
        adminId: adminId,
      );

      if (isClosed) return false;

      emit(state.copyWith(
        isActionLoading: false,
        actionSuccessMessage: successMessage,
        clearDetails: true,
      ));

      // Refresh list to reflect updated status
      await fetchRequests(silent: true);
      return true;
    } catch (e) {
      if (isClosed) return false;
      emit(state.copyWith(
        isActionLoading: false,
        actionErrorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
      return false;
    }
  }

  /// Rejects a pending car request with a mandatory rejection reason.
  Future<bool> rejectRequest({
    required int requestId,
    required String rejectionReason,
  }) async {
    final cleanReason = rejectionReason.trim();
    if (cleanReason.isEmpty) {
      emit(state.copyWith(
        actionErrorMessage: LocaleKeys.rejectionReasonRequiredError.tr(),
      ));
      return false;
    }

    emit(state.copyWith(
      isActionLoading: true,
      clearActionSuccess: true,
      clearActionError: true,
    ));

    try {
      final user = await AuthLocalStorage.getUser();
      final adminId = user?.userid;

      final successMessage = await datasource.rejectRequest(
        request: RejectCarRequestDto(
          requestId: requestId,
          rejectionReason: cleanReason,
          adminId: adminId,
        ),
      );

      if (isClosed) return false;

      emit(state.copyWith(
        isActionLoading: false,
        actionSuccessMessage: successMessage,
        clearDetails: true,
      ));

      // Refresh list to reflect updated status
      await fetchRequests(silent: true);
      return true;
    } catch (e) {
      if (isClosed) return false;
      emit(state.copyWith(
        isActionLoading: false,
        actionErrorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
      return false;
    }
  }

  /// Handles incoming FCM notification for new car approval requests.
  Future<void> onIncomingCarApprovalNotification({
    required int requestId,
    bool autoOpen = false,
  }) async {
    // Increment pending count in memory for immediate UI responsiveness
    emit(state.copyWith(pendingCount: state.pendingCount + 1));

    // Silently refresh requests table
    await fetchRequests(silent: true);

    if (autoOpen && requestId > 0) {
      await loadRequestDetails(requestId);
    }
  }

  /// Clears action toast/snackbar messages.
  void clearActionMessages() {
    emit(state.copyWith(
      clearActionSuccess: true,
      clearActionError: true,
    ));
  }
}
