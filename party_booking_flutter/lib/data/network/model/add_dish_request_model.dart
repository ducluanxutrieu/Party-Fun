class AddDishRequestModel {
  var uploadImageList;
  String name;
  String type;
  String price;
  String description;
  String discount;

  AddDishRequestModel(
      {this.uploadImageList, this.name, this.type, this.price, this.description, this.discount});

  AddDishRequestModel.fromJson(Map<String, dynamic> json) {
    uploadImageList = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.uploadImageList;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['type'] = this.type;
    data['discount'] = this.discount;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}