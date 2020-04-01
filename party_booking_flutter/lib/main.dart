import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'package:party_booking/screen/splashscreen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/screen/cartpage.dart';
import 'package:party_booking/screen/main_screen.dart';
void main() {
  runApp(MyApp(
    model: CartModel(),
  ));
  setupLogging();
}

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name} : ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget {
  final CartModel model;
  const MyApp({Key key, @required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel<CartModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: MainScreen(),
        routes: {'/cart': (context) => CartPage()},
      ),
    );
  }
}