import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/res/custom_icons.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history_order_detail/history_order_detail_screen.dart';

class HistoryOrderScreen extends StatefulWidget {
  @override
  _HistoryOrderScreenState createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<HistoryOrderScreen> {
  int currentPage = 0;
  int totalPage = -1;
  List<UserCart> listUserCart = List<UserCart>();

  _getHistoryBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.USER_TOKEN);
    currentPage++;
    var result = await AppApiService.create()
        .getUserHistory(token: token, page: currentPage);
    if (result.isSuccessful) {
      totalPage = result.body.data.totalPage;
      setState(() => {listUserCart.addAll(result.body.data.userCarts)});
      print(listUserCart.length);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
  }

  @override
  void initState() {
    _getHistoryBooking();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: ListView.builder(
        itemCount: ((listUserCart.length == 0 ? -1 : listUserCart.length) + 1),
        itemBuilder: (context, index) {
          return _locationItem(index, context);
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

  Widget _locationItem(int index, BuildContext context) {
    if (index == listUserCart.length &&
        totalPage != -1 &&
        currentPage < totalPage) {
      return Container(
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
            onTap: () {
              print(currentPage);
              _getHistoryBooking();
            },
            child: Icon(
              CustomIcons.ic_more,
              size: 35,
            )),
      );
    } else {
      if(index == listUserCart.length && currentPage == totalPage)
        return SizedBox();
      return _buildItemCart(listUserCart[index], context);
    }
  }
}
