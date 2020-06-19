// To parse this JSON data, do
//
//     final requestRatingModel = requestRatingModelFromJson(jsonString);

import 'dart:convert';

RateDishRequestModel requestRatingModelFromJson(String str) => RateDishRequestModel.fromJson(json.decode(str));

String requestRatingModelToJson(RateDishRequestModel data) => json.encode(data.toJson());

class RateDishRequestModel {
  String id;
  double rateScore;
  String comment;

  RateDishRequestModel({
    this.id,
    this.rateScore,
    this.comment,
  });

  static RateDishRequestModel fromJsonFactory(Map<String, dynamic> json) => RateDishRequestModel.fromJson(json);

  factory RateDishRequestModel.fromJson(Map<String, dynamic> json) => RateDishRequestModel(
    id: json["id"],
    rateScore: json["score"].toDouble(),
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "score": rateScore,
    "comment": comment,
  };
}
