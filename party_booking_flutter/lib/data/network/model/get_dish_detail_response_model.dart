// To parse this JSON data, do
//
//     final listDishesResponseModel = listDishesResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:party_booking/data/network/model/base_response_model.dart';

import 'list_dishes_response_model.dart';

DishDetailResponseModel dishDetailResponseModelFromJson(String str) =>
    DishDetailResponseModel.fromJson(json.decode(str));

String dishDetailResponseModelToJson(DishDetailResponseModel data) =>
    json.encode(data.toJson());

class DishDetailResponseModel extends BaseResponseModel {
  DishModel dishModel;

  DishDetailResponseModel({
    this.dishModel,
  });

  static DishDetailResponseModel fromJsonFactory(Map<String, dynamic> json) =>
      DishDetailResponseModel.fromJson(json);

  factory DishDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      DishDetailResponseModel(dishModel: DishModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "data": dishModel.toJson(),
  };
}
