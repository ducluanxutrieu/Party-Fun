import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/res/assets.dart';

import '../../cart_detail_screen.dart';

class AddToCartDialog{
  static void addDishToCartDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (bCtx) {
          Timer(Duration(milliseconds: 700), () {
            Navigator.pop(context);
            dialog(context);
          });
          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.5),
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
                        Assets.animAddToCart,
                        repeat: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

static void dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (bCtx) {
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
                      Text(
                        'Added to your Cart',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Do you want to check your Cart ?',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              _actionButton('Cancel', () {
                Navigator.of(bCtx).pop();
              }),
              _actionButton('Yes', () {
                Navigator.of(bCtx).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage()));
              }),
            ],
          );
        });
  }

    static Widget _actionButton(String text, Function handle) {
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
        ));
  }
}