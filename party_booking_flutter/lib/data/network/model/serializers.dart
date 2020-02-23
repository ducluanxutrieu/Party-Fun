import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:party_booking/data/network/model/account_model.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';

import 'account_model.dart';
import 'account_response_model.dart';
import 'login_request_model.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  AccountModel,
  AccountResponseModel,
  LoginRequestModel
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
