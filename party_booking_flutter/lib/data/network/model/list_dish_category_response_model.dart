


class ListDishCategoryResponseModel{
  List<dynamic> dataJson = [
  {
  "_id": "5ebc0bdf914d1b749ca39c1c",
  "name": "Holiday Offers",
  "description": "",
  "type": "menu",
  "author": "admin",
  "create_at": "2020-05-13T15:01:51.342Z",
  "update_at": "2020-05-13T15:01:51.342Z"
  },
  {
  "_id": "5ebc0bf39c033574c246087e",
  "name": "First Dishes",
  "description": "",
  "type": "menu",
  "author": "admin",
  "create_at": "2020-05-13T15:02:11.623Z",
  "update_at": "2020-05-13T15:02:11.623Z"
  },
  {
  "_id": "5ebc0c009c033574c246087f",
  "name": "Main Dishes",
  "description": "",
  "type": "menu",
  "author": "admin",
  "create_at": "2020-05-13T15:02:24.244Z",
  "update_at": "2020-05-13T15:02:24.244Z"
  },
  {
  "_id": "5ebc0c089c033574c2460880",
  "name": "Seafood",
  "description": "",
  "type": "menu",
  "author": "admin",
  "create_at": "2020-05-13T15:02:32.158Z",
  "update_at": "2020-05-13T15:02:32.158Z"
  },
  {
  "_id": "5ebc0c0f9c033574c2460881",
  "name": "Drinks",
  "description": "",
  "type": "menu",
  "author": "admin",
  "create_at": "2020-05-13T15:02:39.862Z",
  "update_at": "2020-05-13T15:02:39.862Z"
  },
  {
  "_id": "5ebc0c189c033574c2460882",
  "name": "Dessert",
  "description": "",
  "type": "menu",
  "author": "admin",
  "create_at": "2020-05-13T15:02:48.957Z",
  "update_at": "2020-05-13T15:02:48.957Z"
  }
  ];
  String message;
  List<CategoryModel> data;

  List<String> getListIdCategory(String categories){
    List<String> listCategory = List();
    if(this.data == null){
      this.data = this.dataJson.map((x) => CategoryModel.fromJson(x)).toList();
    }
    this.data.forEach((element) {
      if(categories == element.name){
        listCategory.add(element.id);
      }
    });
    return listCategory;
  }

  ListDishCategoryResponseModel({
    this.message,
    this.data,
  });

  factory ListDishCategoryResponseModel.fromJson(Map<String, dynamic> json) => ListDishCategoryResponseModel(
    message: json["message"],
    data: List<CategoryModel>.from(json["data"].map((x) => CategoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CategoryModel {
  String id;
  String name;
  String description;
  String type;
  String author;
  DateTime createAt;
  DateTime updateAt;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.type,
    this.author,
    this.createAt,
    this.updateAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    type: json["type"],
    author: json["author"],
    createAt: DateTime.parse(json["create_at"]),
    updateAt: DateTime.parse(json["update_at"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "type": type,
    "author": author,
    "create_at": createAt.toIso8601String(),
    "update_at": updateAt.toIso8601String(),
  };
}