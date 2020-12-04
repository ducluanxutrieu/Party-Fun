import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:party_booking/authentication/bloc/authentication_bloc.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'dark_theme_item_drawer.dart';
import 'package:party_booking/ui/history_order_list/history_order_screen.dart';
import 'package:party_booking/ui/profile/profile_page.dart';

import '../../about_us_screen.dart';
import '../../list_posts_screen.dart';
import '../../map_screen.dart';
import '../../../cart/cart_bloc.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key key,
    @required AccountModel accountModel,
  })  : _accountModel = accountModel,
        super(key: key);

  final AccountModel _accountModel;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        InkWell(
          onTap: () => _goToProfile(context),
          child: UserAccountsDrawerHeader(
            accountName: Text(
              _accountModel.fullName ??= "",
              style: Theme.of(context).textTheme.headline6,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(_accountModel.avatar ??= ""),
              backgroundColor: Colors.transparent,
            ),
            accountEmail: Text(
              _accountModel.email ??= "",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onDetailsPressed: () => _goToProfile(context),
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
            onTap: () => _goToProfile(context)),
        _createDrawerItem(
            icon: Icons.location_on,
            text: 'Address',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPage(),
                ),
              );
            }),
        _createDrawerItem(
            icon: Icons.history,
            text: 'My Ordered',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryOrderScreen(),
                ),
              );
            }),
        _createDrawerItem(
            icon: FontAwesomeIcons.solidNewspaper,
            text: 'News',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListPostsScreen(),
                ),
              );
            }),
        DarkThemeWidget(),
        Divider(),
        _createDrawerItem(
            icon: FontAwesomeIcons.info,
            text: 'About Us',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutUsScreen()));
            }),
        _createDrawerItem(
            icon: FontAwesomeIcons.signOutAlt,
            text: 'Logout',
            onTap: () => _showDialogConfirmLogout(context)),
        Center(
          child: Text(
            'Version\nAlpha 1.0.0',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ));
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

  _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  void _showDialogConfirmLogout(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext bCtx) {
          return AlertDialog(
            title: Text('Logout!'),
            content: Text('Do you sure want to logout!'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                onPressed: () => {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationLogoutRequested()),
                  BlocProvider.of<CartBloc>(context).add(ClearCartEvent())
                },
                child: Text(
                  'Yes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        });
  }
}
