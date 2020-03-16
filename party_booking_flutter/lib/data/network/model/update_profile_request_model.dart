// To parse this JSON data, do
//
//     final updateProfileRequestModel = updateProfileRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateProfileRequestModel updateProfileRequestModelFromJson(String str) => UpdateProfileRequestModel.fromJson(json.decode(str));

String updateProfileRequestModelToJson(UpdateProfileRequestModel data) => json.encode(data.toJson());

class UpdateProfileRequestModel {
  String email;
  String fullName;
  String phoneNumber;
  String birthday;
  String sex;

  UpdateProfileRequestModel({
    this.email,
    this.fullName,
    this.phoneNumber,
    this.birthday,
    this.sex,
  });

  static UpdateProfileRequestModel fromJsonFactory(Map<String, dynamic> json) => UpdateProfileRequestModel.fromJson(json);

  factory UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) => UpdateProfileRequestModel(
    email: json["email"],
    fullName: json["fullName"],
    phoneNumber: json["phoneNumber"],
    birthday: json["birthday"],
    sex: json["sex"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "fullName": fullName,
    "phoneNumber": phoneNumber,
    "birthday": birthday,
    "sex": sex,
  };
}
