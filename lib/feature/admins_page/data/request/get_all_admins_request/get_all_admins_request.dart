class GetAllAdminsRequest {
  final int pageNumber;
  final String? searchTerm;
  final bool? isActive;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetAllAdminsRequest({
    this.pageNumber = 1,
    this.searchTerm,
    this.isActive,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      if (searchTerm != null && searchTerm!.trim().isNotEmpty)
        'searchTerm': searchTerm!.trim(),
      if (isActive != null) 'isActive': isActive,
      if (startDate != null) 'startDate': startDate!.toUtc().toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toUtc().toIso8601String(),
    };
  }
}
