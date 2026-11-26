import 'package:equatable/equatable.dart';
import '../../data/model/delivery_order_model.dart';
import '../../data/model/delivery_setting_model.dart';

enum DeliveryViewStatus { initial, loading, success, error }

class DeliverySettingState extends Equatable {
  final DeliveryViewStatus viewStatus;
  final bool isUpdatingSettings;
  final bool isCancellingOrder;
  final bool isLoadingOrders;
  final DeliveryInfoModel? deliveryInfo;
  final DeliveryOrderPaginatedResponse? ordersResponse;
  final String? selectedStatusFilter;
  final String searchQuery;
  final int currentPage;
  final String? errorMessage;
  final String? successActionMessage;

  const DeliverySettingState({
    this.viewStatus = DeliveryViewStatus.initial,
    this.isUpdatingSettings = false,
    this.isCancellingOrder = false,
    this.isLoadingOrders = false,
    this.deliveryInfo,
    this.ordersResponse,
    this.selectedStatusFilter,
    this.searchQuery = '',
    this.currentPage = 1,
    this.errorMessage,
    this.successActionMessage,
  });

  DeliverySettingState copyWith({
    DeliveryViewStatus? viewStatus,
    bool? isUpdatingSettings,
    bool? isCancellingOrder,
    bool? isLoadingOrders,
    DeliveryInfoModel? deliveryInfo,
    DeliveryOrderPaginatedResponse? ordersResponse,
    String? selectedStatusFilter,
    bool clearStatusFilter = false,
    String? searchQuery,
    int? currentPage,
    String? errorMessage,
    String? successActionMessage,
    bool clearActionMessages = false,
  }) {
    return DeliverySettingState(
      viewStatus: viewStatus ?? this.viewStatus,
      isUpdatingSettings: isUpdatingSettings ?? this.isUpdatingSettings,
      isCancellingOrder: isCancellingOrder ?? this.isCancellingOrder,
      isLoadingOrders: isLoadingOrders ?? this.isLoadingOrders,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      ordersResponse: ordersResponse ?? this.ordersResponse,
      selectedStatusFilter: clearStatusFilter
          ? null
          : (selectedStatusFilter ?? this.selectedStatusFilter),
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      errorMessage:
          clearActionMessages ? null : (errorMessage ?? this.errorMessage),
      successActionMessage: clearActionMessages
          ? null
          : (successActionMessage ?? this.successActionMessage),
    );
  }

  @override
  List<Object?> get props => [
        viewStatus,
        isUpdatingSettings,
        isCancellingOrder,
        isLoadingOrders,
        deliveryInfo,
        ordersResponse,
        selectedStatusFilter,
        searchQuery,
        currentPage,
        errorMessage,
        successActionMessage,
      ];
}
