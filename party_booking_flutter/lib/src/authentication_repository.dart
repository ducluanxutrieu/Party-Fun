import 'dart:async';

import 'package:meta/meta.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/register_request_model.dart';
import 'package:party_booking/data/network/model/update_profile_request_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  authenticatedOnlyServerUpdate,
  unauthenticated
}

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    yield AuthenticationStatus.authenticated;
    yield* _controller.stream;
  }

  Future<MapEntry<String, bool>> logIn({
    @required String username,
    @required String password,
  }) async {
    assert(username != null);
    assert(password != null);

    var result = await AppApiService.create()
        .requestSignIn(username: username, password: password);
    if (result.isSuccessful) {
      _saveAccountToSharedPre(result.body.account);
      _controller.add(AuthenticationStatus.authenticated);
      return MapEntry("", true);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      _controller.add(AuthenticationStatus.unauthenticated);
      return MapEntry( model.message, false);
    }
  }

  Future<String> register({@required RegisterRequestModel model}) async {
    assert(model != null);
    var result = await AppApiService.create().requestRegister(model: model);
    if (result.isSuccessful) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          Constants.ACCOUNT_MODEL_KEY, accountModelToJson(result.body.account));
      prefs.setString(Constants.USER_TOKEN, result.body.account.token);
      _controller.add(AuthenticationStatus.authenticated);
      print("Register Successful!");
      print(result.body.account);
      return "Register Successful!";
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      _controller.add(AuthenticationStatus.unauthenticated);
      return model.message;
    }
  }

  Future<String> updateUserProfile(
      {@required UpdateProfileRequestModel updateProfileModel}) async {
    assert(updateProfileModel != null);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString(Constants.USER_TOKEN);

    final result = await AppApiService.create()
        .requestUpdateUser(token: userToken, model: updateProfileModel);
    if (result.isSuccessful) {
      _controller.add(AuthenticationStatus.authenticatedOnlyServerUpdate);
      return "Update Profile Successful!";
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      return model.message;
    }
  }

  void logOut() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Constants.USER_TOKEN);
      var result = await AppApiService.create().requestSignOut(token: token);
      if (result.isSuccessful) {
        prefs.remove(Constants.ACCOUNT_MODEL_KEY);
        prefs.remove(Constants.USER_TOKEN);
        _controller.add(AuthenticationStatus.unauthenticated);
      }
  }

  void dispose() => _controller.close();

  Future<void> _saveAccountToSharedPre(AccountModel accountModel)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        Constants.ACCOUNT_MODEL_KEY, accountModelToJson(accountModel));
    prefs.setString(Constants.USER_TOKEN, accountModel.token);
  }
}
