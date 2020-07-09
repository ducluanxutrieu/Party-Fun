import 'dart:async';

import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_categories_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/menu_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/modify_disk/modify_dish_screen.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/drawer.dart';
import 'components/main_app_bar.dart';
import 'components/main_list_menu.dart';

class MainScreen extends StatefulWidget {
  final AccountModel accountModel;
  final List<DishModel> listDishModel;
  final List<Category> listCategories;

  MainScreen(
      {@required this.accountModel,
      @required this.listCategories,
      this.listDishModel});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _listDishOrigin = List<DishModel>();
  List<MenuModel> _listMenuFiltered = List<MenuModel>();
  AccountModel _accountModel;
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle;
  int i = 0;
  final TextEditingController _filter = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _accountModel = widget.accountModel;
    _appBarTitle = Text(widget.accountModel.fullName);
    if (widget.listDishModel == null) {
      _getListDishes(where: 'initState');
    } else {
      _initListDishData(widget.listDishModel);
    }
    _initSearch();
  }

  void _initSearch() {
    _filter.addListener(() {
      String searchText = _filter.text;
      if (searchText.isEmpty) {
        setState(() {
          _listMenuFiltered = _menuAllocation(_listDishOrigin);
        });
      } else {
        if (searchText.isNotEmpty) {
          List<DishModel> tempList = new List();
          for (int i = 0; i < _listDishOrigin.length; i++) {
            if (_listDishOrigin[i]
                .name
                .toLowerCase()
                .contains(searchText.toLowerCase())) {
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
      }
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
        this._appBarTitle = new Text(_accountModel.fullName);
        _listMenuFiltered = _menuAllocation(_listDishOrigin);
        _filter.clear();
      }
    });
  }

  List<MenuModel> _menuAllocation(List<DishModel> dishes) {
    List<Category> listCategories = widget.listCategories;
    var listMenu = List<MenuModel>();

    dishes.forEach((dish) {
      dish.categories.forEach((dishCategory) {
        listCategories.forEach((category) {
          if (dishCategory == category.name) {
            bool haveThisCate = false;
            listMenu.forEach((menu) {
              if (menu.menuName == category.name) {
                menu.listDish.add(dish);
                haveThisCate = true;
              }
            });
            if (!haveThisCate) {
              listMenu
                  .add(MenuModel(menuName: category.name, listDish: [dish]));
            }
          }
        });
      });
    });
    return listMenu;
  }

  void _goToAddDish() async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ModifyDishScreen()));
    if (result != null) {
      print("_goToAddDish: _getListDishes");
      _getListDishes(where: '_goToAddDish');
    }
  }

  Future<void> _getListDishes({String where = ""}) async {
    print(where);
    print('_getListDishes');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(Constants.USER_TOKEN);

    var result = await AppApiService.create().getListDishes(token: _token);
    if (result.isSuccessful) {
      _initListDishData(result.body.listDishes);
      prefs.setString(Constants.LIST_DISH_MODEL_KEY,
          listDishesResponseModelToJson(result.body).toString());
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
    return;
  }

  void _initListDishData(List<DishModel> model) {
    setState(() {
      _listMenuFiltered.clear();
      _listDishOrigin.clear();
      _listDishOrigin.addAll(model);
      _listMenuFiltered.addAll(_menuAllocation(model));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MainAppBar(
          appBarTitle: _appBarTitle,
          searchIcon: _searchIcon,
          searchPressed: () {
            _searchPressed();
          },
        ),
      ),
      floatingActionButton: buildFABAddNewDish(),
      drawer: MainDrawer(accountModel: _accountModel,),
      body: RefreshIndicator(onRefresh: () => _getListDishes(where: 'body'),
        child: MainListMenu(
          accountModel: _accountModel,
          listMenu: _listMenuFiltered,
          onRefresh: () {
            _getListDishes(where: 'body');
          },
        ),
      ),
    );
  }

  Visibility buildFABAddNewDish() {
    bool isVisible =
        (_accountModel != null && _accountModel.role == Role.Staff.index);
    return Visibility(
      visible: isVisible,
      child: FloatingActionButton(
        onPressed: _goToAddDish,
        child: Icon(Icons.add),
      ),
    );
  }
}
