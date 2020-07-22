import 'dart:async';

import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/rate_dish_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/custom_icons.dart';
import 'package:party_booking/screen/dish_detail/components/badge_add_to_cart.dart';
import 'package:party_booking/screen/dish_detail/components/fab_dish_detail.dart';
import 'package:party_booking/screen/dish_detail/components/header.dart';
import 'package:party_booking/screen/dish_detail/components/image_list_slider.dart';
import 'package:party_booking/widgets/common/dialog_util.dart';
import 'package:party_booking/widgets/common/utiu.dart';

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
  RateDataModel _rateDataModel = RateDataModel();
  int currentPage = 1;

  @override
  void initState() {
    _dishModel = widget.dishModel;
    _getListRate(widget.dishModel.id, 1);
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(controller);
  }

  Future<void> _getListRate(String id, int page) async {
    var result = await AppApiService.create().getRate(id, page);
    if (result.isSuccessful) {
      setState(() {
        if (page == 1) {
          _rateDataModel = result.body.rateData;
        } else {
          _rateDataModel.listRate.addAll(result.body.rateData.listRate);
          _rateDataModel.end = result.body.rateData.end;
        }
      });
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message);
    }
  }

  Widget _contentDish(List<ListRate> listRate) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: (listRate?.length ??= 0) + 2,
        itemBuilder: (context, index) => _locationItem(index, listRate));
  }

  Widget _locationItem(
    int index,
    List<ListRate> listRate,
  ) {
    if (index == 0) {
      return HeaderDishDetail(dishModel: _dishModel, rateDataModel: _rateDataModel,);
    } else if (index == listRate.length + 1) {
      if ((_rateDataModel.end ??= 0) < (_rateDataModel.totalPage * 10 - 1)) {
        return Container(
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
              onTap: () {
                currentPage++;
                _getListRate(_dishModel.id, currentPage);
              },
              child: Icon(
                CustomIcons.ic_more,
                size: 35,
              )),
        );
      } else
        return SizedBox();
    } else {
      return ItemRating(
        itemModel: listRate[index - 1],
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
            ? BadgeAddToCart(dishModel: widget.dishModel,)
            : SizedBox(),
      ],
    );

    double _contentHeight = MediaQuery.of(context).size.height -
        250 -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: _appBar,
      floatingActionButton: FabDishDetail(accountModel: widget.accountModel, dishModel: _dishModel, showRateDialog: () => _showRateDialog(),),
      body: Column(
        children: <Widget>[
          ImageListSlider(images: _dishModel.image),
          Container(
            height: _contentHeight,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SlideTransition(
              position: offset,
              child:
                  _contentDish((_rateDataModel?.listRate ??= List<ListRate>())),
            ),
          )
        ],
      ),
    );
  }

  void _showRateDialog() async {
    String currentUsername = widget.accountModel.username;
    String rateId = "";
    _rateDataModel.listRate.forEach((rateItem) {
      if (rateItem.userRate == currentUsername) rateId = rateItem.id;
    });
    bool isUpdateListComment =
        await DialogUTiu.showDialogRating(context, _dishModel.id, rateId);
    if (isUpdateListComment) {
      _getListRate(_dishModel.id, 1);
    }
  }
}
