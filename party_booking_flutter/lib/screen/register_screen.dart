import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/network/model/register_request_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:party_booking/widgets/common/utiu.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];

  void onRegisterClicked() async {
    if(_fbKey.currentState.saveAndValidate()) {
      final fullName = _fbKey.currentState.fields['fullname'].currentState
          .value;
      final username = _fbKey.currentState.fields['username'].currentState
          .value;
      final email = _fbKey.currentState.fields['email'].currentState.value;
      final phoneNumber =
          _fbKey.currentState.fields['phonenumber'].currentState.value;
      final password = _fbKey.currentState.fields['password'].currentState
          .value;
      final model = RegisterRequestModel(
          fullName: fullName,
          username: username,
          email: email,
          password: password,
          phoneNumber: phoneNumber);

      final result = await AppApiService.create().requestRegister(model: model);
      if (result.isSuccessful) {
        Navigator.pop(context);
      }
      UTiu.showToast(result.body.message);
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

    var validatorRePassword = (dynamic value) {
      if (value != _fbKey.currentState.fields['password'].currentState.value) {
        return 'Password is not matching';
      } else
        return null;
    };

    return Scaffold(
      body: Center(
        child: FormBuilder(
          key: _fbKey,
          autovalidate: false,
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
                      height: 40,
                    ),
                    ClipOval(
                      child: Image.asset(
                        Assets.icLogoApp,
                        fit: BoxFit.fill,
                        height: 150.0,
                      ),
                    ),
                    SizedBox(height: 50.0),
                    TextFieldWidget(
                      mAttribute: 'fullname',
                      mHindText: 'Full Name',
                      mValidators: [
                        ...listValidators,
                        FormBuilderValidators.minLength(6)
                      ],
                    ),
                    SizedBox(height: 15.0),
                    TextFieldWidget(
                      mAttribute: 'username',
                      mHindText: 'Username',
                      mValidators: [
                        ...listValidators,
                        (dynamic value) {
                          if ((value as String).contains(" ")) {
                            return 'Username invalid';
                          } else
                            return null;
                        }
                      ],
                    ),
                    SizedBox(height: 15.0),
                    TextFieldWidget(
                      mAttribute: 'email',
                      mHindText: 'Email',
                      mValidators: [
                        ...listValidators,
                        FormBuilderValidators.email()
                      ],
                      mTextInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 15.0),
                    TextFieldWidget(
                      mAttribute: 'phonenumber',
                      mHindText: 'Phone Number',
                      mTextInputType: TextInputType.phone,
                      mValidators: [
                        ...listValidators,
                        FormBuilderValidators.numeric(
                            errorText: "Phone number invalid")
                      ],
                    ),
                    SizedBox(height: 15.0),
                    TextFieldWidget(
                      mAttribute: 'password',
                      mHindText: 'Password',
                      mValidators: [
                        ...listValidators,
                        FormBuilderValidators.minLength(6)
                      ],
                      mShowObscureText: true,
                    ),
                    SizedBox(height: 15.0),
                    TextFieldWidget(
                      mAttribute: 'retypepassword',
                      mHindText: 'Retype Password',
                      mValidators: [...listValidators, validatorRePassword],
                      mShowObscureText: true,
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    AppButtonWidget(
                      buttonText: 'Register',
                      buttonHandler: onRegisterClicked,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    loginButton
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
