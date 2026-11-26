class ApprovedCentersFilterCriteria {
  final bool? isActive;

  const ApprovedCentersFilterCriteria({
    this.isActive,
  });

  bool get isEmpty => isActive == null;

  bool get isNotEmpty => !isEmpty;

  int get activeFiltersCount => isActive != null ? 1 : 0;

  ApprovedCentersFilterCriteria copyWith({
    bool? isActive,
    bool clearIsActive = false,
  }) {
    return ApprovedCentersFilterCriteria(
      isActive: clearIsActive ? null : (isActive ?? this.isActive),
    );
  }

  static const ApprovedCentersFilterCriteria empty =
      ApprovedCentersFilterCriteria();
}
