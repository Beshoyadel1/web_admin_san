class CouponsFilterCriteria {
  final bool? isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? datePreset;

  const CouponsFilterCriteria({
    this.isActive,
    this.startDate,
    this.endDate,
    this.datePreset,
  });

  bool get isEmpty =>
      isActive == null && startDate == null && endDate == null;

  bool get isNotEmpty => !isEmpty;

  int get activeFiltersCount {
    int count = 0;
    if (isActive != null) count++;
    if (startDate != null || endDate != null) count++;
    return count;
  }

  CouponsFilterCriteria copyWith({
    bool? isActive,
    bool clearIsActive = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? datePreset,
    bool clearDatePreset = false,
  }) {
    return CouponsFilterCriteria(
      isActive: clearIsActive ? null : (isActive ?? this.isActive),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      datePreset: clearDatePreset ? null : (datePreset ?? this.datePreset),
    );
  }

  static const CouponsFilterCriteria empty = CouponsFilterCriteria();
}
