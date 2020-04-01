// To parse this JSON data, do
//
//     final bookPartyRequestModel = bookPartyRequestModelFromJson(jsonString);

import 'dart:convert';

BookPartyRequestModel bookPartyRequestModelFromJson(String str) => BookPartyRequestModel.fromJson(json.decode(str));

String bookPartyRequestModelToJson(BookPartyRequestModel data) => json.encode(data.toJson());

class BookPartyRequestModel {
  String dateParty;
  String numbertable;
  List<ListDishes> lishDishs;

  BookPartyRequestModel({
    this.dateParty,
    this.numbertable,
    this.lishDishs,
  });

  static BookPartyRequestModel fromJsonFactory(Map<String, dynamic> json) =>
      BookPartyRequestModel.fromJson(json);

  factory BookPartyRequestModel.fromJson(Map<String, dynamic> json) => BookPartyRequestModel(
    dateParty: json["dateParty"],
    numbertable: json["numbertable"],
    lishDishs: List<ListDishes>.from(json["lishDishs"].map((x) => ListDishes.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "dateParty": dateParty,
    "numbertable": numbertable,
    "lishDishs": List<dynamic>.from(lishDishs.map((x) => x.toJson())),
  };
}

class ListDishes {
  String numberDish;
  String id;

  ListDishes({
    this.numberDish,
    this.id,
  });

  static ListDishes fromJsonFactory(Map<String, dynamic> json) =>
      ListDishes.fromJson(json);

  factory ListDishes.fromJson(Map<String, dynamic> json) => ListDishes(
    numberDish: json["numberDish"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "numberDish": numberDish,
    "_id": id,
  };
}
