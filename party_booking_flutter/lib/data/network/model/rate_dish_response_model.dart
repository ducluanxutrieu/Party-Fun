// To parse this JSON data, do
//
//     final rateResponseModelData = rateResponseModelDataFromJson(jsonString);

import 'dart:convert';

RateResponseModelData rateResponseModelDataFromJson(String str) => RateResponseModelData.fromJson(json.decode(str));

String rateResponseModelDataToJson(RateResponseModelData data) => json.encode(data.toJson());

class RateResponseModelData {
  RateResponseModelData({
    this.message,
    this.rateData,
  });

  String message;
  RateDataModel rateData;

  static RateResponseModelData fromJsonFactory(Map<String, dynamic> json) =>
      RateResponseModelData.fromJson(json);

  factory RateResponseModelData.fromJson(Map<String, dynamic> json) => RateResponseModelData(
    message: json["message"],
    rateData: RateDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": rateData.toJson(),
  };
}

class RateDataModel {
  static const List<ListRate> list = [];

  RateDataModel({
    this.countRate = 0,
    this.avgRate = 0.0,
    this.totalPage = 1,
    this.start = 0,
    this.end = 0,
    this.listRate = list,
  });

  int countRate;
  dynamic avgRate;
  int totalPage;
  int start;
  int end;
  List<ListRate> listRate;

  factory RateDataModel.fromJson(Map<String, dynamic> json) => RateDataModel(
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