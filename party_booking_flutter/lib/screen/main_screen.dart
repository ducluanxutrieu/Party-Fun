import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/account_model.dart';
import 'package:party_booking/data/network/model/dish_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _fullNameUser = "";
  String _token = "";
  final _listDishesModel = List<DishModel>();

  bool alredyInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(alredyInit == false){
      alredyInit = true;
      getNameUser();
    }
  }

  void getNameUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accountJson = prefs.getString(Constants.ACCOUNT_MODEL_KEY);
    final AccountModel accountModel = AccountModel.fromJson(accountJson);
    setState(() {
      _fullNameUser = accountModel.fullName;
      _token = accountModel.token;
      print(_fullNameUser);
    });
  }

//  final items = List<String>.generate(10000, (i) => "Item $i");
//  BuiltList<String> listImage = BuiltList<String>();
//  final nameList = List<DishModel>.generate(10, (i) => DishModel.create("Name $i", "Description $i", i*1000, "Main", listImage));

  void getListDishes() async {
    var result = await AppApiService.create().getListDishes(token: _token);
    setState(() {
      _listDishesModel.addAll(result.body.dishModel.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final listView = ListView.builder(
      itemCount: _listDishesModel.length,
      itemBuilder: (context, index) {
        return itemCard(_listDishesModel[index]);
      },
    );
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
            AppButtonWidget(
              buttonText: "Temp",
              buttonHandler: getListDishes,
            ),
            Expanded(child: listView,),
          ],
        ),
      ),
    );
  }

  Widget itemCard(DishModel model) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32))),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(model.price.toString()),
              Image.network(model.image[0]),
              Text(model.name),
            ],
          ),
        ),
      ),
    );
  }
}
