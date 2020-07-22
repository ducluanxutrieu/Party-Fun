import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/res/static_variable.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> fbKey;
  final Function countryCodeChange;
  const RegisterForm({Key key, @required this.fbKey, this.countryCodeChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width - 72;

    var validatorRePassword = (dynamic value) {
      if (value != fbKey.currentState.fields['password'].currentState.value) {
        return 'Password is not matching';
      } else
        return null;
    };

    return FormBuilder(
      key: fbKey,
      autovalidate: false,
      initialValue: {'country_code': '+84'},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          LogoAppWidget(
            mLogoSize: 150,
          ),
          SizedBox(height: 50.0),
          TextFieldWidget(
            mAttribute: 'fullname',
            mHindText: 'Full Name',
            mValidators: [
              ...StaticVariable.listValidatorsRequired,
              FormBuilderValidators.minLength(6)
            ],
          ),
          SizedBox(height: 15.0),
          TextFieldWidget(
            mAttribute: 'username',
            mHindText: 'Username',
            mValidators: [
              ...StaticVariable.listValidatorsRequired,
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
            mValidators: [...StaticVariable.listValidatorsRequired, FormBuilderValidators.email()],
            mTextInputType: TextInputType.emailAddress,
          ),
          SizedBox(height: 15.0),
          //
          buildPhoneNumber(sizeWidth, StaticVariable.listValidatorsRequired),
          SizedBox(height: 15.0),
          TextFieldWidget(
            mAttribute: 'password',
            mHindText: 'Password',
            mValidators: StaticVariable.listValidatorsMinSix,
            mShowObscureText: true,
          ),
          SizedBox(height: 15.0),
          TextFieldWidget(
            mAttribute: 'retypepassword',
            mHindText: 'Retype Password',
            mValidators: [...StaticVariable.listValidatorsRequired, validatorRePassword],
            mShowObscureText: true,
          ),
          SizedBox(
            height: 35.0,
          ),
        ],
      ),
    );
  }

  Row buildPhoneNumber(double sizeWidth, List<FormFieldValidator> listValidators) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                width: sizeWidth * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.rectangle,
                ),
                child: CountryCodePicker(
                  onChanged: _onCountryChange,
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'VN',
                  favorite: ['+84', 'VN'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                )),
            Container(
              width: sizeWidth * 0.63,
              child: TextFieldWidget(
                mAttribute: 'phonenumber',
                mHindText: 'Phone Number',
                mTextInputType: TextInputType.phone,
                mValidators: [
                  ...listValidators,
                  FormBuilderValidators.numeric(
                      errorText: "Phone number invalid")
                ],
              ),
            ),
          ],
        );
  }

  void _onCountryChange(CountryCode countryCode) {
    countryCodeChange(countryCode.toString());
    print("New Country selected: " + countryCode.toString());
  }
}
