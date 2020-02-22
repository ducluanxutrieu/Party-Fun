import 'package:flutter/material.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/res/colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              Assets.imgSignInBackground,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: size.height * 0.2,
            left: 50,
            right: 50,
            child: _buildLoginForm(context, size),
          ),
          Positioned(
            bottom: size.height * 0.05,
            left: 0,
            right: 0,
            child: Center(
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  "Forgot your password",
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, Size size) {
    return Card(
      child: Container(
        height: size.height * 0.55,
        color: AppColors.white,
        padding: EdgeInsets.all(32),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Login",
                style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "To cha bay",
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "To cha bay",
                ),
              ),
              SizedBox(
                height: 24,
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Colors.deepOrange,
                  onPressed: () {},
                  child: Text(
                    "Sign in".toUpperCase(),
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (buildContext) => InkWell(
                  onTap: () {
                    Scaffold.of(buildContext)
                        .showSnackBar(SnackBar(content: Text("Hello")));
                  },
                  child: Text(
                    "Create account",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
