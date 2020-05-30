class DishRequestCreateModel {
  String name;
  String description;
  int price;
  List<String> categories;
  int discount;
  List<String> image;
  String featureImage;
  String currency;

  DishRequestCreateModel({
    this.name,
    this.description,
    this.price,
    this.categories,
    this.discount,
    this.image,
    this.featureImage,
    this.currency,
  });

  static DishRequestCreateModel fromJsonFactory(Map<String, dynamic> json) =>
      DishRequestCreateModel.fromJson(json);

  factory DishRequestCreateModel.fromJson(Map<String, dynamic> json) => DishRequestCreateModel(
    name: json["name"],
    description: json["description"],
    price: json["price"],
    categories: List<String>.from(json["categories"].map((x) => x)),
    discount: json["discount"],
    image: List<String>.from(json["image"].map((x) => x)),
    featureImage: json["feature_image"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "price": price,
    "categories": categories,
    "discount": discount,
    "image": List<dynamic>.from(image.map((x) => x)),
    "feature_image": featureImage,
    "currency": currency,
  };
}