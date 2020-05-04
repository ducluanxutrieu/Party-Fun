// To parse this JSON data, do
//
//     final getUserProfileResponseModel = getUserProfileResponseModelFromJson(jsonString);

import 'dart:convert';

GetUserProfileResponseModel getUserProfileResponseModelFromJson(String str) =>
    GetUserProfileResponseModel.fromJson(json.decode(str));

String getUserProfileResponseModelToJson(GetUserProfileResponseModel data) =>
    json.encode(data.toJson());

class GetUserProfileResponseModel {
  bool success;
  String message;
  Account account;

  GetUserProfileResponseModel({
    this.success,
    this.message,
    this.account,
  });
  static GetUserProfileResponseModel fromJsonFactory(
          Map<String, dynamic> json) =>
      GetUserProfileResponseModel.fromJson(json);

  factory GetUserProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      GetUserProfileResponseModel(
        success: json["success"],
        message: json["message"],
        account: Account.fromJson(json["account"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "account": account.toJson(),
      };
}

class Account {
  String id;
  User username;
  String fullName;
  String email;
  String phoneNumber;
  String birthday;
  String sex;
  String role;
  String imageurl;
  String resetpassword;
  String createAt;
  String updateAt;
  List<UserCart> userCart;

  Account({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.birthday,
    this.sex,
    this.role,
    this.imageurl,
    this.resetpassword,
    this.createAt,
    this.updateAt,
    this.userCart,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json["_id"],
        username: userValues.map[json["username"]],
        fullName: json["fullName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        birthday: json["birthday"],
        sex: json["sex"],
        role: json["role"],
        imageurl: json["imageurl"],
        resetpassword: json["resetpassword"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        userCart: List<UserCart>.from(
            json["userCart"].map((x) => UserCart.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": userValues.reverse[username],
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "birthday": birthday,
        "sex": sex,
        "role": role,
        "imageurl": imageurl,
        "resetpassword": resetpassword,
        "createAt": createAt,
        "updateAt": updateAt,
        "userCart": List<dynamic>.from(userCart.map((x) => x.toJson())),
      };
}

class UserCart {
  String id;
  List<ListDishes> listDishes;
  String dateParty;
  int numberOfTable;
  User username;
  String createAt;
  bool paymentStatus;
  int totalMoney;
  User userPayment;
  DateTime paymentAt;

  UserCart({
    this.id,
    this.listDishes,
    this.dateParty,
    this.numberOfTable,
    this.username,
    this.createAt,
    this.paymentStatus,
    this.totalMoney,
    this.userPayment,
    this.paymentAt,
  });

  factory UserCart.fromJson(Map<String, dynamic> json) => UserCart(
        id: json["_id"],
        listDishes: List<ListDishes>.from(
            json["lishDishs"].map((x) => ListDishes.fromJson(x))),
        dateParty: json["dateParty"],
        numberOfTable: json["numbertable"],
        username: userValues.map[json["username"]],
        createAt: json["createAt"],
        paymentStatus: json["paymentstatus"],
        totalMoney: json["totalMoney"],
        userPayment: json["userpayment"] == null
            ? null
            : userValues.map[json["userpayment"]],
        paymentAt: json["paymentAt"] == null
            ? null
            : DateTime.parse(json["paymentAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "lishDishs": List<dynamic>.from(listDishes.map((x) => x.toJson())),
        "dateParty": dateParty,
        "numbertable": numberOfTable,
        "username": userValues.reverse[username],
        "createAt": createAt,
        "paymentstatus": paymentStatus,
        "totalMoney": totalMoney,
        "userpayment":
            userPayment == null ? null : userValues.reverse[userPayment],
        "paymentAt": paymentAt == null ? null : paymentAt.toIso8601String(),
      };
}

class ListDishes {
  String id;
  int numberDish;
  dynamic name;
  dynamic image;

  ListDishes({
    this.id,
    this.numberDish,
    this.name,
    this.image,
  });

  static ListDishes fromJsonFactory(Map<String, dynamic> json) =>
      ListDishes.fromJson(json);

  factory ListDishes.fromJson(Map<String, dynamic> json) => ListDishes(
        id: json["_id"],
        numberDish: json["numberDish"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "numberDish": numberDish,
        "name": name,
        "image": image,
      };
}

class NameElement {
  String id;
  String name;
  String description;
  int price;
  String type;
  int discount;
  List<String> image;
  String updateAt;
  String createAt;
  String usercreate;
  Rate rate;

  NameElement({
    this.id,
    this.name,
    this.description,
    this.price,
    this.type,
    this.discount,
    this.image,
    this.updateAt,
    this.createAt,
    this.usercreate,
    this.rate,
  });

  factory NameElement.fromJson(Map<String, dynamic> json) => NameElement(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        type: json["type"],
        discount: json["discount"],
        image: List<String>.from(json["image"].map((x) => x)),
        updateAt: json["updateAt"],
        createAt: json["createAt"],
        usercreate: json["usercreate"],
        rate: Rate.fromJson(json["rate"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "price": price,
        "type": type,
        "discount": discount,
        "image": List<dynamic>.from(image.map((x) => x)),
        "updateAt": updateAt,
        "createAt": createAt,
        "usercreate": usercreate,
        "rate": rate.toJson(),
      };
}

class Rate {
  int average;
  List<LishRate> lishRate;
  int totalpeople;

  Rate({
    this.average,
    this.lishRate,
    this.totalpeople,
  });

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        average: json["average"],
        lishRate: List<LishRate>.from(
            json["lishRate"].map((x) => LishRate.fromJson(x))),
        totalpeople: json["totalpeople"],
      );

  Map<String, dynamic> toJson() => {
        "average": average,
        "lishRate": List<dynamic>.from(lishRate.map((x) => x.toJson())),
        "totalpeople": totalpeople,
      };
}

class LishRate {
  String username;
  String imageurl;
  String iddish;
  int scorerate;
  String content;
  String updateAt;
  String createAt;

  LishRate({
    this.username,
    this.imageurl,
    this.iddish,
    this.scorerate,
    this.content,
    this.updateAt,
    this.createAt,
  });

  factory LishRate.fromJson(Map<String, dynamic> json) => LishRate(
        username: json["username"],
        imageurl: json["imageurl"],
        iddish: json["_iddish"],
        scorerate: json["scorerate"],
        content: json["content"],
        updateAt: json["updateAt"],
        createAt: json["createAt"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "imageurl": imageurl,
        "_iddish": iddish,
        "scorerate": scorerate,
        "content": content,
        "updateAt": updateAt,
        "createAt": createAt,
      };
}

enum User { TRUNG, CARD, CATEYE02 }

final userValues = EnumValues(
    {"card": User.CARD, "cateye02": User.CATEYE02, "trung": User.TRUNG});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
