class GetDriverDetailsRequest {
  final int? driverId;

  GetDriverDetailsRequest({
    this.driverId,
  });

  Map<String, dynamic> toJson() {
    return {
      "driverId": driverId??1,
    };
  }
}