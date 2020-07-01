import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/screen/history_order_detail/components/header.dart';

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
}