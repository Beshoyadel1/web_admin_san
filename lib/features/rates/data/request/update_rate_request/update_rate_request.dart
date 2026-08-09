class UpdateRateRequest {
  UpdateRateRequest({
    this.id,
    this.orderId,
    this.providerId,
    this.userId,
    this.userType,
    this.message,
    this.rate,
    this.serviceId,
  });

  int? id;
  int? orderId;
  int? providerId;
  int? userId;
  int? userType;
  String? message;
  double? rate;
  int? serviceId;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "orderid": orderId,
      "provid": providerId,
      "userid": userId,
      "usertype": userType,
      "message": message,
      "rate": rate,
      "serviceid": serviceId,
    };
  }
}