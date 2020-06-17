// To parse this JSON data, do
//
//     final rateResponseModelData = rateResponseModelDataFromJson(jsonString);

import 'dart:convert';

RateResponseModelData rateResponseModelDataFromJson(String str) => RateResponseModelData.fromJson(json.decode(str));

String rateResponseModelDataToJson(RateResponseModelData data) => json.encode(data.toJson());

class RateResponseModelData {
  RateResponseModelData({
    this.message,
    this.data,
  });

  String message;
  Data data;

  static RateResponseModelData fromJsonFactory(Map<String, dynamic> json) =>
      RateResponseModelData.fromJson(json);

  factory RateResponseModelData.fromJson(Map<String, dynamic> json) => RateResponseModelData(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.countRate,
    this.avgRate,
    this.totalPage,
    this.start,
    this.end,
    this.listRate,
  });

  int countRate;
  dynamic avgRate;
  int totalPage;
  int start;
  int end;
  List<ListRate> listRate;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    countRate: json["count_rate"],
    avgRate:  json["avg_rate"],
    totalPage: json["total_page"],
    start: json["start"],
    end: json["end"],
    listRate: List<ListRate>.from(json["list_rate"].map((x) => ListRate.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count_rate": countRate,
    "avg_rate": avgRate,
    "total_page": totalPage,
    "start": start,
    "end": end,
    "list_rate": List<dynamic>.from(listRate.map((x) => x.toJson())),
  };
}

class ListRate {
  ListRate({
    this.id,
    this.idDish,
    this.userRate,
    this.score,
    this.comment,
    this.createAt,
    this.updateAt,
    this.avatar,
  });

  String id;
  String idDish;
  String userRate;
  int score;
  String comment;
  DateTime createAt;
  DateTime updateAt;
  String avatar;

  factory ListRate.fromJson(Map<String, dynamic> json) => ListRate(
    id: json["_id"],
    idDish: json["id_dish"],
    userRate: json["user_rate"],
    score: json["score"],
    comment: json["comment"],
    createAt: DateTime.parse(json["create_at"]),
    updateAt: DateTime.parse(json["update_at"]),
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "id_dish": idDish,
    "user_rate": userRate,
    "score": score,
    "comment": comment,
    "create_at": createAt.toIso8601String(),
    "update_at": updateAt.toIso8601String(),
    "avatar": avatar,
  };
}