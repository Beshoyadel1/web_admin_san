class SettlementModel {
  final int id;
  final int? toUserId;
  final int? toUserType;
  final int? fromUserId;
  final double amount;
  final String iban;
  final DateTime? startDate;
  final DateTime? endDate;
  final int status;
  final String? notes;
  final DateTime? date;

  const SettlementModel({
    required this.id,
    this.toUserId,
    this.toUserType,
    this.fromUserId,
    required this.amount,
    required this.iban,
    this.startDate,
    this.endDate,
    this.status = 1,
    this.notes,
    this.date,
  });

  factory SettlementModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    return SettlementModel(
      id: (json['id'] ??
                  json['Id'] ??
                  json['settlementId'] ??
                  json['SettlementId'] as num?)
              ?.toInt() ??
          0,
      toUserId: (json['toUserId'] ??
              json['ToUserId'] ??
              json['userId'] ??
              json['UserId'] as num?)
          ?.toInt(),
      toUserType: (json['toUserType'] ??
              json['ToUserType'] ??
              json['userType'] ??
              json['UserType'] as num?)
          ?.toInt(),
      fromUserId: (json['fromUserId'] ?? json['FromUserId'] as num?)?.toInt(),
      amount: ((json['amount'] ??
                  json['Amount'] ??
                  json['totalAmount'] ??
                  json['TotalAmount']) as num?)
              ?.toDouble() ??
          0.0,
      iban: (json['iban'] ?? json['IBAN'] ?? json['Iban'] ?? '').toString(),
      startDate: parseDate(json['startDate'] ?? json['StartDate']),
      endDate: parseDate(json['endDate'] ?? json['EndDate']),
      status: (json['status'] ?? json['Status'] as num?)?.toInt() ?? 1,
      notes: (json['notes'] ?? json['Notes'])?.toString(),
      date: parseDate(json['date'] ??
          json['Date'] ??
          json['createdAt'] ??
          json['CreatedAt'] ??
          json['createdDate'] ??
          json['CreatedDate']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'toUserId': toUserId,
        'toUserType': toUserType,
        'fromUserId': fromUserId,
        'amount': amount,
        'iban': iban,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'status': status,
        'notes': notes,
        'date': date?.toIso8601String(),
      };
}
