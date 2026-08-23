class GetApprovalInfoByIdRequest {
  final int id;

  const GetApprovalInfoByIdRequest({
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}