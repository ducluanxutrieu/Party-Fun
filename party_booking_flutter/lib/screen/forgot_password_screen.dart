import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/network/model/change_password_request_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/screen/change_password_screen.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:party_booking/widgets/common/utiu.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  void onNextClicked() async {
    if (_fbKey.currentState.saveAndValidate()) {

      final String username =
          _fbKey.currentState.fields['username'].currentState.value;

      var result = await AppApiService.create().requestResetPassword(
          model: ChangePasswordRequestModel(username: username));
      if (result.isSuccessful) {
        UTiu.showToast(result.body.message);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
//    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: FormBuilder(
        key: _fbKey,
        autovalidate: true,
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
                    mAttribute: "username",
                    mValidators: [FormBuilderValidators.required()],
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  AppButtonWidget(
                    buttonText: 'Next',
                    buttonHandler: onNextClicked,
                  ),
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
      ),
    );
  }
}
