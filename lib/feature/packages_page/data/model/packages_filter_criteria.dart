class PackagesFilterCriteria {
  final double? minPrice;
  final double? maxPrice;
  final String? billingType; // 'all', 'monthly', 'annual'

  const PackagesFilterCriteria({
    this.minPrice,
    this.maxPrice,
    this.billingType,
  });

  bool get isEmpty =>
      minPrice == null &&
      maxPrice == null &&
      (billingType == null || billingType == 'all');

  bool get isNotEmpty => !isEmpty;

  int get activeFiltersCount {
    int count = 0;
    if (minPrice != null || maxPrice != null) count++;
    if (billingType != null && billingType != 'all') count++;
    return count;
  }

  PackagesFilterCriteria copyWith({
    double? minPrice,
    bool clearMinPrice = false,
    double? maxPrice,
    bool clearMaxPrice = false,
    String? billingType,
    bool clearBillingType = false,
  }) {
    return PackagesFilterCriteria(
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      billingType:
          clearBillingType ? null : (billingType ?? this.billingType),
    );
  }

  static const PackagesFilterCriteria empty = PackagesFilterCriteria();
}
