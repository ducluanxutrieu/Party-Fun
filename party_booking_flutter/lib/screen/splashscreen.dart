import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/main_screen.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accountJson = prefs.getString(Constants.ACCOUNT_MODEL_KEY);
    print(DateTime.now().millisecondsSinceEpoch);
    if (accountJson != null && accountJson.isNotEmpty) {
      AccountModel _accountModel =
          AccountModel.fromJson(json.decode(accountJson));
      getListDishes(_accountModel);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Column(
          children: <Widget>[
            LogoAppWidget(mLogoSize: 200,),
            Expanded(
              child: Container(
                color: Colors.lightBlue,
                child: Center(
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getListDishes(accountModel) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
//    var result = await AppApiService.create().getListDishes(token: token);
//    if(result.isSuccessful){
//
//    }
//    result.body.listDishes;
  }
}
