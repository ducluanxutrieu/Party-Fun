import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/cart/cart_bloc.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/screen/book_party_screen.dart';
import 'package:party_booking/widgets/common/app_button.dart';

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
          onPressed: () => context.bloc<CartBloc>().add(ClearCartEvent()),
        ),
      ],
    );

    double listSizeHeight = MediaQuery
        .of(context)
        .size
        .height -
        appBar.preferredSize.height -
        150;

    return BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Scaffold(
            appBar: appBar,
            body: state.listCarts.length == 0
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
                      itemCount: state.listCarts.length,
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
                      "Total: ${state.totalBillPrice}  VND",
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
    );
  }
}