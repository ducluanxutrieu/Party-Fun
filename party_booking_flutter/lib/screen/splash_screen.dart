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
import 'package:party_booking/screen/login/login_screen.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen/main_screen.dart';

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
    String token = prefs.getString(Constants.USER_TOKEN);
    if (token != null && token.isNotEmpty) {
      _updateUserProfile(token, prefs);
      _getListDishes(token, prefs);
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
                  fontFamily: 'Source Sans Pro',
                  color: Colors.orange,
                  fontSize: 28),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getListDishes(String token, SharedPreferences prefs) async {
    await AppApiService.create()
        .getListDishes(token: token)
        .catchError((onError) {
      print(onError);
      _getListDishesFromDB(prefs);
    }).then((result) => {
              if (result == null || !result.isSuccessful) _getListDishesFromDB(prefs)
              else
                {
                  _saveListDishesToDB(result.body.listDishes),
                  _getListCategories(prefs, result.body.listDishes),
                }
            });
  }

  void _getListCategories(
    SharedPreferences prefs,
    List<DishModel> listDishes,
  ) async {
    var result = await AppApiService.create().getCategories();
    if (result.isSuccessful) {
      prefs.setString(Constants.LIST_CATEGORIES_KEY,
          listCategoriesResponseModelToJson(result.body));
      _goToMainScreen(listDishes, result.body.categories, prefs);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
  }

  void _goToMainScreen(List<DishModel> listDishes, List<Category> categories,
      SharedPreferences prefs) async {
    final String accountJson = prefs.getString(Constants.ACCOUNT_MODEL_KEY);
    AccountModel accountModel = AccountModel.fromJson(json.decode(accountJson));

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(
                  accountModel: accountModel,
                  listCategories: categories,
                  listDishModel: listDishes,
                )));
  }

  Future<void> _getListDishesFromDB(SharedPreferences prefs) async {
    List<DishModel> listDishes = await DBProvider.db.getAllDishes();
    ListCategoriesResponseModel categories =
        listCategoriesResponseModelFromJson(
            prefs.getString(Constants.LIST_CATEGORIES_KEY));
    _goToMainScreen(listDishes, categories.categories, prefs);
  }

  void _saveListDishesToDB(List<DishModel> listDishes) async {
    await DBProvider.db.deleteAll();
    listDishes.forEach((element) async {
      await DBProvider.db.newDish(element);
      print(element);
    });
  }

  void _updateUserProfile(String token, SharedPreferences prefs) async {
    var result = await AppApiService.create().getUserProfile(token: token);
    if (result.isSuccessful) {
      prefs.setString(Constants.ACCOUNT_MODEL_KEY,
          jsonEncode(result.body.account.toJson()));
    }
  }
}
