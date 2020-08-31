import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/cart/cart_bloc.dart';
import 'package:party_booking/home/bloc/home_bloc.dart';

import '../../../badges.dart';

class MainAppBar extends StatelessWidget {
  MainAppBar({
    Key key,
    @required String fullName,
    @required TextEditingController textController,
  })  : _fullName = fullName,
        _filter = textController,
        super(key: key);

  final String _fullName;
  final TextEditingController _filter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          (previous.showSearchField != current.showSearchField),
      builder: (context, state) {
        bool showSearchField = state.showSearchField;
        _setupSearchListen(showSearchField, context);
        return AppBar(
          title: showSearchField
              ? TextField(
                  controller: _filter,
                  autofocus: true,
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search),
                      hintText: 'Search...'),
                )
              : Text(_fullName),
          actions: <Widget>[
            IconButton(
                icon: showSearchField ? Icon(Icons.close) : Icon(Icons.search),
                onPressed: () => {
                      BlocProvider.of<HomeBloc>(context).add(
                          OnSearchPressedEvent(
                              showSearchField: !showSearchField))
                    }),
            _shoppingCartBadge(context),
          ],
        );
      },
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
        child: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            }),
      ),
    );
  }

  void _setupSearchListen(bool showSearchField, BuildContext context) {
    if (showSearchField) {
      _filter.addListener(() {
        String searchText = _filter.text;
        print("LLLLL");
        print(searchText);
        context
            .bloc<HomeBloc>()
            .add(OnSearchDishChangeEvent(searchText: searchText));
      });
    } else {
      _filter.clear();
    }
  }
}
