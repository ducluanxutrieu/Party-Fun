// To parse this JSON data, do
//
//     final baseListResponseModel = baseListResponseModelFromJson(jsonString);

import 'dart:convert';

BaseListResponseModel baseListResponseModelFromJson(String str) => BaseListResponseModel.fromJson(json.decode(str));

String baseListResponseModelToJson(BaseListResponseModel data) => json.encode(data.toJson());

class BaseListResponseModel {
  String message;
  List<String> data;

  BaseListResponseModel({
    this.message,
    this.data,
  });

  static BaseListResponseModel fromJsonFactory(Map<String, dynamic> json) => BaseListResponseModel.fromJson(json);

  factory BaseListResponseModel.fromJson(Map<String, dynamic> json) => BaseListResponseModel(
    message: json["message"],
    data: List<String>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
