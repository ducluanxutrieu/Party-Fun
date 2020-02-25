library rate_model;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:party_booking/data/network/model/member_rate_model.dart';
import 'package:party_booking/data/network/model/serializers.dart';

part 'rate_model.g.dart';

abstract class RateModel implements Built<RateModel, RateModelBuilder> {
  RateModel._();

  factory RateModel([updates(RateModelBuilder b)]) = _$RateModel;

  @BuiltValueField(wireName: 'average')
  double get average;

  @BuiltValueField(wireName: 'lishRate')
  BuiltList<MemberRateModel> get memberRateModel;

  @BuiltValueField(wireName: 'totalpeople')
  int get totalPeople;

  String toJson() {
    return json.encode(serializers.serializeWith(RateModel.serializer, this));
  }

  static RateModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        RateModel.serializer, json.decode(jsonString));
  }

  static Serializer<RateModel> get serializer => _$rateModelSerializer;
}
