import 'dart:convert';

import 'get_user_profile_response_model.dart';

PartyBookResponseModel partyBookResponseModelFromJson(String str) =>
    PartyBookResponseModel.fromJson(json.decode(str));

String partyBookResponseModelToJson(PartyBookResponseModel data) =>
    json.encode(data.toJson());

class PartyBookResponseModel {
  bool success;
  String message;
  Bill bill;

  PartyBookResponseModel({
    this.success,
    this.message,
    this.bill,
  });

  static PartyBookResponseModel fromJsonFactory(Map<String, dynamic> json) =>
      PartyBookResponseModel.fromJson(json);

  factory PartyBookResponseModel.fromJson(Map<String, dynamic> json) =>
      PartyBookResponseModel(
        success: json["success"],
        message: json["message"],
        bill: Bill.fromJson(json["bill"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "bill": bill.toJson(),
      };
}

class Bill {
  String id;
  List<ListDishes> listDishes;
  String dateParty;
  int numberTable;
  String username;
  String createAt;
  bool paymentStatus;
  int totalMoney;
  String userPayment;
  String paymentAt;

  Bill({
    this.id,
    this.listDishes,
    this.dateParty,
    this.numberTable,
    this.username,
    this.createAt,
    this.paymentStatus,
    this.totalMoney,
    this.userPayment,
    this.paymentAt,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        id: json["_id"],
        listDishes: List<ListDishes>.from(
            json["lishDishs"].map((x) => ListDishes.fromJson(x))),
        dateParty: json["dateParty"],
        numberTable: json["numbertable"],
        username: json["username"],
        createAt: json["createAt"],
        paymentStatus: json["paymentstatus"],
        totalMoney: json["totalMoney"],
        userPayment: json["userpayment"],
        paymentAt: json["paymentAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "lishDishs": List<dynamic>.from(listDishes.map((x) => x.toJson())),
        "dateParty": dateParty,
        "numbertable": numberTable,
        "username": username,
        "createAt": createAt,
        "paymentstatus": paymentStatus,
        "totalMoney": totalMoney,
        "userpayment": userPayment,
        "paymentAt": paymentAt,
      };
}
