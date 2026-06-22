class GetAllProvidersRequest {
  final int? pageNumber;

  GetAllProvidersRequest({
     this.pageNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "pageNumber": pageNumber??1,
    };
  }
}