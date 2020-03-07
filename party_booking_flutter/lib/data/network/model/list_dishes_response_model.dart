// To parse this JSON data, do
//
//     final listDishesResponseModel = listDishesResponseModelFromJson(jsonString);

import 'dart:convert';

ListDishesResponseModel listDishesResponseModelFromJson(String str) => ListDishesResponseModel.fromJson(json.decode(str));

String listDishesResponseModelToJson(ListDishesResponseModel data) => json.encode(data.toJson());

class ListDishesResponseModel {
  bool success;
  String message;
  List<DishModel> listDishes;

  ListDishesResponseModel({
    this.success,
    this.message,
    this.listDishes,
  });

  static ListDishesResponseModel fromJsonFactory(Map<String, dynamic> json) =>
      ListDishesResponseModel.fromJson(json);

  factory ListDishesResponseModel.fromJson(Map<String, dynamic> json) => ListDishesResponseModel(
    success: json["success"],
    message: json["message"],
    listDishes: List<DishModel>.from(json["lishDishs"].map((x) => DishModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "lishDishs": List<dynamic>.from(listDishes.map((x) => x.toJson())),
  };
}

class DishModel {
  String id;
  String name;
  String description;
  int price;
  String type;
  int discount;
  List<String> image;
  String updateAt;
  String createAt;
  RateModel rate;

  DishModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.type,
    this.discount,
    this.image,
    this.updateAt,
    this.createAt,
    this.rate,
  });

  static DishModel fromJsonFactory(Map<String, dynamic> json) =>
      DishModel.fromJson(json);

  factory DishModel.fromJson(Map<String, dynamic> json) => DishModel(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    type: json["type"],
    discount: json["discount"],
    image: List<String>.from(json["image"].map((x) => x)),
    updateAt: json["updateAt"],
    createAt: json["createAt"],
    rate: RateModel.fromJson(json["rate"]),
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
    "rate": rate.toJson(),
  };
}

class RateModel {
  double average;
  List<RateItemModel> lishRate;
  int totalpeople;

  RateModel({
    this.average,
    this.lishRate,
    this.totalpeople,
  });

  static RateModel fromJsonFactory(Map<String, dynamic> json) =>
      RateModel.fromJson(json);

  factory RateModel.fromJson(Map<String, dynamic> json) => RateModel(
    average: json["average"].toDouble(),
    lishRate: List<RateItemModel>.from(json["lishRate"].map((x) => RateItemModel.fromJson(x))),
    totalpeople: json["totalpeople"],
  );

  Map<String, dynamic> toJson() => {
    "average": average,
    "lishRate": List<dynamic>.from(lishRate.map((x) => x.toJson())),
    "totalpeople": totalpeople,
  };
}

class RateItemModel {
  String username;
  String imageUrl;
  String dishId;
  int scoreRate;
  String content;
  String updateAt;
  String createAt;

  RateItemModel({
    this.username,
    this.imageUrl,
    this.dishId,
    this.scoreRate,
    this.content,
    this.updateAt,
    this.createAt,
  });

  static RateItemModel fromJsonFactory(Map<String, dynamic> json) =>
      RateItemModel.fromJson(json);

  factory RateItemModel.fromJson(Map<String, dynamic> json) => RateItemModel(
    username: json["username"],
    imageUrl: json["imageurl"] == null ? null : json["imageurl"],
    dishId: json["_iddish"],
    scoreRate: json["scorerate"],
    content: json["content"],
    updateAt: json["updateAt"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "imageurl": imageUrl == null ? null : imageUrl,
    "_iddish": dishId,
    "scorerate": scoreRate,
    "content": content,
    "updateAt": updateAt,
    "createAt": createAt,
  };
}

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
