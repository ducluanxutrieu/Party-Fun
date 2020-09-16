import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/res/util_functions.dart';

class ItemDish extends StatelessWidget {
  const ItemDish({
    Key key,
    @required this.dish,
  }) : super(key: key);

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat =
        new NumberFormat.currency(locale: "vi_VI", symbol: "₫");

    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: () => UtilFunction.goToDishDetail(dish.id, context),
        contentPadding: EdgeInsets.all(10),
        title: Text(
          dish.name,
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(currencyFormat.format(dish.price),
            style: TextStyle(fontSize: 17, color: Colors.lightBlueAccent)),
        selected: false,
        trailing: Text(
          dish.count.toString(),
          style: TextStyle(fontSize: 20),
        ),
        dense: true,
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(dish.featureImage ??= 'https://pbs.twimg.com/profile_images/1093186805283749890/4yb0033d_400x400.jpg'),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
