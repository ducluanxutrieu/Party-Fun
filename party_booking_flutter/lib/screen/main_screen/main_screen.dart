import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/authentication/bloc/authentication_bloc.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/home/bloc/home_bloc.dart';
import 'package:party_booking/screen/modify_disk/modify_dish_screen.dart';
import 'package:party_booking/src/dish_repository.dart';

import 'components/drawer.dart';
import 'components/main_app_bar.dart';
import 'components/main_list_menu.dart';

class MainScreen extends StatefulWidget {
  static Route route(AccountModel accountModel) {
    return MaterialPageRoute<void>(builder: (_) => MainScreen());
  }

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle;

  final TextEditingController _filter = new TextEditingController();

  void _initSearch(BuildContext context) {
    _filter.addListener(() {
      String searchText = _filter.text;
      context.bloc<HomeBloc>().add(OnSearchDishChangeEvent(searchText));
    });
  }

  void _searchPressed(String fullName) {
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
        this._appBarTitle = new Text(fullName);
        _filter.clear();
      }
    });
  }

  void _goToAddDish(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ModifyDishScreen()));
  }

  @override
  Widget build(BuildContext context) {
    _initSearch(context);
    context.bloc<HomeBloc>().add(GetListDishEvent());
    return BlocProvider(
      create: (context) =>
          HomeBloc(dishRepository: RepositoryProvider.of<DishRepository>(context)),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previous, current) => previous.status != current.status || previous.status != current.status,
        builder: (context, authState) {
          this._appBarTitle = new Text(authState.user.fullName);
          return BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) => (previous.listMenu != current.listMenu || previous.status != current.status),
            builder: (context, homeState) {
              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: MainAppBar(
                    appBarTitle: _appBarTitle,
                    searchIcon: _searchIcon,
                    searchPressed: () {
                      _searchPressed(authState.user.fullName);
                    },
                  ),
                ),
                floatingActionButton: buildFABAddNewDish(context, authState.user),
                drawer: MainDrawer(
                  accountModel: authState.user,
                ),
                body: RefreshIndicator(
                  onRefresh: () {
                    context.bloc<HomeBloc>().add(GetListDishEvent());
                    return;
                  },
                  child: MainListMenu(
                    accountModel: authState.user,
                    listMenu: homeState.listMenu,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Visibility buildFABAddNewDish(BuildContext context, AccountModel accountModel) {
    bool isVisible =
        (accountModel != null && accountModel.role == Role.Staff.index);
    return Visibility(
      visible: isVisible,
      child: FloatingActionButton(
        onPressed: () => _goToAddDish(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
