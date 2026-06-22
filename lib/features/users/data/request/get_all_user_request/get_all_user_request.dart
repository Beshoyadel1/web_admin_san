class GetAllUserRequest {
  final int? pageNumber;

  GetAllUserRequest({
     this.pageNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "pageNumber": pageNumber??1,
    };
  }
}