import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/rate_dish_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/res/custom_icons_icons.dart';
import 'package:party_booking/widgets/common/dialog_util.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:scoped_model/scoped_model.dart';

import '../badges.dart';
import 'modify_disk/modify_dish_screen.dart';

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
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
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

  Widget _titleDish() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Text(
          _dishModel.name,
          style: TextStyle(
            color: Colors.green,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          _getListCategory(),
          style: style.copyWith(fontSize: 22),
        ),
        Row(
          children: <Widget>[
            RatingBar(
              itemCount: 5,
              initialRating:
                  double.parse((_rateDataModel?.avgRate ??= 0).toString()),
              minRating: 1,
              allowHalfRating: true,
              direction: Axis.horizontal,
              itemSize: 30,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: null,
            ),
            Text(" (${_rateDataModel.countRate} users rating)", style: style.copyWith(color: Colors.green),),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          _dishModel.description,
          overflow: TextOverflow.clip,
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Text(
            'List Rated',
            style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _itemListRating(ListRate itemModel) {
    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            itemModel.avatar,
          ),
          backgroundColor: Colors.transparent,
        ),
        title: Row(
          children: <Widget>[
            Text(
              itemModel.userRate,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Spacer(),
            DialogUTiu.ratingBar(itemModel.score.toDouble(), 22, null)
          ],
        ),
        subtitle: Text(
          itemModel.comment,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _locationItem(
    int index,
    List<ListRate> listRate,
  ) {
    if (index == 0) {
      return _titleDish();
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
            child: Icon(CustomIcons.ic_more, size: 35,)
          ),
        );
      } else
        return SizedBox();
    } else {
      return _itemListRating(listRate[index - 1]);
    }
  }

  Widget _headerDish() {
    return Stack(
      children: <Widget>[
        Image.asset(
          Assets.imgDishDetail,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: 250,
        ),
        CarouselSlider(
          height: 250,
          initialPage: 1,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          viewportFraction: 0.8,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: Duration(seconds: 10),
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          items: UiUtiu.mapIndexed(
            _dishModel.image,
            (index, value) => Container(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageUrl: value,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
              ),
            ),
          ).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 300), () {
      controller.forward();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(_dishModel.name),
        actions: <Widget>[
          widget.accountModel != null ? _shoppingCartBadge(widget.dishModel) : SizedBox(),
        ],
      ),
      floatingActionButton: _buildFABEditDish(context),
      body: Column(
        children: <Widget>[
          _headerDish(),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SlideTransition(
                position: offset,
                child: _contentDish(
                    (_rateDataModel?.listRate ??= List<ListRate>())),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _getListCategory() {
    String category = "";
    _dishModel.categories.forEach((element) {
      category += "$element\n";
    });
    return category;
  }

  FloatingActionButton _buildFABEditDish(BuildContext context) {
    
    bool isStaff = widget.accountModel != null && (widget.accountModel.role == UserRole.Staff.index ||
        widget.accountModel.role == UserRole.Admin.index);

    return isStaff
        ? FloatingActionButton.extended(
            onPressed: () => _goToUpdateDish(context),
            label: Text('Edit'),
            icon: Icon(FontAwesomeIcons.edit),
            tooltip: 'Edit this dish',
          )
        : FloatingActionButton.extended(
            onPressed: () => _showRateDialog(),
            label: Text('Rating'),
            icon: Icon(CustomIcons.ic_rating),
            tooltip: 'Write your review!',
          );
  }

  _goToUpdateDish(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ModifyDishScreen(dishModel: _dishModel)));
    if (result != null) {
      setState(() {
        Navigator.maybePop(context, true);
      });
    }
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

  Widget _shoppingCartBadge(DishModel dishModel) {
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
            //  Navigator.pushNamed(context, '/cart');
            ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                .addProduct(dishModel);
          }),
    );
  }
}
