import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:party_booking/data/network/model/account_model.dart';
import 'package:party_booking/data/network/model/login_request_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/forgot_password_screen.dart';
import 'package:party_booking/screen/main_screen.dart';
import 'package:party_booking/screen/register_screen.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];

  saveDataToPrefs(AccountModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.ACCOUNT_MODEL_KEY, model.toJson());
  }

  void requestLogin(String username, String password) async {
    var model = LoginRequestModel.fromModel(username, password);
    var result = await AppApiService.create().requestSignIn(model: model);
    if(result.isSuccessful){
      Fluttertoast.showToast(
          msg: result.body.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      saveDataToPrefs(result.body.account);
    } else{
      Fluttertoast.showToast(
          msg: result.error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  checkAlreadyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs
        .getString(Constants.ACCOUNT_MODEL_KEY) != null && prefs
        .getString(Constants.ACCOUNT_MODEL_KEY)
        .isNotEmpty) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkAlreadyLogin();

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

    final forgotPasswordButton = FlatButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
      },
      child: Text(
        "Forgot your password",
        style: TextStyle(color: Colors.blue, fontSize: 16),
      ),
    );

    void onLoginPressed() {
      String username = _fbKey.currentState.fields['username'].currentState
          .value;
      String password = _fbKey.currentState.fields['password'].currentState
          .value;
      requestLogin(username, password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    }

    return Scaffold(
      body: Center(
        child: FormBuilder(
          key: _fbKey,
          autovalidate: true,
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
                    SizedBox(height: 80,),
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
                      mValidators: listValidators,
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    AppButtonWidget(
                      buttonText: 'Login',
                      buttonHandler: onLoginPressed,
                    ),
                    SizedBox(height: 5,),
                    createNewAccountButton,
                    SizedBox(height: 40,),
                    forgotPasswordButton,
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
