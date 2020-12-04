import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';

import 'forgot_password_submit_button.dart';

class ForgotPasswordForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _fbKey,
      autovalidateMode: AutovalidateMode.always,
      child: Container(
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
                LogoAppWidget(
                  mLogoSize: 150.0,
                ),
                SizedBox(height: 120.0),
                TextFieldWidget(
                  mHindText: "Username",
                  name: "username",
                  mValidators: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                ),
                SizedBox(
                  height: 35.0,
                ),
                SubmitButton(fbKey: _fbKey),
                SizedBox(
                  height: 5,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
