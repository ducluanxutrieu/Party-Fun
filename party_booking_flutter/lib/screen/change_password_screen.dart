import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
    FormBuilderValidators.minLength(6,
        errorText: 'Value must have at least 6 characters'),
  ];

  void _popBackScreen(BuildContext context) {
    if (_fbKey.currentState.saveAndValidate()) {
      Fluttertoast.showToast(
          msg: _fbKey.currentState.fields['old_password'].currentState.value,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
//    Navigator.pushAndRemoveUntil(
//        context,
//        MaterialPageRoute(builder: (context) => LoginScreen()),
//        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var validator = (dynamic value){
      if(value != _fbKey.currentState.fields['new_password'].currentState.value) {
        return 'Password is not matching';
      } else return null;
    };


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 36, right: 36),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _fbKey,
                initialValue: {
                  'date': DateTime.now(),
                  'accept_terms': false,
                },
                autovalidate: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    LogoAppWidget(
                      mLogoSize: 150,
                    ),
                    SizedBox(
                      height: 80.0,
                    ),
                    TextFieldWidget(
                      mHindText: 'Old Password',
                      mAttribute: 'old_password',
                      mShowObscureText: true,
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
                      buttonHandler: () => _popBackScreen(context),
                    )
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