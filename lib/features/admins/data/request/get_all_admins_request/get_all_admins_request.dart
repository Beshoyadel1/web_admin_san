class GetAllAdminsRequest {
  final int pageNumber;
  const GetAllAdminsRequest({
    this.pageNumber = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
    };
  }
}