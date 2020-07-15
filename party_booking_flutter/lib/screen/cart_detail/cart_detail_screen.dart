import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/screen/book_party_screen.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:scoped_model/scoped_model.dart';

import 'components/item_dish.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text("Cart"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.clear_all),
          tooltip: 'Clear All',
          onPressed: () => ScopedModel.of<CartModel>(context).clearCart(),
        ),
      ],
    );

    double listSizeHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        150;

    return Scaffold(
      appBar: appBar,
      body: ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                  .cart
                  .length ==
              0
          ? Center(
              child: Lottie.asset(Assets.animNoCartItem),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: listSizeHeight,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: ScopedModel.of<CartModel>(context,
                              rebuildOnChange: true)
                          .total,
                      itemBuilder: (context, index) {
                        return ItemDish(
                          indexItem: index,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Total: ${ScopedModel.of<CartModel>(context, rebuildOnChange: true).totalMoney}  VND",
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  AppButtonWidget(
                    buttonText: 'Next',
                    buttonHandler: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookPartyScreen()));
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
