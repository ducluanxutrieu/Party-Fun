import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';

class RegisterFillForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> fbKey;
  final Function countryCodeChange;

  const RegisterFillForm(
      {Key key, @required this.fbKey, this.countryCodeChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width - 72;

    var validatorRePassword = (dynamic value) {
      if (value != fbKey.currentState.fields['password'].value) {
        return 'Password is not matching';
      } else
        return null;
    };

    return FormBuilder(
      key: fbKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
            name: 'fullname',
            mHindText: 'Full Name',
            mValidators: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
              FormBuilderValidators.minLength(context, 6)
            ]),
          ),
          SizedBox(height: 15.0),
          TextFieldWidget(
            name: 'username',
            mHindText: 'Username',
            mValidators: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
              (dynamic value) {
                if ((value as String).contains(" ")) {
                  return 'Username invalid';
                } else
                  return null;
              }
            ]),
          ),
          SizedBox(height: 15.0),
          TextFieldWidget(
            name: 'email',
            mHindText: 'Email',
            mValidators: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
              FormBuilderValidators.email(context)
            ]),
            mTextInputType: TextInputType.emailAddress,
          ),
          SizedBox(height: 15.0),
          //
          buildPhoneNumber(context, sizeWidth),
          SizedBox(height: 15.0),
          TextFieldWidget(
            name: 'password',
            mHindText: 'Password',
            mValidators: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
              FormBuilderValidators.minLength(context, 6)
            ]),
            mShowObscureText: true,
          ),
          SizedBox(height: 15.0),
          TextFieldWidget(
            name: 'retypepassword',
            mHindText: 'Retype Password',
            mValidators: FormBuilderValidators.compose(
                [FormBuilderValidators.required(context), validatorRePassword]),
            mShowObscureText: true,
          ),
          SizedBox(
            height: 35.0,
          ),
        ],
      ),
    );
  }

  Row buildPhoneNumber(BuildContext context, double sizeWidth) {
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
              onChanged: (countryCode) =>
                  countryCodeChange(countryCode.toString()),
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
            name: 'phonenumber',
            mHindText: 'Phone Number',
            mTextInputType: TextInputType.phone,
            mValidators: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
              FormBuilderValidators.numeric(context,
                  errorText: "Phone number invalid")
            ]),
          ),
        ),
      ],
    );
  }
}
