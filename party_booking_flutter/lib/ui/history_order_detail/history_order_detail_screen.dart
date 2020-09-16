import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/ui/history_order_detail/components/header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/item_dish.dart';

class HistoryOrderDetailScreen extends StatelessWidget {
  final UserCart userCart;
  HistoryOrderDetailScreen({@required this.userCart});

  @override
  Widget build(BuildContext context) {
    var dishes = userCart.dishes;
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt Detail"),
      ),
      floatingActionButton: Visibility(
        visible: userCart.paymentStatus == 0,
        child: FloatingActionButton.extended(onPressed: () => getPayment(id: userCart.id), label: Row(children: <Widget>[
          Icon(Icons.payment),
          Text('  Pay',)
        ],)),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Text(
                'Customer: ${userCart.customer.toUpperCase()}',
                style: TextStyle(
                    fontFamily: 'Source Sans Pro', color: Colors.orange, fontSize: 25, fontStyle: FontStyle.italic, ),
              ),
            ),
            DetailHeader(userCart: userCart),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'List dishes',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 20),
              ),
            ),
            Container(
              height: 500,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: new ListView.builder(
                  itemCount: dishes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemDish(dish: dishes[index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> getPayment({String id}) async {
    final sharedPref = await SharedPreferences.getInstance();
    String token = sharedPref.getString(Constants.USER_TOKEN);
    await AppApiService.create().getPayment(token: token, id: id).then(
            (onValue) async {
          String urlSession = onValue.body.data.id;
          String url = "http://139.180.131.30/client/payment/mobile/$urlSession";
          if (await canLaunch(url)) {
            await launch(url);
            /*Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen()),
                    (Route<dynamic> route) => false);*/
          } else {
            throw 'Could not launch $url';
          }
        }, onError: setError);
  }

  void setError(dynamic error) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }
}