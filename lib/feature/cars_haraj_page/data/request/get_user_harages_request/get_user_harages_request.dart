class GetUserHaragesRequest {
  final int userId;
  final int userType;
  final int pageNumber;
  final bool? includeSuspended;

  GetUserHaragesRequest({
    required this.userId,
    required this.userType,
    required this.pageNumber,
    this.includeSuspended,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "userId": userId,
      "userType": userType,
      "pageNumber": pageNumber,
    };
    if (includeSuspended != null) {
      map["includeSuspended"] = includeSuspended;
    }
    return map;
  }
}
