// To parse this JSON data, do
//
//     final menuModel = menuModelFromJson(jsonString);

import 'dart:convert';

import 'package:party_booking/data/network/model/list_dishes_response_model.dart';

MenuModel menuModelFromJson(String str) => MenuModel.fromJson(json.decode(str));

String menuModelToJson(MenuModel data) => json.encode(data.toJson());

class MenuModel {
  String menuName;
  List<DishModel> listDish;

  MenuModel({
    this.menuName,
    this.listDish,
  });

  static MenuModel fromJsonFactory(Map<String, dynamic> json) => MenuModel.fromJson(json);

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
    menuName: json["menuName"],
    listDish: List<DishModel>.from(json["listDish"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "menuName": menuName,
    "listDish": List<dynamic>.from(listDish.map((x) => x)),
  };
}
