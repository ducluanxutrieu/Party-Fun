// To parse this JSON data, do
//
//     final accountResponseModel = accountResponseModelFromJson(jsonString);

import 'dart:convert';

AccountResponseModel accountResponseModelFromJson(String str) =>
    AccountResponseModel.fromJson(json.decode(str));

String accountResponseModelToJson(AccountResponseModel data) =>
    json.encode(data.toJson());

class AccountResponseModel {
  AccountModel account;
  String message;

  AccountResponseModel({
    this.message,
    this.account,
  });

  static AccountResponseModel fromJsonFactory(Map<String, dynamic> json) =>
      AccountResponseModel.fromJson(json);

  factory AccountResponseModel.fromJson(Map<String, dynamic> json) =>
      AccountResponseModel(
        message: json['message'],
        account: AccountModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        "data": account.toJson(),
      };
}

AccountModel accountModelFromJson(String str) =>
    AccountModel.fromJson(json.decode(str));

String accountModelToJson(AccountModel data) => json.encode(data.toJson());

class AccountModel {
  String id;
  String username;
  String fullName;
  String email;
  String countryCode;
  int phoneNumber;
  DateTime birthday;
  int gender;
  int role;
  String avatar;
  String token;

  AccountModel({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.birthday,
    this.gender,
    this.role,
    this.avatar,
    this.token,
  });

  static AccountModel fromJsonFactory(Map<String, dynamic> json) =>
      AccountModel.fromJson(json);

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        id: json["_id"],
        username: json["username"],
        fullName: json["full_name"],
        email: json["email"],
        countryCode: json['country_code'],
        phoneNumber: json["phone"],
        birthday: DateTime.parse(json["birthday"]),
        gender: json["gender"],
        role: json["role"],
        avatar: json["avatar"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "full_name": fullName,
        "email": email,
        'country_code': countryCode,
        "phone": phoneNumber,
        "birthday": birthday.toIso8601String(),
        "gender": gender,
        "role": role,
        "avatar": avatar,
        "token": token,
      };
}

enum UserRole {
  UserDeleted,
  Customer,
  Staff,
  Admin,
}

enum UserGender {
  Other,
  Male,
  Female,
}

enum Role { BlockedUser, Customer, Staff, Admin }

String getGenderStringFromIndex(int index) {
  return UserGender.values[index].toString().replaceAll("UserGender.", "");
}
