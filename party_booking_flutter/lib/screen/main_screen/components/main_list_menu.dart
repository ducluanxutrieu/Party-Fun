import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/data/network/model/menu_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';

import 'dish_cart.dart';

class MainListMenu extends StatefulWidget {
  final List<MenuModel> listMenu;
  final AccountModel accountModel;
  final Function onRefresh;

  const MainListMenu({
    Key key,
    @required this.listMenu,
    @required this.accountModel,
    @required this.onRefresh,
  }) : super(key: key);

  @override
  _MainListMenuState createState() => _MainListMenuState();
}

class _MainListMenuState extends State<MainListMenu> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: widget.onRefresh, child: _buildList());
  }

  Widget _buildList() {
    List<MenuModel> listMenu = widget.listMenu;

    return listMenu.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: listMenu.length,
            itemBuilder: (BuildContext context, int index) {
              return _itemMenu(listMenu[index]);
            })
        : Center(
            child: Lottie.asset(
              Assets.animBagError,
              repeat: true,
            ),
          );
  }

  Widget _itemMenu(MenuModel menuModel) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          alignment: Alignment.center,
          color: Colors.lightGreen,
          child: new Text(menuModel.menuName,
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        ),
        _itemGridView(menuModel.listDish)
      ],
    );
  }

  Widget _itemGridView(List<DishModel> dishes) {
    return StaggeredGridView.countBuilder(
      scrollDirection: Axis.vertical,
      crossAxisCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
      itemCount: dishes.length,
      itemBuilder: (BuildContext context, int index) => DishCard(
          dishModel: dishes[index],
          accountModel: widget.accountModel,
          getListDish: () => widget.onRefresh),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      primary: false,
      shrinkWrap: true,
    );
  }
}
