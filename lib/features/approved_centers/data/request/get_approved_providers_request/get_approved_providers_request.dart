class GetApprovedProvidersRequest {
  final int pageNumber;

  const GetApprovedProvidersRequest({
    this.pageNumber = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
    };
  }
}