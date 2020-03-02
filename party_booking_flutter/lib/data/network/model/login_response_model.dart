// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:party_booking/data/network/model/account_response_model.dart';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  bool success;
  String message;
  AccountModel account;

  LoginResponseModel({
    this.success,
    this.message,
    this.account,
  });

  static LoginResponseModel fromJsonFactory(Map<String, dynamic> json) =>
      LoginResponseModel.fromJson(json);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        success: json["success"],
        message: json["message"],
        account: AccountModel.fromJson(json["account"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "account": account.toJson(),
      };
}
