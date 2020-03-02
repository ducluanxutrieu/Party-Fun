import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/menu_model.dart';
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
  final _listMenuFiltered = List<MenuModel>();
  AccountModel _accountModel;

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
    if (accountJson != null && accountJson.isNotEmpty) {
      _accountModel = AccountModel.fromJson(json.decode(accountJson));
      _fullNameUser = _accountModel.fullName;
      _token = _accountModel.token;
      getListDishes();
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void getListDishes() async {
    var result = await AppApiService.create().getListDishes(token: _token);
    setState(() {
      _listMenuFiltered.addAll(menuAllocation(result.body.listDishes));
    });
  }

  List<MenuModel> menuAllocation(List<DishModel> dishes) {
    var listMenu = List<MenuModel>();
    var listHolidayOffers = List<DishModel>();
    var listFirstDishes = List<DishModel>();
    var listMainDishes = List<DishModel>();
    var listSeafood = List<DishModel>();
    var listDrink = List<DishModel>();
    var listDessert = List<DishModel>();

    for (var i = 0; i < dishes.length; i++) {
      switch (dishes[i].type) {
        case "Holiday Offers":
          listHolidayOffers.add(dishes[i]);
          break;
        case "First Dishes":
          listFirstDishes.add(dishes[i]);
          break;
        case "Main Dishes":
          listMainDishes.add(dishes[i]);
          break;
        case "Seafood":
          listSeafood.add(dishes[i]);
          break;
        case "Drinks":
          listDrink.add(dishes[i]);
          break;
        case "Dessert":
          listDessert.add(dishes[i]);
          break;
      }
    }

    if (listHolidayOffers.length > 0) {
      listMenu.add(
          MenuModel(menuName: "Holiday Offers", listDish: listHolidayOffers));
    }
    if (listFirstDishes.length > 0) {
      listMenu
          .add(MenuModel(menuName: "First Dishes", listDish: listFirstDishes));
    }
    if (listMainDishes.length > 0) {
      listMenu
          .add(MenuModel(menuName: "Main Dishes", listDish: listMainDishes));
    }
    if (listSeafood.length > 0) {
      listMenu.add(MenuModel(menuName: "Seafood", listDish: listSeafood));
    }
    if (listDrink.length > 0) {
      listMenu.add(MenuModel(menuName: "Drinks", listDish: listDrink));
    }

    if (listDessert.length > 0) {
      listMenu.add(MenuModel(menuName: "Dessert", listDish: listDessert));
    }

    return listMenu;
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, size: 28,),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _fullNameUser,
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                _accountModel.username,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(_accountModel.imageurl),
                backgroundColor: Colors.transparent,
              ),
              accountEmail: Text(
                _accountModel.email,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0),
              ),
            ),
            _createDrawerItem(icon: Icons.home, text: 'Home', onTap: null),
            _createDrawerItem(
                icon: Icons.account_circle, text: 'Profile', onTap: null),
            _createDrawerItem(
                icon: Icons.location_on, text: 'Address', onTap: null),
            _createDrawerItem(
                icon: Icons.history, text: 'My Ordered', onTap: null),
            Divider(),
            ListTile(
              title: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 38.0),
                    child: Text('About Us'),
                  )
                ],
              ),
              onTap: (){},
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Image.asset('assets/images/ic_logout.png', width: 30, height: 30, fit: BoxFit.fill, color: Colors.black,),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Logout'),
                  )
                ],
              ),
              onTap: (){},
            ),
            Center(child: Text(
              'Version\nAlpha 1.0.0', textAlign: TextAlign.center,),),
          ],
        ),
      ),
      body: Flex(direction: Axis.vertical, children: [
        Expanded(
          child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _listMenuFiltered.length,
              itemBuilder: (BuildContext context, int index) {
                return itemMenu(_listMenuFiltered[index]);
              }),
        ),
      ]),
    );
  }

  Widget itemMenu(MenuModel menuModel) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.lightGreen,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(menuModel.menuName,
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            itemGridView(menuModel.listDish),
          ],
        ),
      ],
    );
  }

  Widget itemGridView(List<DishModel> dishes) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      physics: BouncingScrollPhysics(),
      childAspectRatio: 0.9,
      shrinkWrap: true,
      children: List<Widget>.generate(dishes.length, (index) {
        return itemCard(dishes[index]);
      }),
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
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(dishModel.price.toString(),
                  style: new TextStyle(fontSize: 20.0, color: Colors.black)),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  dishModel.image[0],
                  fit: BoxFit.cover,
                  height: 100,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                dishModel.name,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(fontSize: 17.0, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
