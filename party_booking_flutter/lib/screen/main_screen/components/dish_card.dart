import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/screen/main_screen/components/add_to_cart_dialog.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../dish_detail/dish_detail_screen.dart';

class DishCard extends StatelessWidget {
  final DishModel dishModel;
  final AccountModel accountModel;
  final Function getListDish;

  const DishCard({Key key, this.dishModel, this.accountModel, this.getListDish})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartModel>(builder: (context, child, model) {
      return Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          child: InkWell(
            onTap: () => _goToDishDetail(context, dishModel),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    _cartDishPriceWidget(dishModel),
                    Spacer(),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.cartPlus),
                      onPressed: () {
                        int totalItem = ScopedModel.of<CartModel>(context, rebuildOnChange: true).calculateTotalItem();
                        AddToCartDialog.addDishToCartAnimation(context, totalItem);
                        model.addProduct(dishModel);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                _itemCardImage(dishModel.image[0], dishModel.id),
                SizedBox(
                  height: 5,
                ),
                Text(
                  dishModel.name,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(fontSize: 17.0, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _goToDishDetail(BuildContext context, DishModel dishModel) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DishDetailScreen(
                dishModel: dishModel, accountModel: accountModel)));
    if (result != null && result) {
      print('dishCart');
      getListDish();
    }
  }

  Widget _cartDishPriceWidget(DishModel dishModel) {
    final currencyFormat =
        new NumberFormat.currency(locale: "vi_VI", symbol: "₫");
    String price = currencyFormat.format(dishModel.price);
    String priceNew = currencyFormat.format(dishModel.priceNew);
    if (dishModel.discount != 0) {
      return Column(
        children: <Widget>[
          Text(
            price,
            style: new TextStyle(
                fontSize: 17.0,
                color: Colors.black,
                decoration: TextDecoration.lineThrough),
          ),
          Text(
            priceNew,
            style: new TextStyle(
                fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
    return Text(
      price,
      style: new TextStyle(fontSize: 20.0, color: Colors.black),
    );
  }

  Widget _itemCardImage(String image, String id) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        placeholder: (context, url) => Container(
            width: 150,
            height: 150,
            padding: EdgeInsets.all(50),
            child: CircularProgressIndicator()),
        imageUrl: image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 150,
      ),
    );
  }
}
