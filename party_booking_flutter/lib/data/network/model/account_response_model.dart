import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:party_booking/data/network/model/account_model.dart';
import 'package:party_booking/data/network/model/serializers.dart';

part 'account_response_model.g.dart';

abstract class AccountResponseModel
    implements Built<AccountResponseModel, AccountResponseModelBuilder> {
  AccountResponseModel._();

  factory AccountResponseModel([updates(AccountResponseModelBuilder b)]) =
      _$AccountResponseModel;

  @BuiltValueField(wireName: 'success')
  bool get success;

  @BuiltValueField(wireName: 'message')
  String get message;

  @BuiltValueField(wireName: 'account')
  AccountModel get account;

  String toJson() {
    return json.encode(
        serializers.serializeWith(AccountResponseModel.serializer, this));
  }

  static AccountResponseModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        AccountResponseModel.serializer, json.decode(jsonString));
  }

  static Serializer<AccountResponseModel> get serializer =>
      _$accountResponseModelSerializer;
}
