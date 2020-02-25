import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:party_booking/data/network/model/serializers.dart';

part 'register_request_model.g.dart';

abstract class RegisterRequestModel
    implements Built<RegisterRequestModel, RegisterRequestModelBuilder> {
  RegisterRequestModel._();

  factory RegisterRequestModel([updates(RegisterRequestModelBuilder b)]) =
      _$RegisterRequestModel;

  @BuiltValueField(wireName: 'fullName')
  String get fullName;

  @BuiltValueField(wireName: 'username')
  String get username;

  @BuiltValueField(wireName: 'email')
  String get email;

  @BuiltValueField(wireName: 'phoneNumber')
  String get phoneNumber;

  @BuiltValueField(wireName: 'password')
  String get password;

  String toJson() {
    return json.encode(
        serializers.serializeWith(RegisterRequestModel.serializer, this));
  }

  static RegisterRequestModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        RegisterRequestModel.serializer, json.decode(jsonString));
  }

  static RegisterRequestModel fromModel(String fullName, String username, String email, String phoneNumber, String password){
    return _$RegisterRequestModel._(fullName: fullName, password: password, username: username, email: email, phoneNumber: phoneNumber);
  }

  static Serializer<RegisterRequestModel> get serializer =>
      _$registerRequestModelSerializer;
}
