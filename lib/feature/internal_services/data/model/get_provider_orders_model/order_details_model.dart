import 'dart:convert';
import 'dart:typed_data';
import 'package:web_admin_san/core/networking/api_link.dart';

OrderDetailsModel orderModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    this.date,
    this.branchid,
    this.notes,
    this.appointment,
    this.nationaladdress,
    this.userid,
    this.long,
    this.offer,
    this.employeeInfos,
    this.id,
    this.provid,
    this.lat,
    this.totalprice,
    this.rates,
    this.usertype,
    this.services,
    this.cars,
    this.statusHistory,
    this.taxamount,
    this.user,
    this.paymentmethod,
    this.providerInfo,
    this.status,
    this.rejectreason,
    this.isoffer,
    this.deliveryOrder,
    this.isDeliveryOrder,
    this.isOnSite,
    this.applyedcouponamount,
    this.applyedpointsamount,
    this.couponcode,
    this.applyedcouponid,
  });

  DateTime? date;
  int? branchid;
  String? notes;
  DateTime? appointment;
  String? nationaladdress;
  int? userid;
  double? long;
  Offer? offer;
  List<dynamic>? employeeInfos;
  int? id;
  int? provid;
  double? lat;
  num? totalprice;
  List<RateModel>? rates;
  int? usertype;
  List<Service>? services;
  List<Car>? cars;
  List<StatusHistory>? statusHistory;
  num? taxamount;
  User? user;
  int? paymentmethod;
  ProviderInfo? providerInfo;
  int? status;
  String? rejectreason;
  bool? isoffer;
  DeliveryOrder? deliveryOrder;
  bool? isDeliveryOrder;
  bool? isOnSite;
  double? applyedcouponamount;
  double? applyedpointsamount;
  String? couponcode;
  int? applyedcouponid;

  bool get hasGenuineSpecialOffer => offer != null && offer!.hasValidOfferId;

  int get effectiveStatus {
    if (status != null &&
        status != OrderStatus.newOrderForCompany &&
        status != OrderStatus.newOrderForProvider) {
      return status!;
    }
    if (statusHistory != null && statusHistory!.isNotEmpty) {
      final sorted = List<StatusHistory>.from(statusHistory!)
        ..sort((a, b) {
          final dateA = a.date ?? DateTime.fromMillisecondsSinceEpoch(0);
          final dateB = b.date ?? DateTime.fromMillisecondsSinceEpoch(0);
          final comp = dateA.compareTo(dateB);
          if (comp != 0) return comp;
          return (a.id ?? 0).compareTo(b.id ?? 0);
        });
      final valid = sorted
          .map((e) => e.newstatus)
          .whereType<int>()
          .toList();
      if (valid.isNotEmpty) {
        return valid.last;
      }
    }
    return status ?? 0;
  }

  factory OrderDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    final deliveryData = json["deliveryOrder"] ??
        json["deliveryorder"] ??
        json["DeliveryOrder"] ??
        json["DELIVERYORDER"];
    final DeliveryOrder? parsedDelivery =
        deliveryData != null && deliveryData is Map
            ? DeliveryOrder.fromJson(deliveryData)
            : null;

    final ratesData = json["rates"] ?? json["Rates"] ?? json["RATES"];
    final List<RateModel> parsedRates = [];
    if (ratesData != null && ratesData is List) {
      for (final item in ratesData) {
        if (item is Map) {
          parsedRates.add(RateModel.fromJson(item));
        }
      }
    }

    final String? parsedRejectReason = json["rejectreason"]?.toString() ??
        json["rejectReason"]?.toString() ??
        json["REJECTREASON"]?.toString() ??
        (json["rejectedOrder"] != null && json["rejectedOrder"] is Map
            ? (json["rejectedOrder"]["rejectReason"] ??
                    json["rejectedOrder"]["rejectreason"])
                ?.toString()
            : null);

    final offerData = json["offer"] ?? json["Offer"] ?? json["OFFER"];
    Offer? parsedOffer;
    if (offerData != null && offerData is Map) {
      final candidateOffer = Offer.fromJson(offerData);
      if (candidateOffer.hasValidOfferId) {
        parsedOffer = candidateOffer;
      }
    }

    final bool parsedIsOffer = parsedOffer != null;

    return OrderDetailsModel(
      date: json["date"] == null
          ? null
          : DateTime.tryParse(json["date"].toString())?.toLocal(),
      branchid: (json["branchid"] as num?)?.toInt(),
      notes: json["notes"]?.toString(),
      appointment: json["appointment"] == null
          ? null
          : DateTime.tryParse(json["appointment"].toString())?.toLocal(),
      nationaladdress: json["nationaladdress"]?.toString(),
      userid: (json["userid"] as num?)?.toInt(),
      long: (json["long"] as num?)?.toDouble(),
      offer: parsedOffer,
      employeeInfos:
          (json["employeeInfos"] as List? ?? []).map((e) => e).toList(),
      id: (json["id"] as num?)?.toInt(),
      provid: (json["provid"] as num?)?.toInt(),
      lat: (json["lat"] as num?)?.toDouble(),
      totalprice: (json["totalprice"] as num?)?.toDouble(),
      rates: parsedRates,
      usertype: (json["usertype"] as num?)?.toInt(),
      services: (json["services"] as List? ?? [])
          .map((e) => Service.fromJson(e))
          .toList(),
      cars: (json["cars"] as List? ?? []).map((e) => Car.fromJson(e)).toList(),
      statusHistory: (json["statusHistory"] as List? ?? [])
          .map((e) => StatusHistory.fromJson(e))
          .toList(),
      taxamount: (json["taxamount"] as num?)?.toDouble(),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      paymentmethod: (json["paymentmethod"] as num?)?.toInt(),
      providerInfo: json["providerInfo"] == null
          ? null
          : ProviderInfo.fromJson(json["providerInfo"]),
      status: (json["status"] as num?)?.toInt(),
      rejectreason: parsedRejectReason,
      isoffer: parsedIsOffer,
      deliveryOrder: parsedDelivery,
      isDeliveryOrder: parsedDelivery != null ||
          json["isdeliveryorder"] == true ||
          json["isDeliveryOrder"] == true,
      isOnSite: json["isonsite"] == true ||
          json["isOnSite"] == true ||
          json["ISONSITE"] == true,
      applyedcouponamount:
          (json["applyedcouponamount"] ?? json["applyedCouponAmount"] as num?)
              ?.toDouble(),
      applyedpointsamount:
          (json["applyedpointsamount"] ?? json["applyedPointsAmount"] as num?)
              ?.toDouble(),
      couponcode:
          json["couponcode"]?.toString() ?? json["couponCode"]?.toString(),
      applyedcouponid:
          (json["applyedcouponid"] ?? json["applyedCouponId"] as num?)?.toInt(),
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "branchid": branchid,
        "notes": notes,
        "appointment": appointment?.toIso8601String(),
        "nationaladdress": nationaladdress,
        "userid": userid,
        "long": long,
        "offer": offer?.toJson(),
        "employeeInfos": employeeInfos ?? [],
        "id": id,
        "provid": provid,
        "lat": lat,
        "totalprice": totalprice,
        "rates": rates?.map((e) => e.toJson()).toList() ?? [],
        "usertype": usertype,
        "services": services?.map((e) => e.toJson()).toList() ?? [],
        "cars": cars?.map((e) => e.toJson()).toList() ?? [],
        "statusHistory": statusHistory?.map((e) => e.toJson()).toList() ?? [],
        "taxamount": taxamount,
        "user": user?.toJson(),
        "paymentmethod": paymentmethod,
        "providerInfo": providerInfo?.toJson(),
        "status": status,
        "rejectreason": rejectreason,
        "isoffer": isoffer,
        "deliveryOrder": deliveryOrder?.toJson(),
        "isdeliveryorder": isDeliveryOrder,
        "applyedcouponamount": applyedcouponamount,
        "applyedpointsamount": applyedpointsamount,
        "couponcode": couponcode,
        "applyedcouponid": applyedcouponid,
      };
}

class Car {
  Car({
    this.image,
    this.totalprice,
    this.products,
    this.provServices,
    this.servicePackages,
    this.id,
    this.releasedate,
    this.ownerid,
    this.ownertype,
    this.chassisno,
    this.plateno,
    this.insuranceno,
    this.licenceimage,
    this.name,
    this.brand,
    this.model,
  });

  Uint8List? image;
  num? totalprice;
  List<dynamic>? products;
  List<ProvService>? provServices;
  List<dynamic>? servicePackages;

  int? id;
  int? releasedate;
  int? ownerid;
  int? ownertype;

  String? chassisno;
  String? plateno;
  String? insuranceno;
  Uint8List? licenceimage;
  String? name;

  Brand? brand;
  Model? model;

  factory Car.fromJson(Map<dynamic, dynamic> json) => Car(
        image: json["image"] != null && json["image"].toString().isNotEmpty
            ? base64Decode(json["image"])
            : null,
        totalprice: (json["totalprice"] as num?)?.toDouble(),
        products: (json["products"] as List? ?? []).map((e) => e).toList(),
        provServices: (json["provServices"] as List? ?? [])
            .map((e) => ProvService.fromJson(e))
            .toList(),
        servicePackages:
            (json["servicePackages"] as List? ?? []).map((e) => e).toList(),
        id: json["id"],
        releasedate: json["releasedate"],
        ownerid: json["ownerid"],
        ownertype: json["ownertype"],
        chassisno: json["chassisno"],
        plateno: json["plateno"],
        insuranceno: json["insuranceno"],
        licenceimage: json["licenceimage"] != null &&
                json["licenceimage"].toString().isNotEmpty
            ? base64Decode(json["licenceimage"])
            : null,
        name: json["name"],
        brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
        model: json["model"] == null ? null : Model.fromJson(json["model"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "image": image,
        "totalprice": totalprice,
        "products": products ?? [],
        "provServices": provServices?.map((e) => e.toJson()).toList() ?? [],
        "servicePackages": servicePackages ?? [],
        "id": id,
        "releasedate": releasedate,
        "ownerid": ownerid,
        "ownertype": ownertype,
        "chassisno": chassisno,
        "plateno": plateno,
        "insuranceno": insuranceno,
        "licenceimage": licenceimage,
        "name": name,
        "brand": brand?.toJson(),
        "model": model?.toJson(),
      };
}

class Brand {
  Brand({
    this.carbrandid,
    this.brandname,
    this.brandlatinname,
    this.image,
  });

  int? carbrandid;
  String? brandname;
  String? brandlatinname;
  Uint8List? image;

  factory Brand.fromJson(Map<dynamic, dynamic> json) => Brand(
        carbrandid: json["carbrandid"],
        brandname: json["brandname"],
        brandlatinname: json["brandlatinname"],
        image: json["image"] != null && json["image"].toString().isNotEmpty
            ? base64Decode(json["image"])
            : null,
      );

  Map<dynamic, dynamic> toJson() => {
        "carbrandid": carbrandid,
        "brandname": brandname,
        "brandlatinname": brandlatinname,
        "image": image,
      };
}

class Model {
  Model({
    this.carmodelid,
    this.modelname,
    this.image,
  });

  int? carmodelid;
  String? modelname;
  Uint8List? image;

  factory Model.fromJson(Map<dynamic, dynamic> json) => Model(
        carmodelid: json["carmodelid"],
        modelname: json["modelname"],
        image: json["image"] != null && json["image"].toString().isNotEmpty
            ? base64Decode(json["image"])
            : null,
      );

  Map<dynamic, dynamic> toJson() => {
        "carmodelid": carmodelid,
        "modelname": modelname,
        "image": image,
      };
}

class ProvService {
  ProvService({
    this.quantity,
    this.cost,
    this.orderid,
    this.taxpercentage,
    this.price,
    this.totalprice,
    this.name,
    this.provserviceid,
    this.id,
    this.latinname,
    this.carid,
  });

  int? quantity;
  num? cost;
  int? orderid;
  num? taxpercentage;
  num? price;
  num? totalprice;
  String? name;
  int? provserviceid;
  int? id;
  String? latinname;
  int? carid;

  factory ProvService.fromJson(Map<dynamic, dynamic> json) => ProvService(
        quantity: (json["quantity"] as num?)?.toInt(),
        cost: (json["cost"] as num?)?.toDouble(),
        orderid: (json["orderid"] as num?)?.toInt(),
        taxpercentage: (json["taxpercentage"] as num?)?.toDouble(),
        price: (json["price"] as num?)?.toDouble(),
        totalprice: (json["totalprice"] as num?)?.toDouble(),
        name: json["name"]?.toString(),
        provserviceid: (json["provserviceid"] as num?)?.toInt(),
        id: (json["id"] as num?)?.toInt(),
        latinname: json["latinname"]?.toString(),
        carid: (json["carid"] as num?)?.toInt(),
      );

  Map<dynamic, dynamic> toJson() => {
        "quantity": quantity,
        "cost": cost,
        "orderid": orderid,
        "taxpercentage": taxpercentage,
        "price": price,
        "totalprice": totalprice,
        "name": name,
        "provserviceid": provserviceid,
        "id": id,
        "latinname": latinname,
        "carid": carid,
      };
}

class Service {
  Service({
    this.image,
    this.name,
    this.id,
    this.latinname,
    this.parentid,
  });

  Uint8List? image;
  String? name;
  int? id;
  String? latinname;
  int? parentid;

  factory Service.fromJson(Map<dynamic, dynamic> json) => Service(
        image: json["image"] != null && json["image"].toString().isNotEmpty
            ? base64Decode(json["image"])
            : null,
        name: json["name"],
        id: json["id"],
        latinname: json["latinname"],
        parentid: json["parentid"],
      );

  Map<dynamic, dynamic> toJson() => {
        "image": image,
        "name": name,
        "id": id,
        "latinname": latinname,
        "parentid": parentid,
      };
}

class Offer {
  Offer({
    this.servicerequestid,
    this.orderid,
    this.servicerequestofferid,
  });

  int? servicerequestid;
  int? orderid;
  int? servicerequestofferid;

  bool get hasValidOfferId =>
      (servicerequestofferid != null && servicerequestofferid! > 0) ||
      (servicerequestid != null && servicerequestid! > 0);

  factory Offer.fromJson(Map<dynamic, dynamic> json) => Offer(
        servicerequestid: (json["servicerequestid"] ??
                json["serviceRequestId"] ??
                json["SERVICEREQUESTID"] as num?)
            ?.toInt(),
        orderid: (json["orderid"] ?? json["orderId"] ?? json["ORDERID"] as num?)
            ?.toInt(),
        servicerequestofferid: (json["servicerequestofferid"] ??
                json["serviceRequestOfferId"] ??
                json["SERVICEREQUESTOFFERID"] as num?)
            ?.toInt(),
      );

  Map<dynamic, dynamic> toJson() => {
        "servicerequestid": servicerequestid,
        "orderid": orderid,
        "servicerequestofferid": servicerequestofferid,
      };
}

class ProviderInfo {
  ProviderInfo({
    this.image,
    this.branchid,
    this.description,
    this.servicesnames,
    this.phone,
    this.averagerate,
    this.name,
    this.latindesc,
    this.id,
    this.branchlatinname,
    this.latinname,
    this.email,
    this.fcmtoken,
    this.branchname,
  });

  Uint8List? image;
  int? branchid;
  String? description;
  List<Servicesname>? servicesnames;
  String? phone;
  num? averagerate;
  String? name;
  String? latindesc;
  int? id;
  String? branchlatinname;
  String? latinname;
  String? email;
  String? fcmtoken;
  String? branchname;

  factory ProviderInfo.fromJson(Map<dynamic, dynamic> json) => ProviderInfo(
        image: json["image"] != null && json["image"].toString().isNotEmpty
            ? base64Decode(json["image"])
            : null,
        branchid: (json["branchid"] as num?)?.toInt(),
        description: json["description"],
        servicesnames: (json["servicesnames"] as List? ?? [])
            .map((e) => Servicesname.fromJson(e))
            .toList(),
        phone: json["phone"],
        averagerate: (json["averagerate"] as num?)?.toDouble(),
        name: json["name"],
        latindesc: json["latindesc"],
        id: json["id"],
        branchlatinname: json["branchlatinname"],
        latinname: json["latinname"],
        email: json["email"],
        fcmtoken: json["fcmtoken"],
        branchname: json["branchname"],
      );

  Map<dynamic, dynamic> toJson() => {
        "image": image,
        "branchid": branchid,
        "description": description,
        "servicesnames": servicesnames?.map((e) => e.toJson()).toList() ?? [],
        "phone": phone,
        "averagerate": averagerate,
        "name": name,
        "latindesc": latindesc,
        "id": id,
        "branchlatinname": branchlatinname,
        "latinname": latinname,
        "email": email,
        "fcmtoken": fcmtoken,
        "branchname": branchname,
      };
}

class Servicesname {
  Servicesname({
    this.name,
    this.latinName,
  });

  String? name;
  String? latinName;

  factory Servicesname.fromJson(Map<dynamic, dynamic> json) => Servicesname(
        name: json["name"],
        latinName: json["latinName"],
      );

  Map<dynamic, dynamic> toJson() => {
        "name": name,
        "latinName": latinName,
      };
}

class StatusHistory {
  StatusHistory({
    this.date,
    this.oldstatus,
    this.newstatus,
    this.changedbytype,
    this.orderid,
    this.changedbyid,
    this.id,
    this.changedbyname,
  });

  DateTime? date;
  int? oldstatus;
  int? newstatus;
  int? changedbytype;
  int? orderid;
  int? changedbyid;
  int? id;
  String? changedbyname;

  factory StatusHistory.fromJson(Map<dynamic, dynamic> json) => StatusHistory(
        date: (json["date"] ?? json["DATE"]) == null
            ? null
            : DateTime.tryParse((json["date"] ?? json["DATE"]).toString())?.toLocal(),
        oldstatus: json["oldstatus"] ?? json["oldStatus"] ?? json["OLDSTATUS"],
        newstatus:
            json["newstatus"] ?? json["newStatus"] ?? json["NEWSTATUS"] ?? 0,
        changedbytype: json["changedbytype"] ??
            json["changedByType"] ??
            json["CHANGEDBYTYPE"],
        orderid: json["orderid"] ?? json["orderId"] ?? json["ORDERID"],
        changedbyid:
            json["changedbyid"] ?? json["changedById"] ?? json["CHANGEDBYID"],
        id: json["id"] ?? json["ID"],
        changedbyname: json["changedbyname"] ??
            json["changedByName"] ??
            json["CHANGEDBYNAME"],
      );

  Map<dynamic, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "oldstatus": oldstatus,
        "newstatus": newstatus,
        "changedbytype": changedbytype,
        "orderid": orderid,
        "changedbyid": changedbyid,
        "id": id,
        "changedbyname": changedbyname,
      };
}

class User {
  User({
    this.image,
    this.phone,
    this.usertype,
    this.userid,
    this.email,
    this.fcmtoken,
    this.username,
  });

  Uint8List? image;
  String? phone;
  int? usertype;
  int? userid;
  String? email;
  String? fcmtoken;
  String? username;

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
        image: json["image"] != null && json["image"].toString().isNotEmpty
            ? base64Decode(json["image"])
            : null,
        phone: json["phone"],
        usertype: json["usertype"],
        userid: json["userid"],
        email: json["email"],
        fcmtoken: json["fcmtoken"],
        username: json["username"],
      );

  Map<dynamic, dynamic> toJson() => {
        "image": image,
        "phone": phone,
        "usertype": usertype,
        "userid": userid,
        "email": email,
        "fcmtoken": fcmtoken,
        "username": username,
      };
}

class DeliveryOrder {
  DeliveryOrder({
    this.orderId,
    this.provId,
    this.mandoobAcceptOrderDate,
    this.mandoobReceiveOrderDate,
    this.mandoobDeliverOrderDate,
    this.deliveryOrderId,
    this.deliveryOrderStatus,
    this.mandoobName,
    this.mandoobPhone,
    this.deliveryFee,
  });

  int? orderId;
  int? provId;
  String? mandoobAcceptOrderDate;
  String? mandoobReceiveOrderDate;
  String? mandoobDeliverOrderDate;
  int? deliveryOrderId;
  String? deliveryOrderStatus;
  String? mandoobName;
  String? mandoobPhone;
  double? deliveryFee;

  factory DeliveryOrder.fromJson(Map<dynamic, dynamic> json) => DeliveryOrder(
        orderId: (json['orderid'] ?? json['orderId'] ?? json['ORDERID'] as num?)
            ?.toInt(),
        provId: (json['provid'] ?? json['provId'] ?? json['PROVID'] as num?)
            ?.toInt(),
        mandoobAcceptOrderDate: (json['mandoobacceptorderdate'] ??
                json['mandoobAcceptOrderDate'] ??
                json['MANDOOBACCEPTORDERDATE'])
            ?.toString(),
        mandoobReceiveOrderDate: (json['mandoobreceiveorderdate'] ??
                json['mandoobReceiveOrderDate'] ??
                json['MANDOOBRECEIVEORDERDATE'])
            ?.toString(),
        mandoobDeliverOrderDate: (json['mandoobdeliverorderdate'] ??
                json['mandoobDeliverOrderDate'] ??
                json['MANDOOBDELIVERORDERDATE'])
            ?.toString(),
        deliveryOrderId: (json['deliveryorderid'] ??
                json['deliveryOrderId'] ??
                json['DELIVERYORDERID'] as num?)
            ?.toInt(),
        deliveryOrderStatus: (json['deliveryorderstatus'] ??
                json['deliveryOrderStatus'] ??
                json['DELIVERYORDERSTATUS'])
            ?.toString(),
        mandoobName:
            (json['mandoobname'] ?? json['mandoobName'] ?? json['MANDOOBNAME'])
                ?.toString(),
        mandoobPhone: (json['mandoobphone'] ??
                json['mandoobPhone'] ??
                json['MANDOOBPHONE'])
            ?.toString(),
        deliveryFee: (json['deliveryfee'] ??
                json['deliveryFee'] ??
                json['DELIVERYFEE'] as num?)
            ?.toDouble(),
      );

  Map<dynamic, dynamic> toJson() => {
        'orderid': orderId,
        'provid': provId,
        'mandoobacceptorderdate': mandoobAcceptOrderDate,
        'mandoobreceiveorderdate': mandoobReceiveOrderDate,
        'mandoobdeliverorderdate': mandoobDeliverOrderDate,
        'deliveryorderid': deliveryOrderId,
        'deliveryorderstatus': deliveryOrderStatus,
        'mandoobname': mandoobName,
        'mandoobphone': mandoobPhone,
        'deliveryfee': deliveryFee,
      };
}

class RateModel {
  RateModel({
    this.username,
    this.userimage,
    this.id,
    this.orderid,
    this.provid,
    this.userid,
    this.usertype,
    this.message,
    this.rate,
    this.rateValue,
    this.serviceid,
    this.isEdited,
  });

  String? username;
  Uint8List? userimage;
  int? id;
  int? orderid;
  int? provid;
  int? userid;
  int? usertype;
  String? message;
  int? rate;
  double? rateValue;
  int? serviceid;
  bool? isEdited;

  factory RateModel.fromJson(Map<dynamic, dynamic> json) {
    final rawImage = json['userimage'] ??
        json['USERIMAGE'] ??
        json['userImage'] ??
        json['UserImage'];
    Uint8List? parsedImage;
    if (rawImage is Uint8List) {
      parsedImage = rawImage;
    } else if (rawImage is String && rawImage.isNotEmpty) {
      try {
        parsedImage = base64Decode(rawImage);
      } catch (_) {}
    }

    final rawRate = json['rate'] ?? json['RATE'] ?? json['Rate'];

    return RateModel(
      username: (json['username'] ?? json['USERNAME'] ?? json['UserName'])
          ?.toString(),
      userimage: parsedImage,
      id: (json['id'] ?? json['ID'] ?? json['Id'] as num?)?.toInt(),
      orderid: (json['orderid'] ?? json['ORDERID'] ?? json['OrderId'] as num?)
          ?.toInt(),
      provid:
          (json['provid'] ?? json['PROVID'] ?? json['ProvId'] as num?)?.toInt(),
      userid:
          (json['userid'] ?? json['USERID'] ?? json['UserId'] as num?)?.toInt(),
      usertype:
          (json['usertype'] ?? json['USERTYPE'] ?? json['UserType'] as num?)
              ?.toInt(),
      message:
          (json['message'] ?? json['MESSAGE'] ?? json['Message'])?.toString(),
      rate: (rawRate as num?)?.toInt(),
      rateValue: rawRate?.toDouble(),
      serviceid:
          (json['serviceid'] ?? json['SERVICEID'] ?? json['ServiceId'] as num?)
              ?.toInt(),
      isEdited: json['isedited'] == true ||
          json['isEdited'] == true ||
          json['ISEDITED'] == true,
    );
  }

  Map<dynamic, dynamic> toJson() => {
        'username': username,
        'userimage': userimage != null ? base64Encode(userimage!) : null,
        'id': id,
        'orderid': orderid,
        'provid': provid,
        'userid': userid,
        'usertype': usertype,
        'message': message,
        'rate': rate,
        'rateValue': rateValue,
        'serviceid': serviceid,
        'isEdited': isEdited,
      };
}
