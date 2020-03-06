import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/login_screen.dart';
import 'package:party_booking/screen/main_screen.dart';
import 'package:party_booking/widgets/info_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;



class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _fullNameUser = "";
  String _token = "";
  String phone = "";

  String email = "";
  String url = "";

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
     // _token = _accountModel.token;
      email = _accountModel.email;
       phone = _accountModel.phoneNumber;
      // getListDishes();
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void _showDialog(BuildContext context, {String title, String msg}) {
    final dialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[
        RaisedButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (x) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_accountModel.imageurl),
            ),
            Text(
              _accountModel.username,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
              ),
            ),
            Text(
              _accountModel.role,
              style: TextStyle(
                fontFamily: 'Source Sans Pro',
                fontSize: 30.0,
                color: Colors.teal[50],
                letterSpacing: 2.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.teal.shade700,
              ),
            ),
            InfoCard(
              text: _accountModel.fullName,
              icon: Icons.account_box,
            ),
            InfoCard(
              text: _accountModel.phoneNumber,
              icon: Icons.phone,
              onPressed: () async {
                String removeSpaceFromPhoneNumber =
                phone.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                final phoneCall = 'tel:$removeSpaceFromPhoneNumber';

                if (await launcher.canLaunch(phoneCall)) {
                  await launcher.launch(phoneCall);
                } else {
                  _showDialog(
                    context,
                    title: 'Sorry',
                    msg: 'Phone number can not be called. Please try again!',
                  );
                }
              },
            ),
            InfoCard(
              text: _accountModel.email,
              icon: Icons.mail,
              onPressed: () async {
                final emailAddress = 'mailto:$email';

                if (await launcher.canLaunch(emailAddress)) {
                  await launcher.launch(emailAddress);
                } else {
                  _showDialog(
                    context,
                    title: 'Sorry',
                    msg: 'Email can not be send. Please try again!',
                  );
                }
              },
            ),
            InfoCard(
              text: url,
              icon: Icons.web,
              onPressed: () async {
                if (await launcher.canLaunch(url)) {
                  await launcher.launch(url);
                } else {
                  _showDialog(
                    context,
                    title: 'Sorry',
                    msg: 'URL can not be opened. Please try again!',
                  );
                }
              },
            ),
            InfoCard(
              text: 'Việt Nam',
              icon: Icons.location_city,
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MainScreen()));
                //   Navigator.pop(profile);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.green,
      //teal[200],
    );
  }
}
