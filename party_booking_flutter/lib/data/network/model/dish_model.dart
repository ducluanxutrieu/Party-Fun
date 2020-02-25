import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:party_booking/data/network/model/rate_model.dart';
import 'package:party_booking/data/network/model/serializers.dart';

part 'dish_model.g.dart';

abstract class DishModel implements Built<DishModel, DishModelBuilder> {
  DishModel._();

  factory DishModel([updates(DishModelBuilder b)]) = _$DishModel;

  @BuiltValueField(wireName: '_id')
  String get id;

  @BuiltValueField(wireName: 'name')
  String get name;

  @BuiltValueField(wireName: 'description')
  String get description;

  @BuiltValueField(wireName: 'price')
  int get price;

  @BuiltValueField(wireName: 'type')
  String get type;

  @BuiltValueField(wireName: 'discount')
  int get discount;

  @BuiltValueField(wireName: 'image')
  BuiltList<String> get image;

  @BuiltValueField(wireName: 'updateAt')
  String get updateAt;

  @BuiltValueField(wireName: 'createAt')
  String get createAt;

  @BuiltValueField(wireName: 'usercreate')
  String get usercreate;

  @BuiltValueField(wireName: 'rate')
  RateModel get rate;

  String toJson() {
    return json.encode(serializers.serializeWith(DishModel.serializer, this));
  }

  static DishModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        DishModel.serializer, json.decode(jsonString));
  }

  static Serializer<DishModel> get serializer => _$dishModelSerializer;

  factory DishModel.create(String name, String description, int price, String type, BuiltList<String> image){
    return _$DishModel._(name: name, description: description, price: price, type: type, image: image);
  }
}
