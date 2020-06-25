import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/database/db_provide.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_categories_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    print(DateTime.now().millisecondsSinceEpoch);
    checkAlreadyLogin();
    super.initState();
  }

  void checkAlreadyLogin() async {
    new Future.delayed(const Duration(seconds: 5), () => "5");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accountJson = prefs.getString(Constants.ACCOUNT_MODEL_KEY);
    print(DateTime.now().millisecondsSinceEpoch);
    if (accountJson != null && accountJson.isNotEmpty) {
      AccountModel _accountModel =
          AccountModel.fromJson(json.decode(accountJson));
      _getListDishes(_accountModel);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            LogoAppWidget(
              mLogoSize: 200,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Lottie.asset(
                Assets.animLoading,
                repeat: true,
              ),
            ),
            Text(
              'Easy to book a party and\nenjoy with your relatives',
              style: TextStyle(
                  fontFamily: 'Source Sans Pro', color: Colors.orange, fontSize: 28),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getListDishes(AccountModel accountModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(Constants.USER_TOKEN);

    BaseResponseModel model;
    await AppApiService.create()
        .getListDishes(token: _token)
        .catchError((onError) {
      print(onError);
      _getListDishesFromDB(accountModel, prefs);
    }).then((result) => {
              if (result == null || !result.isSuccessful)
                {
                  model = BaseResponseModel.fromJson(result.error),
                  UTiu.showToast(model.message),
                  _getListDishesFromDB(accountModel, prefs)
                }
              else
                {
                  _saveListDishesToDB(result.body.listDishes),
                  _getListCategories(
                      prefs, result.body.listDishes, accountModel),
                }
            });
  }

  void _getListCategories(
    SharedPreferences prefs,
    List<DishModel> listDishes,
    AccountModel accountModel,
  ) async {
    var result = await AppApiService.create().getCategories();
    if (result.isSuccessful) {
      prefs.setString(Constants.LIST_CATEGORIES_KEY,
          listCategoriesResponseModelToJson(result.body));
      _goToMainScreen(accountModel, listDishes, result.body.categories);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UTiu.showToast(model.message);
    }
  }

  void _goToMainScreen(accountModel, List<DishModel> listDishes,
      List<Category> categories) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(
                  accountModel: accountModel,
                  listCategories: categories,
                  listDishModel: listDishes,
                )));
  }

  Future<void> _getListDishesFromDB(
      AccountModel accountModel, SharedPreferences prefs) async {
    List<DishModel> listDishes = await DBProvider.db.getAllDishes();
    ListCategoriesResponseModel categories =
        listCategoriesResponseModelFromJson(
            prefs.getString(Constants.LIST_CATEGORIES_KEY));
    _goToMainScreen(accountModel, listDishes, categories.categories);
  }

  void _saveListDishesToDB(List<DishModel> listDishes) async {
    await DBProvider.db.deleteAll();
    listDishes.forEach((element) async {
      await DBProvider.db.newDish(element);
      print(element);
    });
  }
}
