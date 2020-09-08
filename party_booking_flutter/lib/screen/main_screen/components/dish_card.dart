import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/cart/cart_bloc.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';

import '../../dish_detail/dish_detail_screen.dart';

class DishCard extends StatelessWidget {
  final DishModel dishModel;
  final AccountModel accountModel;

  const DishCard({Key key, this.dishModel, this.accountModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      return Card(
        color: Theme.of(context).colorScheme.surface,
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
                    _cartDishPriceWidget(dishModel, context),
                    Spacer(),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.cartPlus),
                      onPressed: () => context.bloc<CartBloc>().add(AddDishToCartEvent(dishModel)),
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
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _goToDishDetail(BuildContext context, DishModel dishModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DishDetailScreen(
                dishModel: dishModel, accountModel: accountModel)));
  }

  Widget _cartDishPriceWidget(DishModel dishModel, BuildContext context) {
    final currencyFormat =
        new NumberFormat.currency(locale: "vi_VI", symbol: "₫");
    String price = currencyFormat.format(dishModel.price);
    String priceNew = currencyFormat.format(dishModel.priceNew);
    if (dishModel.discount != 0) {
      return Column(
        children: <Widget>[
          Text(
            price,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                decoration: TextDecoration.lineThrough
            ),
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
