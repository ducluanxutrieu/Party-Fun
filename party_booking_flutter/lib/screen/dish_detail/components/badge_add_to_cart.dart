import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../badges.dart';

class BadgeAddToCart extends StatelessWidget {
  final DishModel dishModel;

  const BadgeAddToCart({Key key, @required this.dishModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      position: BadgePosition.topRight(top: 0, right: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        ScopedModel.of<CartModel>(context, rebuildOnChange: true)
            .calculateTotalItem()
            .toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(
          icon: Icon(FontAwesomeIcons.cartPlus),
          onPressed: () {
            ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                .addProduct(dishModel);
          }),
    );
  }
}