class GetAllCompaniesRequest {
  final int? pageNumber;

  GetAllCompaniesRequest({
    this.pageNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "pageNumber": pageNumber??1,
    };
  }
}