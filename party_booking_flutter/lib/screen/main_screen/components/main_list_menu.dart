import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/data/network/model/menu_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';

import 'dish_card.dart';

class MainListMenu extends StatelessWidget {
  final List<MenuModel> listMenu;
  final AccountModel accountModel;

  const MainListMenu({
    Key key,
    @required this.listMenu,
    @required this.accountModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return /*(listMenu != null && listMenu.isNotEmpty)
        ?*/ ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: listMenu.length,
            itemBuilder: (BuildContext context, int index) {
              return _itemMenu(listMenu[index], context);
            });
//        : Center(
//            child: Lottie.asset(
//              Assets.animBagError,
//              repeat: true,
//            ),
//          );
  }

  Widget _itemMenu(MenuModel menuModel, BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          alignment: Alignment.center,
          color: Colors.lightGreen,
          child: new Text(menuModel.menuName,
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        ),
        _itemGridView(menuModel.listDish, context)
      ],
    );
  }

  Widget _itemGridView(List<DishModel> dishes, BuildContext context) {
    return StaggeredGridView.countBuilder(
      scrollDirection: Axis.vertical,
      crossAxisCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
      itemCount: dishes.length,
      itemBuilder: (BuildContext context, int index) => DishCard(
          dishModel: dishes[index],
          accountModel: accountModel,),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      primary: false,
      shrinkWrap: true,
    );
  }
}
