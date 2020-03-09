import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/menu_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/login_screen.dart';
import 'package:party_booking/screen/profile.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'dish_detail_screen.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  AccountModel accountModel;

  MainScreen({Key key, @required this.accountModel});

  @override
  _MainScreenState createState() =>
      _MainScreenState(accountModel: accountModel);
}

class _MainScreenState extends State<MainScreen> {
  String _fullNameUser = "PartyBooking";
  String _token = "";
  final _listMenuFiltered = List<MenuModel>();
  AccountModel accountModel;

  _MainScreenState({@required this.accountModel});

  @override
  void initState() {
    super.initState();
    _fullNameUser = accountModel.fullName;
    _token = accountModel.token;
    getListDishes();
  }

  void getListDishes() async {
    var result = await AppApiService.create().getListDishes(token: _token);
    if (result.isSuccessful) {
      setState(() {
        _listMenuFiltered.addAll(menuAllocation(result.body.listDishes));
      });
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UTiu.showToast(model.message);
    }
  }

  void _signOut() async {
    var result = await AppApiService.create().requestSignOut(token: _token);
    if (result.isSuccessful) {
      print(DateTime.now().millisecondsSinceEpoch);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(DateTime.now().millisecondsSinceEpoch);
      prefs.remove(Constants.ACCOUNT_MODEL_KEY);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }
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
                _fullNameUser,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(accountModel.imageurl),
                backgroundColor: Colors.transparent,
              ),
              accountEmail: Text(
                accountModel.email,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0),
              ),
            ),
            _createDrawerItem(icon: Icons.home, text: 'Home', onTap: null),
            _createDrawerItem(
                icon: Icons.account_circle,
                text: 'Profile',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(mAccountModel: accountModel,)));
                  //   Navigator.pop(profile);
                }),
            _createDrawerItem(
                icon: Icons.location_on, text: 'Address', onTap: null),
            _createDrawerItem(
                icon: Icons.history, text: 'My Ordered', onTap: null),
            Divider(),
            _createDrawerItem(
                icon: FontAwesomeIcons.info, text: 'About Us', onTap: null),
            _createDrawerItem(
                icon: FontAwesomeIcons.signOutAlt,
                text: 'Logout',
                onTap: _signOut),
            Center(
              child: Text(
                'Version\nAlpha 1.0.0',
                textAlign: TextAlign.center,
              ),
            ),
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
                return _itemMenu(_listMenuFiltered[index]);
              }),
        ),
      ]),
    );
  }

  Widget _itemMenu(MenuModel menuModel) {
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
        _itemGridView(menuModel.listDish)
      ],
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 28,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _itemGridView(List<DishModel> dishes) {
    return StaggeredGridView.countBuilder(
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      itemCount: dishes.length,
      itemBuilder: (BuildContext context, int index) => _itemCard(dishes[index]),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      primary: false,
      shrinkWrap: true,
    );
  }

  Widget _itemCard(DishModel dishModel) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) =>
                    DishDetailScreen(
                  dishModel: dishModel,
                ),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    dishModel.price.toString(),
                    style: new TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.cartPlus),
                    onPressed: null,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: dishModel.id,
                  child: Image.network(
                    dishModel.image[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
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
