import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/home/bloc/home_bloc.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/widgets/common/logo_app.dart';

class SplashScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(GetListDishEvent());
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

  // void _goToMainScreen(List<DishModel> listDishes, List<Category> categories,
  //     SharedPreferences prefs) async {
  //   final String accountJson = prefs.getString(Constants.ACCOUNT_MODEL_KEY);
  //   AccountModel accountModel = AccountModel.fromJson(json.decode(accountJson));

  //   Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => MainScreen(
  //                 accountModel: accountModel,
  //                 listCategories: categories,
  //                 listDishModel: listDishes,
  //               )));
  // }

  // void _updateUserProfile(String token, SharedPreferences prefs) async {
  //   var result = await AppApiService.create().getUserProfile(token: token);
  //   if (result.isSuccessful) {
  //     prefs.setString(Constants.ACCOUNT_MODEL_KEY,
  //         jsonEncode(result.body.account.toJson()));
  //   }
  // }
}
