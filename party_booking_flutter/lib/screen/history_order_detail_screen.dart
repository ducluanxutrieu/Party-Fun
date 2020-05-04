import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/get_user_profile_response_model.dart';

import 'home_view.dart';

class Home extends StatefulWidget {
  UserCart userCart;
  Home({@required this.userCart});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  UserCart _userCart;
  List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _userCart = widget.userCart;
    _children = [
      HistoryOrder(
        userCart: _userCart,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DISH DETAIL"),
      ),
      body: _children[_currentIndex],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
