class OrdersFilterCriteria {
  final int? orderType;
  final int? userType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? datePreset; // 'today', 'last7days', 'thisMonth', 'custom'

  const OrdersFilterCriteria({
    this.orderType,
    this.userType,
    this.startDate,
    this.endDate,
    this.datePreset,
  });

  bool get isEmpty =>
      orderType == null &&
      userType == null &&
      startDate == null &&
      endDate == null;

  bool get isNotEmpty => !isEmpty;

  int get activeFiltersCount {
    int count = 0;
    if (orderType != null) count++;
    if (userType != null) count++;
    if (startDate != null || endDate != null) count++;
    return count;
  }

  OrdersFilterCriteria copyWith({
    int? orderType,
    bool clearOrderType = false,
    int? userType,
    bool clearUserType = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? datePreset,
    bool clearDatePreset = false,
  }) {
    return OrdersFilterCriteria(
      orderType: clearOrderType ? null : (orderType ?? this.orderType),
      userType: clearUserType ? null : (userType ?? this.userType),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      datePreset: clearDatePreset ? null : (datePreset ?? this.datePreset),
    );
  }

  static const OrdersFilterCriteria empty = OrdersFilterCriteria();
}
