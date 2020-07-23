import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:party_booking/data/database/db_provide.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_categories_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState(state: AppButtonState.None));

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    yield LoginState(state: AppButtonState.Loading);
    try {
      MapEntry result = await requestLogin(event.username, event.password);
      yield LoginState(state: AppButtonState.Success, accountModel: result.key, categories: result.value);
    } catch (ex) {
      yield LoginState(state: AppButtonState.Error);
      Future.delayed(Duration(seconds: 2), () {});
      yield LoginState(state: AppButtonState.None);
    }
  }

  Future<void> _saveListDishesToDB(List<DishModel> listDishes) async {
    await DBProvider.db.deleteAll();
    listDishes.forEach((element) async {
      await DBProvider.db.newDish(element);
      print(element);
    });
  }

  Future<void> _getListDishes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(Constants.USER_TOKEN);

    BaseResponseModel model;
    await AppApiService.create()
        .getListDishes(token: _token)
        .catchError((onError) {
      print(onError);
    }).then((result) => {
      if (result == null || !result.isSuccessful)
        {
          model = BaseResponseModel.fromJson(result.error),
          UiUtiu.showToast(message: model.message, isFalse: true),
        }
      else
        {
          _saveListDishesToDB(result.body.listDishes),
        }
    });
  }

  Future<MapEntry<AccountModel, dynamic>> requestLogin(String username, String password) async {
    var result = await AppApiService.create().requestSignIn(username: username, password: password);
    if (result.isSuccessful) {
      UiUtiu.showToast(message: result.body.message, isFalse: false);
      return MapEntry(result.body.account, await _saveDataToPrefs(result.body.account));
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
  }

  Future<List<Category>> _saveDataToPrefs(AccountModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.ACCOUNT_MODEL_KEY, accountModelToJson(model));
    prefs.setString(Constants.USER_TOKEN, model.token);
    _getListDishes();
    return await _getListCategories(prefs, model);
  }

  Future<List<Category>> _getListCategories(SharedPreferences prefs, AccountModel accountModel) async {
    var result = await AppApiService.create().getCategories();
    if (result.isSuccessful) {
      prefs.setString(Constants.LIST_CATEGORIES_KEY, listCategoriesResponseModelToJson(result.body));
      return result.body.categories;
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
    return null;
  }
}
