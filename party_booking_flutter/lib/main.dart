import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:party_booking/data/bloc_providers.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/screen/splash_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'screen/cart_detail/cart_detail_screen.dart';


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
    DarkThemeBloc darkThemeBloc = BlocProvider.of(context);
    return BlocProvider(
      bloc: DarkThemeBloc(),
      child: StreamBuilder(
        initialData: false,
        stream: darkThemeBloc.dartThemeEnabledStream,
        builder: (context, snapshot) => ScopedModel<CartModel>(
          model: model,
          child: MaterialApp(
            theme: snapshot.data ? ThemeData.dark() : ThemeData.light(),
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: SplashScreen(),
            routes: {'/cart': (context) => CartPage()},
          ),
        ),
      ),
    );
  }
}

class DarkThemeBloc extends BlocBase {
  StreamController _themeController = StreamController<bool>.broadcast();
  Sink get themeSink => _themeController.sink;
  Stream<bool> get dartThemeEnabledStream => _themeController.stream;

  @override
  void dispose() {
    _themeController.close();
  }

  changeTheme(bool darkEnabled){
    print("luannnnnnnnnnnnnnn");
    print(darkEnabled);
    themeSink.add(darkEnabled);
  }
}
