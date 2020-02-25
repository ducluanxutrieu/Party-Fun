import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:party_booking/data/network/model/dish_model.dart';
import 'package:party_booking/data/network/model/serializers.dart';

part 'list_dishes_response_model.g.dart';

abstract class ListDishesResponseModel
    implements Built<ListDishesResponseModel, ListDishesResponseModelBuilder> {
  ListDishesResponseModel._();

  factory ListDishesResponseModel([updates(ListDishesResponseModelBuilder b)]) =
      _$ListDishesResponseModel;

  @BuiltValueField(wireName: 'success')
  bool get success;

  @BuiltValueField(wireName: 'message')
  String get message;

  @BuiltValueField(wireName: 'lishDishs')
  BuiltList<DishModel> get dishModel;

  String toJson() {
    return json.encode(
        serializers.serializeWith(ListDishesResponseModel.serializer, this));
  }

  static ListDishesResponseModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        ListDishesResponseModel.serializer, json.decode(jsonString));
  }

  static Serializer<ListDishesResponseModel> get serializer =>
      _$listDishesResponseModelSerializer;
}
