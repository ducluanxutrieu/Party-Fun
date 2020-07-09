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
  String countryCode;
  int gender;

  UpdateProfileRequestModel({
    this.email,
    this.fullName,
    this.phoneNumber,
    this.birthday,
    this.countryCode,
    this.gender,
  });

  static UpdateProfileRequestModel fromJsonFactory(Map<String, dynamic> json) => UpdateProfileRequestModel.fromJson(json);

  factory UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) => UpdateProfileRequestModel(
    email: json["email"],
    fullName: json["full_name"],
    countryCode: json['country_code'],
    phoneNumber: json["phone"],
    birthday: json["birthday"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "full_name": fullName,
    'country_code': countryCode,
    "phone": phoneNumber,
    "birthday": birthday,
    "gender": gender,
  };
}