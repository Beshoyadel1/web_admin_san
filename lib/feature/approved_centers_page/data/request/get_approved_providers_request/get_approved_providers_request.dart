class GetApprovedProvidersRequest {
  final int pageNumber;
  final String? searchTerm;
  final bool? isActive;

  const GetApprovedProvidersRequest({
    this.pageNumber = 1,
    this.searchTerm,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      if (searchTerm != null && searchTerm!.trim().isNotEmpty)
        'searchTerm': searchTerm!.trim(),
      if (isActive != null) 'isActive': isActive,
    };
  }
}
