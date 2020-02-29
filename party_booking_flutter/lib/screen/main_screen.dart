import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _fullNameUser = "";
  String _token = "";
  final _listDishesModel = List<DishModel>();

  bool alreadyInit = false;

  @override
  void initState() {
    super.initState();
    getNameUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (alreadyInit == false) {
      alreadyInit = true;
    }
  }

  void getNameUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accountJson = prefs.getString(Constants.ACCOUNT_MODEL_KEY);
    if (accountJson.isNotEmpty) {
      final AccountModel accountModel =
          AccountModel.fromJson(json.decode(accountJson));
      _fullNameUser = accountModel.fullName;
      _token = accountModel.token;
      getListDishes();
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void getListDishes() async {
    var result = await AppApiService.create().getListDishes(token: _token);
    setState(() {
      _listDishesModel.addAll(result.body.listDishes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_fullNameUser),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                physics: BouncingScrollPhysics(),
                children:
                    List<Widget>.generate(_listDishesModel.length, (index) {
                  return itemCard(_listDishesModel[index]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemCard(DishModel dishModel) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        child: InkWell(
          onTap: (){

          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(dishModel.price.toString()),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  dishModel.image[0],
                  fit: BoxFit.cover,
                  height: 95,
                ),
              ),
              Text(dishModel.name, overflow: TextOverflow.ellipsis,),
            ],
          ),
        ),
      ),
    );
  }
}
