import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:party_booking/data/network/model/serializers.dart';

part 'member_rate_model.g.dart';

abstract class MemberRateModel implements Built<MemberRateModel, MemberRateModelBuilder> {
  MemberRateModel._();

  factory MemberRateModel([updates(MemberRateModelBuilder b)]) = _$MemberRateModel;

  @BuiltValueField(wireName: 'username')
  String get username;

  @BuiltValueField(wireName: 'imageurl')
  String get imageurl;

  @BuiltValueField(wireName: '_iddish')
  String get iddish;

  @BuiltValueField(wireName: 'scorerate')
  int get scorerate;

  @BuiltValueField(wireName: 'content')
  String get content;

  @BuiltValueField(wireName: 'updateAt')
  String get updateAt;

  @BuiltValueField(wireName: 'createAt')
  String get createAt;

  String toJson() {
    return json.encode(serializers.serializeWith(MemberRateModel.serializer, this));
  }

  static MemberRateModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        MemberRateModel.serializer, json.decode(jsonString));
  }

  static Serializer<MemberRateModel> get serializer => _$memberRateModelSerializer;
}
