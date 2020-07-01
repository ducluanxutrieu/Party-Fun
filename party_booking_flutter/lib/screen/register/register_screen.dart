import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/register_request_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/screen/register/components/register_form.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/utiu.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  int _stateRegisterButton = 0;
  String _countryCode = '+84';

  void onRegisterClicked() {
    if (_fbKey.currentState.saveAndValidate()) {
      setState(() {
        _stateRegisterButton = 1;
      });

      final fullName =
          _fbKey.currentState.fields['fullname'].currentState.value;
      final username =
          _fbKey.currentState.fields['username'].currentState.value;
      final email = _fbKey.currentState.fields['email'].currentState.value;
      final String phoneNumber =
          _fbKey.currentState.fields['phonenumber'].currentState.value;
      final password =
          _fbKey.currentState.fields['password'].currentState.value;
      String fullPhoneNumber = "";
      if(phoneNumber.startsWith('0'))    {
        fullPhoneNumber = phoneNumber.substring(1);
        fullPhoneNumber = _countryCode + fullPhoneNumber;
      }
      print(fullPhoneNumber);
      final model = RegisterRequestModel(
          fullName: fullName,
          username: username,
          email: email,
          password: password,
          phoneNumber: fullPhoneNumber);

      requestRegister(model);
    }
  }

  void requestRegister(RegisterRequestModel model) async {
    final result = await AppApiService.create().requestRegister(model: model);
    if (result.isSuccessful) {
      UiUtiu.showToast(message: result.body.message);
      setState(() {
        _stateRegisterButton = 2;
      });
      Timer(Duration(milliseconds: 1500), () {
        Navigator.pop(context);
      });
    } else {
      setState(() {
        _stateRegisterButton = 0;
      });
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'Login',
        style: TextStyle(color: Colors.blue, fontSize: 18),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              children: <Widget>[
                RegisterForm(fbKey: _fbKey, countryCodeChange: (countryCode) {
                  _countryCode = countryCode;
                },),
                AppButtonWidget(
                  buttonText: 'Register',
                  buttonHandler: onRegisterClicked,
                  stateButton: _stateRegisterButton,
                ),
                SizedBox(
                  height: 5,
                ),
                loginButton
              ],
            ),
          ),
        ));
  }
}
