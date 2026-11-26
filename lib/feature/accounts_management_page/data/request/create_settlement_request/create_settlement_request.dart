class CreateSettlementRequest {
  final int toUserId;
  final int toUserType;
  final int fromUserId;
  final String iban;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? amount;
  final String? notes;

  const CreateSettlementRequest({
    required this.toUserId,
    this.toUserType = 4,
    required this.fromUserId,
    required this.iban,
    this.startDate,
    this.endDate,
    this.amount,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'toUserId': toUserId,
      'toUserType': toUserType,
      'fromUserId': fromUserId,
      'IBAN': iban.trim(),
    };

    if (startDate != null) {
      data['startDate'] = startDate!.toIso8601String();
    }
    if (endDate != null) {
      data['endDate'] = endDate!.toIso8601String();
    }
    if (amount != null && amount! > 0) {
      data['amount'] = amount;
    }
    if (notes != null && notes!.trim().isNotEmpty) {
      data['notes'] = notes!.trim();
    }

    return data;
  }
}
