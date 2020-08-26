import 'dart:async';

import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/change_password_request_model.dart';
import 'package:party_booking/data/network/model/change_password_request_model_2.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  AccountModel _user;

  Future<AccountModel> getUserFromPrefs() async {
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

  Future<AccountModel> getUserFromServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.USER_TOKEN);
    var result = await AppApiService.create().getUserProfile(token: token);
    if (result.isSuccessful) {
      prefs.setString(
          Constants.ACCOUNT_MODEL_KEY, accountModelToJson(result.body.account));
      return result.body.account;
    }

    return _user;
  }

  Future<MapEntry<String, bool>> sendCodeForgotPassword(String username) async {
    var result = await AppApiService.create().resetPassword(username: username);
    if (result.isSuccessful) {
      return MapEntry("${result.body.message}", true);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      return MapEntry(model.message, false);
    }
  }

  Future<MapEntry<String, bool>> changePassword(
      {String password, String newPassword}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.USER_TOKEN);
    try {
      var result = await AppApiService.create().changePassword(
          token: token,
          model: ConfirmChangePasswordRequestModel(
              password: password, newPassword: newPassword));

      if (result.isSuccessful) {
        return MapEntry<String, bool>(result.body.message, true);
      } else {
        BaseResponseModel model = BaseResponseModel.fromJson(result.error);
        return MapEntry(model.message, false);
      }
    } catch (ex) {
      return MapEntry(ex.toString(), false);
    }
  }

  Future<MapEntry<String, bool>> resetPassword(
      {String code, String newPassword, username}) async {
    try {
      var result = await AppApiService.create().confirmResetPassword(
          model: ConfirmResetPasswordRequestModel(
              code: code, password: newPassword, username: username));

      if (result.isSuccessful) {
        return MapEntry<String, bool>(result.body.message, true);
      } else {
        BaseResponseModel model = BaseResponseModel.fromJson(result.error);
        return MapEntry(model.message, false);
      }
    } catch (ex) {
      return MapEntry(ex.toString(), false);
    }
  }
}
