class GetUserDetailsRequest {
  final int userId;

  const GetUserDetailsRequest({
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
    };
  }
}