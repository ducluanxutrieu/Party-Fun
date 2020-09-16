import 'dart:async';

import 'package:meta/meta.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/register_request_model.dart';
import 'package:party_booking/data/network/model/update_profile_request_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/src/user_repository.dart';
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
    // AccountModel model = await new UserRepository().getUserFromPrefs();
    // if(model != null)
    yield AuthenticationStatus.authenticated;
    // else yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  // void changeAuthenticationStatus(AuthenticationStatus status) {
  //   _controller.sink.add(status);
  // }

  Future<String> logIn({
    @required String username,
    @required String password,
  }) async {
    assert(username != null);
    assert(password != null);

    var result = await AppApiService.create()
        .requestSignIn(username: username, password: password);
    if (result.isSuccessful) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          Constants.ACCOUNT_MODEL_KEY, accountModelToJson(result.body.account));
      prefs.setString(Constants.USER_TOKEN, result.body.account.token);
      _controller.add(AuthenticationStatus.authenticated);
      print('Login Successful');
      print('____________________');
      return "Login Successful!";
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      _controller.add(AuthenticationStatus.unauthenticated);
      return model.message;
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

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
