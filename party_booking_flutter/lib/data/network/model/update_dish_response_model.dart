// To parse this JSON data, do
//
//     final updateDishResponseModel = updateDishResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:party_booking/data/network/model/list_dishes_response_model.dart';

UpdateDishResponseModel updateDishResponseModelFromJson(String str) => UpdateDishResponseModel.fromJson(json.decode(str));

String updateDishResponseModelToJson(UpdateDishResponseModel data) => json.encode(data.toJson());

class UpdateDishResponseModel {
  bool success;
  String message;
  DishModel dish;

  UpdateDishResponseModel({
    this.success,
    this.message,
    this.dish,
  });

  static UpdateDishResponseModel jsonFactory(Map<String, dynamic> json) => UpdateDishResponseModel.fromJson(json);

  factory UpdateDishResponseModel.fromJson(Map<String, dynamic> json) => UpdateDishResponseModel(
    success: json["success"],
    message: json["message"],
    dish: DishModel.fromJson(json["dish"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "dish": dish.toJson(),
  };
}