import 'package:flutter/material.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/screen/change_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final usernameField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButton = FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'Login',
        style: TextStyle(color: Colors.blue, fontSize: 18),
      ),
    );

    final nextToResetPasswordButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
        },
        child: Text('Next',
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 36, right: 36),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                ClipOval(
                  child: Image.asset(
                    Assets.icLogoApp,
                    fit: BoxFit.fill,
                    height: 200.0,
                  ),
                ),
                SizedBox(height: 120.0),
                usernameField,
                SizedBox(
                  height: 35.0,
                ),
                nextToResetPasswordButton,
                SizedBox(
                  height: 5,
                ),
                loginButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}
