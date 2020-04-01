import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/menu_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/add_new_dish_screen.dart';
import 'package:party_booking/screen/login_screen.dart';
import 'package:party_booking/screen/profile_screen.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var _listMenuFiltered = List<MenuModel>();
  final _listDishOrigin = List<DishModel>();
  AccountModel accountModel;
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle;
  final TextEditingController _filter = new TextEditingController();

  _MainScreenState({@required this.accountModel});

  @override
  void initState() {
    super.initState();
    _getListDishesFromDB();
    _appBarTitle = Text(accountModel.fullName);
    _getListDishes();
    _initSearch();
  }

  void _initSearch(){
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _listMenuFiltered = _menuAllocation(_listDishOrigin);
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  Future<void> _getListDishesFromDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listDishJson = prefs.getString(Constants.LIST_DISH_MODEL_KEY) ?? "";
    if(listDishJson.isNotEmpty) {
      ListDishesResponseModel model = listDishesResponseModelFromJson(listDishJson);
      _initListDishData(model);
    }
  }

  Future<void> _getListDishes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(Constants.USER_TOKEN);

    var result = await AppApiService.create().getListDishes(token: _token);
    if (result.isSuccessful) {
      _initListDishData(result.body);
      prefs.setString(Constants.LIST_DISH_MODEL_KEY, listDishesResponseModelToJson(result.body).toString());
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UTiu.showToast(model.message);
    }
  }

  void _initListDishData(ListDishesResponseModel model){
    setState(() {
      _listMenuFiltered.clear();
      _listDishOrigin.clear();
      _listMenuFiltered.addAll(_menuAllocation(model.listDishes));
      _listDishOrigin.addAll(model.listDishes);
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(accountModel.fullName);
        _listMenuFiltered = _menuAllocation(_listDishOrigin);
        _filter.clear();
      }
    });
  }

  void _signOut() async {
    var result = await AppApiService.create().requestSignOut(token: _token);
    if (result.isSuccessful) {
      print(DateTime.now().millisecondsSinceEpoch);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(DateTime.now().millisecondsSinceEpoch);
      prefs.remove(Constants.ACCOUNT_MODEL_KEY);
      prefs.remove(Constants.USER_TOKEN);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }
  }

  void _goToAddDish() async{
    BaseResponseModel result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewDishScreen()));
    if(result != null){
      _getListDishes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[Padding(
          padding: const EdgeInsets.only(right: 35),
          child: InkWell(onTap: _searchPressed, child: _searchIcon),
        )],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddDish,
        child: Icon(Icons.add),
      ),
      drawer: _buildAppDrawer(),
      body: Flex(direction: Axis.vertical, children: [
        Expanded(
          child: RefreshIndicator(
              onRefresh: _getListDishes,
              child: _buildList()),
        ),
      ]),
    );
  }

  Widget _buildAppDrawer(){
    return Drawer(
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
              backgroundImage: NetworkImage(accountModel.imageUrl),
              backgroundColor: Colors.transparent,
            ),
            accountEmail: Text(
              accountModel.email,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0),
            ),
          ),
          _createDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () {
                Navigator.pop(context);
              }),
          _createDrawerItem(
              icon: Icons.account_circle,
              text: 'Profile',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          mAccountModel: accountModel,
                        )));
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
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List<DishModel> tempList = new List();
      for (int i = 0; i < _listDishOrigin.length; i++) {
        if (_listDishOrigin[i]
            .name
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(_listDishOrigin[i]);
        }
      }
      setState(() {
        _listMenuFiltered = _menuAllocation(tempList);
      });
    } else {
      setState(() {
        _listMenuFiltered = _menuAllocation(_listDishOrigin);
      });
    }
    return
      _listMenuFiltered.isNotEmpty ? ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(),
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: _listMenuFiltered.length,
          itemBuilder: (BuildContext context, int index) {
            return _itemMenu(_listMenuFiltered[index]);
          })
          : Center(
        child: Lottie.network('https://assets5.lottiefiles.com/datafiles/hYQRPx1PLaUw8znMhjLq2LdMbklnAwVSqzrkB4wG/bag_error.json',
          repeat: true,),
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
      itemBuilder: (BuildContext context, int index) =>
          _itemCard(dishes[index]),
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
              _itemCardImage(dishModel.image[0], dishModel.id),
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

  Widget _itemCardImage(String image, String id){
    image = image.replaceAll('localhost', '139.180.131.30');
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Hero(
          tag: id,
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
                width: double.infinity,
                height: 150,
                padding: EdgeInsets.all(50),
                child: CircularProgressIndicator()),
            imageUrl: image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
          )
      ),
    );
  }

  List<MenuModel> _menuAllocation(List<DishModel> dishes) {
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
}
