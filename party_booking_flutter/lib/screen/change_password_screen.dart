import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/change_password_request_model.dart';
import 'package:party_booking/data/network/model/change_password_request_model_2.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/res/static_variable.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String username;
  final String avatarUrl;

  ChangePasswordScreen({this.username, this.avatarUrl});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  AppButtonState _stateChangeButton = AppButtonState.None;
  bool isChangePassword = false;

  @override
  void initState() {
    isChangePassword = widget.avatarUrl != null;
    super.initState();
  }

  void _changePasswordClicked(BuildContext context) async {
    if (_fbKey.currentState.saveAndValidate()) {
      setState(() {
        _stateChangeButton = AppButtonState.Loading;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Constants.USER_TOKEN);

      String code = _fbKey.currentState.fields['code'].currentState.value;
      String newPassword =
          _fbKey.currentState.fields['new_password'].currentState.value;

      var result;
      if(isChangePassword) {
        result = await AppApiService.create().changePassword(
            token: token,
            model: ConfirmChangePasswordRequestModel(
                password: code, newPassword: newPassword));
      }else {
        result = await AppApiService.create().confirmResetPassword(
            model: ConfirmResetPasswordRequestModel(
                code: code, password: newPassword, username: widget.username));
      }


      if (result.isSuccessful) {
        UiUtiu.showToast(message: result.body.message);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
      }else {
        setState(() {
          _stateChangeButton = AppButtonState.Error;
        });
        Timer(Duration(milliseconds: 1500), () {
          setState(() {
            _stateChangeButton = AppButtonState.None;
          });
        });
        BaseResponseModel model = BaseResponseModel.fromJson(result.error);
        UiUtiu.showToast(message: model.message, isFalse: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var validator = (dynamic value) {
      if (value !=
          _fbKey.currentState.fields['new_password'].currentState.value) {
        return 'Password is not matching';
      } else
        return null;
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.username == null ? 'Change Password' : ' Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 36, right: 36),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _fbKey,
            autovalidate: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LogoAppWidget(
                  mLogoSize: 150,
                  imageUrl: widget.avatarUrl,
                ),
                SizedBox(
                  height: 80.0,
                ),
                TextFieldWidget(
                  mHindText: isChangePassword ? 'Your Password': 'Code',
                  mAttribute: 'code',
                  mValidators: StaticVariable.listValidatorsMinSix,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFieldWidget(
                  mHindText: 'New Password',
                  mAttribute: 'new_password',
                  mShowObscureText: true,
                  mValidators: StaticVariable.listValidatorsMinSix,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFieldWidget(
                  mAttribute: 'retype_password',
                  mHindText: 'Retype Password',
                  mShowObscureText: true,
                  mValidators: [...StaticVariable.listValidatorsMinSix, validator],
                ),
                SizedBox(
                  height: 30,
                ),
                AppButtonWidget(
                  buttonText: 'Change',
                  buttonHandler: () => _changePasswordClicked(context),
                  stateButton: _stateChangeButton,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
