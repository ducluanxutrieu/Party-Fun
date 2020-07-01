import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiUtiu{
  static showToast({@required String message, isFalse = false}){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: isFalse ? Colors.red : Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }
}