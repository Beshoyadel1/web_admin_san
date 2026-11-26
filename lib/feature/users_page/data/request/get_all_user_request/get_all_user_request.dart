class GetAllUserRequest {
  final int? pageNumber;
  final String? searchTerm;
  final bool? isActive;
  final DateTime? startDate;
  final DateTime? endDate;

  GetAllUserRequest({
    this.pageNumber,
    this.searchTerm,
    this.isActive,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "pageNumber": pageNumber ?? 1,
      if (searchTerm != null && searchTerm!.trim().isNotEmpty)
        "searchTerm": searchTerm!.trim(),
      if (isActive != null) "isActive": isActive,
      if (startDate != null) "startDate": startDate!.toUtc().toIso8601String(),
      if (endDate != null) "endDate": endDate!.toUtc().toIso8601String(),
    };
  }
}
