import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/rate_dish_request_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogUTiu {
  static final myController = TextEditingController();

  static Future<bool> showDialogRating(BuildContext context, String dishId, String rateId) async {
    return await showDialog(
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
                      height: 25,
                    ),
                    Text(
                      'Rating this dish',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                      ),
                    ),
                    ratingBar(3, 40, (value) {
                      rateScore = value;
                    })
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              _actionButton('Cancel', () {
                myController.clear();
                Navigator.of(bCtx).pop(false);
              }),
              _actionButton('Review', () {
                String id = rateId.isNotEmpty ? rateId : dishId;
                _requestRating(rateScore, id, rateId.isEmpty, () {
                  myController.clear();
                  Navigator.of(bCtx).pop(true);
                });
              }),
              SizedBox(width: 10,)
            ],
          );
        });
  }

  static Widget _actionButton(String text, Function handle) {
    return InkWell(
      onTap: handle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: kPrimaryTextStyle.copyWith(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        ),
      ),
    );
  }

  static Widget ratingBar(
      double coreRating, double itemSize, void onRating(value)) {
    return RatingBar.builder(
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

  static Widget _getIconRating(int index) {
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

  static void _requestRating(double rateScore, String dishId, bool isAddNewRate, Function handle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.USER_TOKEN);
    var result;
    if(isAddNewRate) {
      result = await AppApiService.create().requestRating(
        token: token,
        model: RateDishRequestModel(
            id: dishId, comment: myController.text, rateScore: rateScore),
      );
    } else {
      result = await AppApiService.create().updateRating(
        token: token,
        model: RateDishRequestModel(
            id: dishId, comment: myController.text, rateScore: rateScore),
      );
    }

    if (result.isSuccessful) {
      UiUtiu.showToast(message: result.body.message);
      handle();
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
  }
}
