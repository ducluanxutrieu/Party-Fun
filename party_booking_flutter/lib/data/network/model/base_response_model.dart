import 'dart:convert';

BaseResponseModel baseResponseModelFromJson(String str) => BaseResponseModel.fromJson(json.decode(str));

class BaseResponseModel {
  String message;
  dynamic data;

  BaseResponseModel({
    this.message,
    this.data
  });

  static BaseResponseModel fromJsonFactory(Map<String, dynamic> json) =>
      BaseResponseModel.fromJson(json);

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) => BaseResponseModel(
    message: json["message"],
    data: json['data'],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data,
  };
}
