// To parse this JSON data, do
//
//     final bookPartyRequestModel = bookPartyRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:party_booking/data/network/model/get_user_profile_response_model.dart';

BookPartyRequestModel bookPartyRequestModelFromJson(String str) =>
    BookPartyRequestModel.fromJson(json.decode(str));

String bookPartyRequestModelToJson(BookPartyRequestModel data) =>
    json.encode(data.toJson());

class BookPartyRequestModel {
  String dateParty;
  int numberTable;
  List<ListDishes> lishDishs;

  BookPartyRequestModel({
    this.dateParty,
    this.numberTable,
    this.lishDishs,
  });

  static BookPartyRequestModel fromJsonFactory(Map<String, dynamic> json) =>
      BookPartyRequestModel.fromJson(json);

  factory BookPartyRequestModel.fromJson(Map<String, dynamic> json) =>
      BookPartyRequestModel(
        dateParty: json["dateParty"],
        numberTable: json["numbertable"],
        lishDishs: List<ListDishes>.from(
            json["lishDishs"].map((x) => ListDishes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "dateParty": dateParty,
        "numbertable": numberTable,
        "lishDishs": List<dynamic>.from(lishDishs.map((x) => x.toJson())),
      };
}
