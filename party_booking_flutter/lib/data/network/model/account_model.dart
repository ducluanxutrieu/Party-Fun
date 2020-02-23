import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:party_booking/data/network/model/serializers.dart';

part 'account_model.g.dart';

abstract class AccountModel
    implements Built<AccountModel, AccountModelBuilder> {
  AccountModel._();

  factory AccountModel([updates(AccountModelBuilder b)]) = _$AccountModel;

  @BuiltValueField(wireName: '_id')
  String get id;

  @BuiltValueField(wireName: 'username')
  String get username;

  @BuiltValueField(wireName: 'fullName')
  String get fullName;

  @BuiltValueField(wireName: 'email')
  String get email;

  @BuiltValueField(wireName: 'phoneNumber')
  String get phoneNumber;

  @BuiltValueField(wireName: 'birthday')
  String get birthday;

  @BuiltValueField(wireName: 'sex')
  String get sex;

  @BuiltValueField(wireName: 'role')
  String get role;

  @BuiltValueField(wireName: 'imageurl')
  String get imageurl;

  @BuiltValueField(wireName: 'resetpassword')
  String get resetpassword;

  @BuiltValueField(wireName: 'createAt')
  String get createAt;

  @BuiltValueField(wireName: 'updateAt')
  String get updateAt;

  @BuiltValueField(wireName: 'token')
  String get token;

  String toJson() {
    return json
        .encode(serializers.serializeWith(AccountModel.serializer, this));
  }

  static AccountModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        AccountModel.serializer, json.decode(jsonString));
  }

  static Serializer<AccountModel> get serializer => _$accountModelSerializer;
}
