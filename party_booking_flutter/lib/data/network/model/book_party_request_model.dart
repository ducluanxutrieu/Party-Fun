

// To parse this JSON data, do
//
//     final bookPartyRequestModel = bookPartyRequestModelFromJson(jsonString);

import 'dart:convert';



BookPartyRequestModel bookPartyRequestModelFromJson(String str) =>
    BookPartyRequestModel.fromJson(json.decode(str));

String bookPartyRequestModelToJson(BookPartyRequestModel data) =>
    json.encode(data.toJson());

class BookPartyRequestModel {
  String dateParty;
  int numberTable;
  int numberCustomer;
  List<ListDishes> listDishes;

  BookPartyRequestModel({
    this.dateParty,
    this.numberTable,
    this.numberCustomer,
    this.listDishes,
  });

  static BookPartyRequestModel fromJsonFactory(Map<String, dynamic> json) =>
      BookPartyRequestModel.fromJson(json);

  factory BookPartyRequestModel.fromJson(Map<String, dynamic> json) =>
      BookPartyRequestModel(
        dateParty: json["date_party"],
        numberTable: json["table"],
        numberCustomer: json['count_customer'],
        listDishes: List<ListDishes>.from(
            json["dishes"].map((x) => ListDishes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "date_party": dateParty,
    "table": numberTable,
    "count_customer": numberCustomer,
    "dishes": List<dynamic>.from(listDishes.map((x) => x.toJson())),
  };
}

class ListDishes {
  int numberDish;
  String id;

  ListDishes({ this.id,this.numberDish });

  static ListDishes fromJsonFactory(Map<String, dynamic> json) =>
      ListDishes.fromJson(json);

  factory ListDishes.fromJson(Map<String, dynamic> json) => ListDishes(
    id: json["_id"],
    numberDish: json["count"],

    //name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "count": numberDish,

    //  "name": name,
  };
}

