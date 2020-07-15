import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/rate_dish_response_model.dart';
import 'package:party_booking/res/constants.dart';

class HeaderDishDetail extends StatelessWidget {
  final DishModel dishModel;
  final RateDataModel rateDataModel;

  const HeaderDishDetail({Key key, @required this.dishModel, @required this.rateDataModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            dishModel.name,
            style: TextStyle(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _cartDishPriceWidget(dishModel),
          SizedBox(
            height: 10,
          ),
          Text(
            _getListCategory,
            style: kPrimaryTextStyle.copyWith(fontSize: 22),
          ),
          Row(
            children: <Widget>[
              RatingBar(
                itemCount: 5,
                initialRating:
                    double.parse((rateDataModel?.avgRate ??= 0).toString()),
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
              Text(
                " (${rateDataModel.countRate} users rating)",
                style: kPrimaryTextStyle.copyWith(color: Colors.green),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(dishModel.description,
              overflow: TextOverflow.clip,
              style: kPrimaryTextStyle.copyWith(fontSize: 16)),
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
      ),
    );
  }

  Widget _cartDishPriceWidget(DishModel dishModel) {
    final currencyFormat =
        new NumberFormat.currency(locale: "vi_VI", symbol: "₫");
    String price = currencyFormat.format(dishModel.price);
    String priceNew = currencyFormat.format(dishModel.priceNew);
    if (dishModel.discount != 0) {
      return Row(
        children: <Widget>[
          Text(
            priceNew,
            style: new TextStyle(
                fontSize: 22.0, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            price,
            style: new TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                decoration: TextDecoration.lineThrough),
          ),
        ],
      );
    }
    return Text(
      price,
      style: new TextStyle(fontSize: 20.0, color: Colors.black),
    );
  }

  String get _getListCategory {
    String categoryList = "";
    dishModel.categories.forEach((element) {
      categoryList += "$element,\t";
    });
    return categoryList;
  }
}