import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/rate_dish_request_model.dart';
import 'package:party_booking/data/network/model/update_dish_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/res/custom_icons_icons.dart';
import 'package:party_booking/screen/add_new_dish_screen.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final myController = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  DishModel _dishModel;

  _DishDetailScreenState();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _dishModel = widget.dishModel;
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(controller);
  }

  Widget _contentDish(List<RateItemModel> listRate) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: listRate.length + 1,
        itemBuilder: (context, index) => Container(
            child: (index == 0)
                ? _titleDish()
                : _itemListRating(listRate[index - 1])));
  }

  Widget _ratingBar(double coreRating, double itemSize, void onRating(value)) {
    return RatingBar(
      initialRating: coreRating,
      itemCount: 5,
      minRating: 1,
      allowHalfRating: true,
      direction: Axis.horizontal,
      itemSize: itemSize,
      itemBuilder: (context, index) => _getIconRating(index),
      onRatingUpdate: onRating,
    );
  }

  Widget _titleDish() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RatingBar(
          itemCount: 5,
          initialRating: _dishModel.rate.average,
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

  Widget _itemListRating(RateItemModel itemModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            (itemModel.imageUrl != null)
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      itemModel.imageUrl,
                    ),
                    backgroundColor: Colors.transparent,
                  )
                : Icon(
                    FontAwesomeIcons.userCircle,
                    size: 40,
                  ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  itemModel.username,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                _ratingBar(itemModel.scoreRate.toDouble(), 22, null),
              ],
            ),
          ],
        ),
        Text(
          itemModel.content,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(),
      ],
    );
  }

  Widget _headerDish() {
    return Stack(
      children: <Widget>[
        Hero(
          tag: _dishModel.id,
          child: Image.asset(
            Assets.imgDishDetail,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: 250,
          ),
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
          items: UTiu.mapIndexed(
            _dishModel.image,
            (index, value) => Container(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 150,
                      padding: EdgeInsets.all(50),
                      child: CircularProgressIndicator()),
                  imageUrl: value,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
              ),
            ),
          ).toList(),
        ),
      ],
    );
  }

  Widget _getIconRating(int index) {
    switch (index) {
      case 0:
        return Icon(
          Icons.sentiment_very_dissatisfied,
          color: Colors.red,
        );
      case 1:
        return Icon(
          Icons.sentiment_dissatisfied,
          color: Colors.redAccent,
        );
      case 2:
        return Icon(
          Icons.sentiment_neutral,
          color: Colors.amber,
        );
      case 3:
        return Icon(
          Icons.sentiment_satisfied,
          color: Colors.lightGreen,
        );
      default:
        return Icon(
          Icons.sentiment_very_satisfied,
          color: Colors.green,
        );
    }
  }

  Widget _actionButton(String text, Function handle) {
    return FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.green,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        onPressed: handle,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: style.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  void _dialogRating(BuildContext context) {
    showDialog(
        context: context,
        builder: (bCtx) {
          double rateScore = 3;
          return AlertDialog(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            content: Container(
              width: MediaQuery.of(bCtx).size.width * 2 / 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Lottie.asset(
                        Assets.animReviewDish,
                        repeat: true,
                      ),
                      Text(
                        'Review this dish',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: myController,
                        decoration: InputDecoration(
                            hintText: 'Write your review',
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32))),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Rating this dish',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                        ),
                      ),
                      _ratingBar(3, 40, (value) {
                        rateScore = value;
                      })
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              _actionButton('Cancel', () {
                Navigator.of(bCtx).pop();
              }),
              _actionButton('Review', () {
                _requestRating(rateScore, () {
                  Navigator.of(bCtx).pop();
                });
              })
            ],
          );
        });
  }

  void _requestRating(double rateScore, Function handle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.USER_TOKEN);
    var result = await AppApiService.create().requestRating(
      token: token,
      model: RateDishRequestModel(
          id: _dishModel.id,
          content: myController.text,
          rateScore: rateScore),
    );
    if (result.isSuccessful) {
      UTiu.showToast(result.body.message);
      handle();
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UTiu.showToast(model.message);
    }
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
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              child: Icon(FontAwesomeIcons.cartPlus),
              onTap: null,
            ),
          )
        ],
      ),
      floatingActionButton: _buildFABEditDish(context),
      body: Column(
        children: <Widget>[
          _headerDish(),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 50, 0),
              child: SlideTransition(
                position: offset,
                child: Column(
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
                      _dishModel.type,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 22),
                    ),
                    Expanded(
                        child: _contentDish(_dishModel.rate.lishRate))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  FloatingActionButton _buildFABEditDish(BuildContext context) {
    bool isStaff = widget.accountModel.role == "nhanvien";

    return isStaff ?
    FloatingActionButton.extended(
      onPressed: () => _goToUpdateDish(context),
      label: Text('Edit'),
      icon: Icon(FontAwesomeIcons.edit),
      tooltip: 'Edit this dish',
    ) : FloatingActionButton.extended(
      onPressed: () => _dialogRating(context),
      label: Text('Rating'),
      icon: Icon(CustomIcons.ic_rating),
      tooltip: 'Write your review!',
    );
  }

  _goToUpdateDish(BuildContext context) async {
    DishModel result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewDishScreen(_dishModel)));
    if(result != null){
      setState(() {
        _dishModel = result;
        Navigator.maybePop(context, result);
      });
    }
  }
}
