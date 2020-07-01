import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../badges.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    Key key,
    @required Widget appBarTitle,
    @required Icon searchIcon,
    @required Function searchPressed
  })  : _appBarTitle = appBarTitle,
        _searchIcon = searchIcon,
        _searchPressed = searchPressed,
        super(key: key);

  final Widget _appBarTitle;
  final Icon _searchIcon;
  final Function _searchPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _appBarTitle,
      actions: <Widget>[
        IconButton(icon: _searchIcon, onPressed: _searchPressed),
        _shoppingCartBadge(context),
      ],
    );
  }

  Widget _shoppingCartBadge(BuildContext context) {
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
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          }),
    );
  }
}
