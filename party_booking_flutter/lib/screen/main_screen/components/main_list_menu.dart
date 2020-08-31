import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/menu_model.dart';
import 'package:party_booking/home/bloc/home_bloc.dart';

import 'dish_card.dart';

class MainListMenu extends StatelessWidget {
  final AccountModel accountModel;

  const MainListMenu({
    Key key,
    @required this.accountModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        print('MainListMenu');
        print(state.status);
        print(state.listMenu.length);
        return ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: state.listMenu.length,
            itemBuilder: (BuildContext context, int index) {
              return _itemMenu(state.listMenu[index], context);
            });
      },
    );
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
          color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
          child: new Text(menuModel.menuName,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  )),
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
        accountModel: accountModel,
      ),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      primary: false,
      shrinkWrap: true,
    );
  }
}
