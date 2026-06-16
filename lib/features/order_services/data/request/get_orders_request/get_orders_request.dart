class GetOrdersRequest {
  final int? pageNumber,orderType;


  GetOrdersRequest({
     this.pageNumber,
     this.orderType
  });

  Map<String, dynamic> toJson() {
    return {
      "pageNumber": pageNumber,
      "orderType": orderType,
    };
  }
}