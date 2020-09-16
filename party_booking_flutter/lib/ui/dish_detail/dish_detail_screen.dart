import 'dart:async';

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

class DishDetailScreen extends StatefulWidget {
  final DishModel dishModel;
  final AccountModel accountModel;

  DishDetailScreen({Key key, @required this.dishModel, this.accountModel});

  @override
  _DishDetailScreenState createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;
  DishModel _dishModel;

  @override
  void initState() {
    _dishModel = widget.dishModel;
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(controller);
  }

  Widget _contentDish() {
    return BlocBuilder<DishBloc, DishState>(
      buildWhen: (previous, current) =>
          previous.rateDataModel != current.rateDataModel ||
          previous.rateDataModel.listRate != current.rateDataModel.listRate,
      builder: (context, state) => ListView.builder(
          shrinkWrap: true,
          itemCount: (state.rateDataModel?.listRate?.length ?? 0) + 2,
          itemBuilder: (context, index) =>
              _locationItem(index, state.rateDataModel)),
    );
  }

  Widget _locationItem(int index, RateDataModel rateDataModel) {
    print(rateDataModel?.avgRate);
    print(rateDataModel?.toJson());
    print('_____________');
    if (index == 0) {
      return HeaderDishDetail(
        dishModel: _dishModel,
        rateDataModel: rateDataModel,
      );
    } else if (index == ((rateDataModel?.listRate?.length ?? 0) + 1)) {
      if ((rateDataModel?.end ?? 0) < ((rateDataModel?.totalPage ?? 1) * 10 - 1)) {
        return Container(
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
              onTap: () => context
                  .bloc<DishBloc>()
                  .add(GetListRatesEvent(_dishModel.id, false)),
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
        itemModel: rateDataModel?.listRate[index - 1],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 300), () {
      controller.forward();
    });

    AppBar _appBar = AppBar(
      title: Text(_dishModel.name),
      actions: <Widget>[
        widget.accountModel != null
            ? BadgeAddToCart(
                dishModel: widget.dishModel,
              )
            : SizedBox(),
      ],
    );

    double _contentHeight = MediaQuery.of(context).size.height -
        250 -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: _appBar,
      floatingActionButton: FabDishDetail(
        accountModel: widget.accountModel,
        dishModel: _dishModel,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ImageListSlider(images: _dishModel.image),
            Container(
              height: _contentHeight,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SlideTransition(
                position: offset,
                child: _contentDish(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
