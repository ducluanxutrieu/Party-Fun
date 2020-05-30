import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_categories_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/forgot_password_screen.dart';
import 'package:party_booking/screen/main_screen.dart';
import 'package:party_booking/screen/register_screen.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  int _stateLoginButton = 0;

  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];

  saveDataToPrefs(AccountModel model) async {
    setState(() {
      _stateLoginButton = 2;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.ACCOUNT_MODEL_KEY, accountModelToJson(model));
    prefs.setString(Constants.USER_TOKEN, model.token);
    _getListCategories(prefs, model);
  }

  void _getListCategories(SharedPreferences prefs, AccountModel accountModel, ) async {
    var result = await AppApiService.create().getCategories();
    if (result.isSuccessful) {
      prefs.setString(Constants.LIST_CATEGORIES_KEY, listCategoriesResponseModelToJson(result.body));
      _goToMainScreen(accountModel, result.body.categories);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UTiu.showToast(model.message);
    }
  }

  void _goToMainScreen(accountModel, List<Category> categories) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen(accountModel: accountModel, listCategories: categories,)));
  }

  void requestLogin(String username, String password) async {
    setState(() {
      _stateLoginButton = 1;
    });
    var result = await AppApiService.create().requestSignIn(username: username, password: password);
    if (result.isSuccessful) {
      UTiu.showToast(result.body.message);
      saveDataToPrefs(result.body.account);
    } else {
      setState(() {
        _stateLoginButton = 3;
      });
      Timer(Duration(milliseconds: 1500), () {
        setState(() {
          _stateLoginButton = 0;
        });
      });
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UTiu.showToast(model.message);
    }
  }

  @override
  Widget build(BuildContext context) {

    final createNewAccountButton = FlatButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterScreen()));
      },
      child: Text(
        'Create New Account',
        style: TextStyle(color: Colors.green, fontSize: 18),
      ),
    );

    void onLoginPressed() {
      if(_fbKey.currentState.saveAndValidate()){
        String username =
            _fbKey.currentState.fields['username'].currentState.value;
        String password =
            _fbKey.currentState.fields['password'].currentState.value;
        requestLogin(username, password);
      }
    }

    return Scaffold(
      body: Center(
        child: FormBuilder(
          key: _fbKey,
          autovalidate: false,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    LogoAppWidget(
                      mLogoSize: 150,
                    ),
                    SizedBox(height: 75.0),
                    TextFieldWidget(
                      mHindText: 'Username',
                      mAttribute: 'username',
                      mTextInputType: TextInputType.emailAddress,
                      mValidators: listValidators,
                    ),
                    SizedBox(height: 25.0),
                    TextFieldWidget(
                      mHindText: 'Password',
                      mAttribute: 'password',
                      mShowObscureText: true,
                      mValidators: listValidators,
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    AppButtonWidget(
                      buttonText: 'Login',
                      buttonHandler: onLoginPressed,
                      stateButton: _stateLoginButton,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    createNewAccountButton,
                    SizedBox(
                      height: 40,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                      },
                      child: Text(
                        "Forgot your password",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
