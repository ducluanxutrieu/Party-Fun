// To parse this JSON data, do
//
//     final requestRatingModel = requestRatingModelFromJson(jsonString);

import 'dart:convert';

RateDishRequestModel requestRatingModelFromJson(String str) => RateDishRequestModel.fromJson(json.decode(str));

String requestRatingModelToJson(RateDishRequestModel data) => json.encode(data.toJson());

class RateDishRequestModel {
  String id;
  double rateScore;
  String content;

  RateDishRequestModel({
    this.id,
    this.rateScore,
    this.content,
  });

  static RateDishRequestModel fromJsonFactory(Map<String, dynamic> json) => RateDishRequestModel.fromJson(json);

  factory RateDishRequestModel.fromJson(Map<String, dynamic> json) => RateDishRequestModel(
    id: json["_id"],
    rateScore: json["scorerate"].toDouble(),
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "scorerate": rateScore,
    "content": content,
  };
}
