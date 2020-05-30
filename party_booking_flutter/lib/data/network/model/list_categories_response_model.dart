// To parse this JSON data, do
//
//     final listCategoriesResponseModel = listCategoriesResponseModelFromJson(jsonString);

import 'dart:convert';

ListCategoriesResponseModel listCategoriesResponseModelFromJson(String str) => ListCategoriesResponseModel.fromJson(json.decode(str));

String listCategoriesResponseModelToJson(ListCategoriesResponseModel data) => json.encode(data.toJson());

class ListCategoriesResponseModel {
  String message;
  List<Category> categories;

  ListCategoriesResponseModel({
    this.message,
    this.categories,
  });

  static ListCategoriesResponseModel fromJsonFactory(Map<String, dynamic> json) => ListCategoriesResponseModel.fromJson(json);

  factory ListCategoriesResponseModel.fromJson(Map<String, dynamic> json) => ListCategoriesResponseModel(
    message: json["message"],
    categories: List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  String name;
  String description;

  Category({
    this.name,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
  };
}
