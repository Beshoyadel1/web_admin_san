class GetHarageProvidersRequest {
  final int? pageNumber;

  GetHarageProvidersRequest({
     this.pageNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "pageNumber": pageNumber??1,
    };
  }
}