import 'dart:convert';

GetPaymentRequestModel getPaymentRequestModelFromJson(String str) => GetPaymentRequestModel.fromJson(json.decode(str));

String getPaymentRequestModelToJson(GetPaymentRequestModel data) => json.encode(data.toJson());

class GetPaymentRequestModel {
  String id;

  GetPaymentRequestModel({
    this.id,
  });

  static GetPaymentRequestModel fromJsonFactory(Map<String, dynamic> json) =>
      GetPaymentRequestModel.fromJson(json);

  factory GetPaymentRequestModel.fromJson(Map<String, dynamic> json) => GetPaymentRequestModel(
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
  };
}