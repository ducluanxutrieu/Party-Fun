import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/cart/cart_bloc.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/ui/search/home_search.dart';

import '../../../badges.dart';

class MainAppBar extends StatelessWidget {
  MainAppBar({
    Key key,
    this.accountModel,
  }): super(key: key);

  final AccountModel accountModel;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(accountModel.fullName),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeSearch(accountModel),
                ))),
        _shoppingCartBadge(context),
      ],
    );
  }

  Widget _shoppingCartBadge(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) => Badge(
        position: BadgePosition.topRight(top: 0, right: 3),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
        badgeContent: Text(
          state.totalItem.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: Hero(
          tag: 'search_id',
          child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              }),
        ),
      ),
    );
  }
}
