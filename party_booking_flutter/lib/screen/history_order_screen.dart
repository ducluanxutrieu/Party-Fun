import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history_order_detail/history_order_detail_screen.dart';

class HistoryOrderScreen extends StatelessWidget {
  Future<List<UserCart>> _getHistoryBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.USER_TOKEN);
    var result = await AppApiService.create().getUserHistory(token: token);
    if (result.isSuccessful) {
        return result.body.data.userCarts;
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Order History'),
      ),
      body: FutureBuilder<List<UserCart>>(
        future: _getHistoryBooking(),
        builder: (BuildContext context, AsyncSnapshot<List<UserCart>> snapshot) {
          if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
                return _buildItemCart(snapshot.data[index], context);
            },
          );
          }else return SizedBox();
        },
      ),
    );
  }

  Widget _buildItemCart(UserCart userCart, BuildContext context) {
    final currencyFormat =
        new NumberFormat.currency(locale: "vi_VI", symbol: "₫");
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      color: userCart.paymentStatus == 1 ? Colors.greenAccent : Colors.white,
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HistoryOrderDetailScreen(userCart: userCart),
            ),
          );
        },
        title: Text(
          "Time: ${DateFormat('dd-MM-yyyy HH:mm').format(userCart.dateParty)}",
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("\t" + currencyFormat.format(userCart.total),
            style: TextStyle(fontSize: 18, color: Colors.black54)),
        trailing: userCart.paymentStatus == 1
            ? Icon(FontAwesomeIcons.solidCheckCircle)
            : SizedBox(),
      ),
    );
  }
}
