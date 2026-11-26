class HarajFilterCriteria {
  final int? status;
  final bool? isNew;
  final double? minPrice;
  final double? maxPrice;

  const HarajFilterCriteria({
    this.status,
    this.isNew,
    this.minPrice,
    this.maxPrice,
  });

  bool get isEmpty =>
      status == null && isNew == null && minPrice == null && maxPrice == null;

  bool get isNotEmpty => !isEmpty;

  int get activeFiltersCount {
    int count = 0;
    if (status != null) count++;
    if (isNew != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    return count;
  }

  HarajFilterCriteria copyWith({
    int? status,
    bool clearStatus = false,
    bool? isNew,
    bool clearIsNew = false,
    double? minPrice,
    bool clearMinPrice = false,
    double? maxPrice,
    bool clearMaxPrice = false,
  }) {
    return HarajFilterCriteria(
      status: clearStatus ? null : (status ?? this.status),
      isNew: clearIsNew ? null : (isNew ?? this.isNew),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
    );
  }

  static const HarajFilterCriteria empty = HarajFilterCriteria();
}
