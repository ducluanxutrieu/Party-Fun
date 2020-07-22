

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/bloc_providers.dart';
import 'package:party_booking/data/database/db_provide.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_categories_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/main_screen/main_screen.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends BlocBase{
  StreamController loginStatusController = StreamController<AppButtonState>.broadcast();

  Sink get loginStatusSink => loginStatusController.sink;
  Stream<AppButtonState> get loginButtonStatusStream => loginStatusController.stream;

  loginPressed(GlobalKey<FormBuilderState> fbKey, BuildContext context){
    onLoginPressed(fbKey, context);
  }

  void loginStatusChange(AppButtonState status){
    loginStatusSink.add(status);
  }

  @override
  void dispose() {
    loginStatusController.close();
  }

  void _saveListDishesToDB(List<DishModel> listDishes) async {
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

  void requestLogin(String username, String password, BuildContext context) async {
    loginStatusChange(AppButtonState.Loading);
    var result = await AppApiService.create().requestSignIn(username: username, password: password);
    if (result.isSuccessful) {
      UiUtiu.showToast(message: result.body.message, isFalse: false);
      _saveDataToPrefs(result.body.account, context);
    } else {
      loginStatusChange(AppButtonState.Error);
      Timer(Duration(milliseconds: 1500), () {
        loginStatusChange(AppButtonState.None);
      });
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
  }

  void _saveDataToPrefs(AccountModel model, BuildContext context) async {
    loginStatusChange(AppButtonState.Success);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.ACCOUNT_MODEL_KEY, accountModelToJson(model));
    prefs.setString(Constants.USER_TOKEN, model.token);
    _getListDishes();
    _getListCategories(prefs, model, context);
  }

  void _getListCategories(SharedPreferences prefs, AccountModel accountModel, BuildContext context) async {
    var result = await AppApiService.create().getCategories();
    if (result.isSuccessful) {
      prefs.setString(Constants.LIST_CATEGORIES_KEY, listCategoriesResponseModelToJson(result.body));
      _goToMainScreen(accountModel, result.body.categories, context);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
  }

  void _goToMainScreen(accountModel, List<Category> categories, BuildContext context) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen(accountModel: accountModel, listCategories: categories,)));
  }

  onLoginPressed(GlobalKey<FormBuilderState> _fbKey, BuildContext context) {
    if(_fbKey.currentState.saveAndValidate()){
      FocusScope.of(context).unfocus();
      String username =
          _fbKey.currentState.fields['username'].currentState.value;
      String password =
          _fbKey.currentState.fields['password'].currentState.value;
      requestLogin(username, password, context);
    }
  }
}