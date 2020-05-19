// To parse this JSON data, do
//
//     final updateDishResponseModel = updateDishResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:party_booking/data/network/model/list_dishes_response_model.dart';

UpdateDishResponseModel updateDishResponseModelFromJson(String str) => UpdateDishResponseModel.fromJson(json.decode(str));

String updateDishResponseModelToJson(UpdateDishResponseModel data) => json.encode(data.toJson());

class UpdateDishResponseModel {
  String message;
  DishModel dish;

  UpdateDishResponseModel({
    this.message,
    this.dish,
  });

  static UpdateDishResponseModel fromJsonFactory(Map<String, dynamic> json) => UpdateDishResponseModel.fromJson(json);

  factory UpdateDishResponseModel.fromJson(Map<String, dynamic> json) => UpdateDishResponseModel(
    message: json["message"],
    dish: DishModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": dish.toJson(),
  };
}