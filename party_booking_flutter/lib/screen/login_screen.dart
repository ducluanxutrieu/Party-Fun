import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/database/db_provide.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_categories_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen/main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];

  saveDataToPrefs(AccountModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.ACCOUNT_MODEL_KEY, accountModelToJson(model));
    prefs.setString(Constants.USER_TOKEN, model.token);
    _getListDishes();
    _getListCategories(prefs, model);
  }

  void _getListCategories(SharedPreferences prefs, AccountModel accountModel, ) async {
    var result = await AppApiService.create().getCategories();
    if (result.isSuccessful) {
      prefs.setString(Constants.LIST_CATEGORIES_KEY, listCategoriesResponseModelToJson(result.body));
      _goToMainScreen(accountModel, result.body.categories);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
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

  void _goToMainScreen(accountModel, List<Category> categories) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen(accountModel: accountModel, listCategories: categories,)));
  }

  void requestLogin(String username, String password) async {
    var result = await AppApiService.create().requestSignIn(username: username, password: password);
    if (result.isSuccessful) {
      UiUtiu.showToast(message: result.body.message, isFalse: false);
      saveDataToPrefs(result.body.account);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
  }

  void _saveListDishesToDB(List<DishModel> listDishes) async {
    await DBProvider.db.deleteAll();
    listDishes.forEach((element) async {
      await DBProvider.db.newDish(element);
      print(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
