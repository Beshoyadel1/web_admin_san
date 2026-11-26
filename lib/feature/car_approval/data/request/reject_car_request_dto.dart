class RejectCarRequestDto {
  final int requestId;
  final String rejectionReason;
  final int? adminId;

  const RejectCarRequestDto({
    required this.requestId,
    required this.rejectionReason,
    this.adminId,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'rejectionReason': rejectionReason,
      if (adminId != null) 'adminId': adminId,
    };
  }
}
