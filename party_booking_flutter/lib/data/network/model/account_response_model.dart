// To parse this JSON data, do
//
//     final accountResponseModel = accountResponseModelFromJson(jsonString);

import 'dart:convert';

AccountResponseModel accountResponseModelFromJson(String str) => AccountResponseModel.fromJson(json.decode(str));

String accountResponseModelToJson(AccountResponseModel data) => json.encode(data.toJson());

class AccountResponseModel{
  AccountModel account;
  String message;

  AccountResponseModel({
    this.message, this.account,
  });

  static AccountResponseModel fromJsonFactory(Map<String, dynamic> json) =>
      AccountResponseModel.fromJson(json);

  factory AccountResponseModel.fromJson(Map<String, dynamic> json) => AccountResponseModel(
    message: json['message'],
    account: AccountModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    "data": account.toJson(),
  };
}

AccountModel accountModelFromJson(String str) => AccountModel.fromJson(json.decode(str));

String accountModelToJson(AccountModel data) => json.encode(data.toJson());

class AccountModel {
  String id;
  String username;
  String fullName;
  String email;
  int phoneNumber;
  String birthday;
  int gender;
  int role;
  String avatar;
  String createAt;
  String updateAt;
  String token;

  AccountModel({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.birthday,
    this.gender,
    this.role,
    this.avatar,
    this.createAt,
    this.updateAt,
    this.token,
  });

  static AccountModel fromJsonFactory(Map<String, dynamic> json) =>
      AccountModel.fromJson(json);

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    id: json["_id"],
    username: json["username"],
    fullName: json["full_name"],
    email: json["email"],
    phoneNumber: json["phone"],
    birthday: json["birthday"],
    gender: json["gender"],
    role: json["role"],
    avatar: json["avatar"],
    createAt: json["createAt"],
    updateAt: json["updateAt"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "full_name": fullName,
    "email": email,
    "phone": phoneNumber,
    "birthday": birthday,
    "gender": gender,
    "role": role,
    "avatar": avatar,
    "createAt": createAt,
    "updateAt": updateAt,
    "token": token,
  };
}

enum UserRole {
  UserDeleted,
  Customer,
  Staff,
  Admin,
}

enum UserGender{
  Other,
  Male,
  Female,
}

String getGenderStringFromIndex(int index){
  return UserGender.values[index].toString().replaceAll("UserGender.", "");
}
