import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history_order_detail_screen.dart';

class HistoryOrderScreen extends StatefulWidget {
  @override
  _HistoryOrderScreenState createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<HistoryOrderScreen> {
  List<UserCart> _listUserCart = List();

  void _getHistoryBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.USER_TOKEN);
    var result = await AppApiService.create().getUserHistory(token: token);
    if (result.isSuccessful) {
      setState(() {
        _listUserCart = result.body.data.userCarts;
      });
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UTiu.showToast(message: model.message, isFalse: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _getHistoryBooking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Order History'),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: _listUserCart.length,
        itemBuilder: (context, index) {
          return _buildItemCart(_listUserCart[index]);
        },
      )),
    );
  }

  Widget _buildItemCart(UserCart userCart) {
    final currencyFormat =
        new NumberFormat.currency(locale: "vi_VI", symbol: "₫");
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.green)),
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
            style: TextStyle(fontSize: 18, color: Colors.lightBlueAccent)),
        trailing: userCart.paymentStatus == 1 ? Icon(FontAwesomeIcons.solidCheckCircle) : SizedBox(),
      ),
    );
  }
}
