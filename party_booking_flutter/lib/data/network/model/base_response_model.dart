import 'dart:convert';

BaseResponseModel baseResponseModelFromJson(String str) => BaseResponseModel.fromJson(json.decode(str));

class BaseResponseModel {
  bool success;
  String message;

  BaseResponseModel({
    this.success,
    this.message,
  });

  static BaseResponseModel fromJsonFactory(Map<String, dynamic> json) =>
      BaseResponseModel.fromJson(json);

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) => BaseResponseModel(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
