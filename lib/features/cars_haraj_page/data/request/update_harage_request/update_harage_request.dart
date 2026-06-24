class UpdateHarageRequest {
  final int? id;
  final int? userId;
  final int? userType;

  final int? carId;
  final int? carBrandId;
  final int? carModelId;
  final int? branchId;

  final bool? isNew;
  final String? date;
  final dynamic releaseDate;
  final int? transmissionType;
  final int? fuelType;
  final int? kilometers;

  final String? description;
  final String? addressText;

  final num? price;
  final num? cost;

  final bool? isSold;
  final int? commentsNumber;
  final String? sellDate;

  final UpdateHarageUser? user;
  final UpdateHarageCar? car;

  UpdateHarageRequest({
    this.id,
    this.userId,
    this.userType,
    this.carId,
    this.carBrandId,
    this.carModelId,
    this.branchId,
    this.isNew,
    this.date,
    this.releaseDate,
    this.transmissionType,
    this.fuelType,
    this.kilometers,
    this.description,
    this.addressText,
    this.price,
    this.cost,
    this.isSold,
    this.commentsNumber,
    this.sellDate,
    this.user,
    this.car,
  });

  UpdateHarageRequest copyWith({
    int? id,
    int? userId,
    int? userType,
    int? carId,
    int? carBrandId,
    int? carModelId,
    int? branchId,
    bool? isNew,
    String? date,
    dynamic releaseDate,
    int? transmissionType,
    int? fuelType,
    int? kilometers,
    String? description,
    String? addressText,
    num? price,
    num? cost,
    bool? isSold,
    int? commentsNumber,
    String? sellDate,
    UpdateHarageUser? user,
    UpdateHarageCar? car,
  }) {
    return UpdateHarageRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userType: userType ?? this.userType,
      carId: carId ?? this.carId,
      carBrandId: carBrandId ?? this.carBrandId,
      carModelId: carModelId ?? this.carModelId,
      branchId: branchId ?? this.branchId,
      isNew: isNew ?? this.isNew,
      date: date ?? this.date,
      releaseDate: releaseDate ?? this.releaseDate,
      transmissionType: transmissionType ?? this.transmissionType,
      fuelType: fuelType ?? this.fuelType,
      kilometers: kilometers ?? this.kilometers,
      description: description ?? this.description,
      addressText: addressText ?? this.addressText,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      isSold: isSold ?? this.isSold,
      commentsNumber: commentsNumber ?? this.commentsNumber,
      sellDate: sellDate ?? this.sellDate,
      user: user ?? this.user,
      car: car ?? this.car,
    );
  }

  factory UpdateHarageRequest.fromJson(Map<String, dynamic> json) {
    return UpdateHarageRequest(
      id: json['id'],
      userId: json['userid'],
      userType: json['usertype'],

      carId: json['carid'],
      carBrandId: json['carbrandid'],
      carModelId: json['carmodelid'],
      branchId: json['branchid'],

      isNew: json['isnew'],
      date: json['date'],
      releaseDate: json['releasedate'],

      transmissionType: json['transmissiontype'],
      fuelType: json['fueltype'],
      kilometers: json['kilometers'],

      description: json['description'],
      addressText: json['addresstext'],

      price: json['price'],
      cost: json['cost'],

      isSold: json['issold'],
      commentsNumber: json['commentsnumber'],
      sellDate: json['selldate'],

      user: json['user'] != null
          ? UpdateHarageUser.fromJson(json['user'])
          : null,

      car: json['car'] != null
          ? UpdateHarageCar.fromJson(json['car'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "ID": id,
      if (userId != null) "USERID": userId,
      if (userType != null) "USERTYPE": userType,

      if (carId != null) "CARID": carId,
      if (carBrandId != null) "CARBRANDID": carBrandId,
      if (carModelId != null) "CARMODELID": carModelId,
      if (branchId != null) "BRANCHID": branchId,

      if (isNew != null) "ISNEW": isNew,
      if (releaseDate != null) "RELEASEDATE": releaseDate,

      if (transmissionType != null)
        "TRANSMISSIONTYPE": transmissionType,

      if (fuelType != null)
        "FUELTYPE": fuelType,

      if (kilometers != null)
        "KILOMETERS": kilometers,

      if (description != null)
        "DESCRIPTION": description,

      if (addressText != null)
        "ADDRESSTEXT": addressText,

      if (price != null)
        "PRICE": price,

      if (cost != null)
        "COST": cost,

      if (isSold != null)
        "ISSOLD": isSold,

      if (sellDate != null)
        "SELLDATE": sellDate,

      "Images": [],
    };
  }
}

class UpdateHarageUser {
  final int? id;
  final int? type;
  final String? name;
  final String? latinName;
  final String? image;
  final String? branchName;
  final String? branchLatinName;

  UpdateHarageUser({
    this.id,
    this.type,
    this.name,
    this.latinName,
    this.image,
    this.branchName,
    this.branchLatinName,
  });

  factory UpdateHarageUser.fromJson(Map<String, dynamic> json) {
    return UpdateHarageUser(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      latinName: json['latinname'],
      image: json['image'],
      branchName: json['branchname'],
      branchLatinName: json['branchlatinname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      if (type != null) "type": type,
      if (name != null) "name": name,
      if (latinName != null) "latinname": latinName,
      if (image != null) "image": image,
      if (branchName != null) "branchname": branchName,
      if (branchLatinName != null)
        "branchlatinname": branchLatinName,
    };
  }
}

class UpdateHarageCar {
  final int? id;
  final String? brandName;
  final String? brandLatinName;
  final String? brandImage;
  final String? modelName;
  final String? carImage;

  UpdateHarageCar({
    this.id,
    this.brandName,
    this.brandLatinName,
    this.brandImage,
    this.modelName,
    this.carImage,
  });

  factory UpdateHarageCar.fromJson(Map<String, dynamic> json) {
    return UpdateHarageCar(
      id: json['id'],
      brandName: json['brandname'],
      brandLatinName: json['brandlatinname'],
      brandImage: json['brandimage'],
      modelName: json['modelname'],
      carImage: json['carimage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      if (brandName != null) "brandname": brandName,
      if (brandLatinName != null)
        "brandlatinname": brandLatinName,
      if (brandImage != null) "brandimage": brandImage,
      if (modelName != null) "modelname": modelName,
      if (carImage != null) "carimage": carImage,
    };
  }
}