import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/rate_dish_response_model.dart';
import 'package:party_booking/dish/dish_bloc.dart';
import 'package:party_booking/res/custom_icons_icons.dart';
import 'package:party_booking/ui/dish_detail/components/badge_add_to_cart.dart';
import 'package:party_booking/ui/dish_detail/components/fab_dish_detail.dart';
import 'package:party_booking/ui/dish_detail/components/header.dart';
import 'package:party_booking/ui/dish_detail/components/image_list_slider.dart';

import 'components/item_rating.dart';

class DishDetailScreen extends StatelessWidget {
  final DishModel dishModel;
  final AccountModel accountModel;

  DishDetailScreen({Key key, @required this.dishModel, this.accountModel});

  Widget _contentDish() {
    return BlocBuilder<DishBloc, DishState>(
      buildWhen: (previous, current) =>
          previous.rateDataModel != current.rateDataModel ||
          previous.rateDataModel.listRate != current.rateDataModel.listRate,
      builder: (context, state) => CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              ImageListSlider(images: dishModel.image),
              HeaderDishDetail(
                dishModel: dishModel,
                rateDataModel: state.rateDataModel,
              )
            ]),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _locationItem(index, state.rateDataModel, context),
              childCount: (state.rateDataModel?.listRate?.length ?? 0) + 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationItem(
      int index, RateDataModel rateDataModel, BuildContext context) {
    if (index == (rateDataModel?.listRate?.length ?? 0)) {
      if ((rateDataModel?.end ?? 0) <
          ((rateDataModel?.totalPage ?? 1) * 10 - 1)) {
        return Container(
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
              onTap: () => context
                  .read<DishBloc>()
                  .add(GetListRatesEvent(dishModel.id, false)),
              child: Icon(
                CustomIcons.ic_more,
                size: 35,
              )),
        );
      } else
        return SizedBox();
    } else {
      print('Item Rating $index');
      return ItemRating(
        itemModel: rateDataModel?.listRate[index],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBar _appBar = AppBar(
      title: Text(dishModel.name),
      actions: <Widget>[
        accountModel != null
            ? BadgeAddToCart(
                dishModel: dishModel,
              )
            : SizedBox(),
      ],
    );

    return Scaffold(
      appBar: _appBar,
      floatingActionButton: FabDishDetail(
        accountModel: accountModel,
        dishModel: dishModel,
      ),
      body: _contentDish(),
    );
  }
}
