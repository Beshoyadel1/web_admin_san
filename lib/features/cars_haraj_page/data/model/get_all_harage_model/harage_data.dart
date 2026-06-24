import '../../../../../../features/cars_haraj_page/data/model/get_all_harage_model/user_model.dart';
import '../../../../../../features/cars_haraj_page/data/model/get_all_harage_model/car_model.dart';

class HarageData {
  final int? id;
  final int? userid;
  final int? usertype;
  final bool? isNew;
  final String? releaseDate;
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
  final UserModel? user;
  final CarModel? car;

  HarageData({
    this.id,
    this.userid,
    this.usertype,
    this.isNew,
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

  factory HarageData.fromJson(
      Map<String, dynamic> json) {

    return HarageData(
      id: json['id'] ?? 0,

      userid: json['userid'] ?? 0,

      usertype: json['usertype'] ?? 0,

      isNew: json['isnew'] ?? false,

      releaseDate:
      json['releasedate']?.toString() ?? "",

      transmissionType:
      json['transmissiontype'] ?? 0,

      fuelType:
      json['fueltype'] ?? 0,

      kilometers:
      json['kilometers'] ?? 0,

      description:
      json['description']?.toString() ?? "",

      addressText:
      json['addresstext']?.toString() ?? "",

      price: json['price'] ?? 0,

      cost: json['cost'] ?? 0,

      isSold: json['issold'] ?? false,

      commentsNumber:
      json['commentsnumber'] ?? 0,

      sellDate:
      json['selldate']?.toString() ?? "",

      user: json['user'] != null
          ? UserModel.fromJson(
          json['user']
          as Map<String, dynamic>)
          : null,

      car: json['car'] != null
          ? CarModel.fromJson(
          json['car']
          as Map<String, dynamic>)
          : null,
    );
  }
}