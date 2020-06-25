import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/change_password_request_model.dart';
import 'package:party_booking/data/network/model/change_password_request_model_2.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String username;
  final String avatarUrl;

  ChangePasswordScreen({this.username, this.avatarUrl});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  int _stateChangeButton = 0;
  bool isChangePassword = false;

  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
    FormBuilderValidators.minLength(6,
        errorText: 'Value must have at least 6 characters'),
  ];

  @override
  void initState() {
    isChangePassword = widget.avatarUrl != null;
    super.initState();
  }

  void _changePasswordClicked(BuildContext context) async {
    if (_fbKey.currentState.saveAndValidate()) {
      setState(() {
        _stateChangeButton = 1;
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
                password: code, new_password: newPassword));
      }else {
        result = await AppApiService.create().confirmResetPassword(
            model: ConfirmResetPasswordRequestModel(
                code: code, password: newPassword, username: widget.username));
      }


      if (result.isSuccessful) {
        UTiu.showToast(result.body.message);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
      }else {
        setState(() {
          _stateChangeButton = 3;
        });
        Timer(Duration(milliseconds: 1500), () {
          setState(() {
            _stateChangeButton = 0;
          });
        });
        BaseResponseModel model = BaseResponseModel.fromJson(result.error);
        UTiu.showToast(model.message);
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
                  mValidators: listValidators,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFieldWidget(
                  mHindText: 'New Password',
                  mAttribute: 'new_password',
                  mShowObscureText: true,
                  mValidators: listValidators,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFieldWidget(
                  mAttribute: 'retype_password',
                  mHindText: 'Retype Password',
                  mShowObscureText: true,
                  mValidators: [...listValidators, validator],
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
