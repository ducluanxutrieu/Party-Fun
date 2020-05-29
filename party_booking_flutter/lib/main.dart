import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/screen/splash_screen.dart';
import 'package:scoped_model/scoped_model.dart';

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
    return ScopedModel<CartModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: SplashScreen(),
      ),
    );
  }
}
