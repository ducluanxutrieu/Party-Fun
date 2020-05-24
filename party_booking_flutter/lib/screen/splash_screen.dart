import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
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
      goToMainScreen(_accountModel);
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
                  fontFamily: 'Pacifico', color: Colors.orange, fontSize: 28),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void goToMainScreen(accountModel) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen(accountModel: accountModel,)));
  }
}
