
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:party_booking/data/network/model/serializers.dart';

part 'login_request_model.g.dart';

abstract class LoginRequestModel
    implements Built<LoginRequestModel, LoginRequestModelBuilder> {
  LoginRequestModel._();

  factory LoginRequestModel([updates(LoginRequestModelBuilder b)]) =
  _$LoginRequestModel;

  @BuiltValueField(wireName: 'username')
  String get username;
  @BuiltValueField(wireName: 'password')
  String get password;
  String toJson() {
    return json
        .encode(serializers.serializeWith(LoginRequestModel.serializer, this));
  }

  static LoginRequestModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        LoginRequestModel.serializer, json.decode(jsonString));
  }

  static LoginRequestModel fromModel(String user, String pass) {
    return _$LoginRequestModel._(username: user, password: pass);
  }

  static Serializer<LoginRequestModel> get serializer =>
      _$loginRequestModelSerializer;
}
