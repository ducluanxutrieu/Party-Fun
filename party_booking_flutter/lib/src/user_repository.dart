import 'dart:async';

import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/res/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  AccountModel _user;

  Future<AccountModel> getUser() async {
    if (_user != null) return _user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.USER_TOKEN);
    String userJson = prefs.getString(Constants.ACCOUNT_MODEL_KEY);
    if (userJson != null) {
      _user = accountModelFromJson(userJson);
      _user.token = token;
    }
    return _user;
  }
}
