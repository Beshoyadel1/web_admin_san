class GetAllHaragesRequest {
  final int pageNumber;
  final bool? isNew;
  final int? status;
  final bool? includeSuspended;
  final String? search;
  final double? minPrice;
  final double? maxPrice;

  GetAllHaragesRequest({
    required this.pageNumber,
    this.isNew,
    this.status,
    this.includeSuspended,
    this.search,
    this.minPrice,
    this.maxPrice,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'pageNumber': pageNumber,
    };
    if (isNew != null) {
      map['isNew'] = isNew;
    }
    if (status != null) {
      map['status'] = status;
    }
    if (includeSuspended != null) {
      map['includeSuspended'] = includeSuspended;
    }
    if (search != null && search!.trim().isNotEmpty) {
      map['search'] = search!.trim();
    }
    if (minPrice != null) {
      map['minPrice'] = minPrice;
    }
    if (maxPrice != null) {
      map['maxPrice'] = maxPrice;
    }
    return map;
  }
}
