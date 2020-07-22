import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/res/static_variable.dart';

import '../../data/network/model/account_response_model.dart';
import '../../widgets/common/text_field.dart';

class EditProfileForm extends StatelessWidget {
  final AccountModel mAccountModel;
  final GlobalKey<FormBuilderState> fbKey;
  final Function onCountryCodeChange;
  

  const EditProfileForm(
      {Key key,
      @required this.mAccountModel,
      @required this.fbKey,
      @required this.onCountryCodeChange,})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: fbKey,
      autovalidate: false,
      initialValue: {
        'fullname': mAccountModel.fullName,
        'email': mAccountModel.email,
        'phonenumber': (mAccountModel.phoneNumber.toString() ?? 'Empty'),
        'birthday': mAccountModel.birthday,
        'gender': getGenderStringFromIndex(mAccountModel.gender),
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 50.0),
          TextFieldWidget(
            mAttribute: 'fullname',
            mHindText: 'Full Name',
            mValidators: StaticVariable.listValidatorsMinSix
          ),
          SizedBox(height: 15.0),
          TextFieldWidget(
            mAttribute: 'email',
            mHindText: 'Email',
            mValidators: [...StaticVariable.listValidatorsRequired, FormBuilderValidators.email()],
            mTextInputType: TextInputType.emailAddress,
          ),
          SizedBox(height: 15.0),
          buildPhoneNumber(
              MediaQuery.of(context).size.width - 72),
          SizedBox(height: 15.0),
          _showDatePicker(),
          SizedBox(height: 15.0),
          _selectGender(),
          SizedBox(
            height: 35.0,
          ),
        ],
      ),
    );
  }

  Widget _selectGender() {
    return FormBuilderDropdown(
      attribute: "gender",
      style: kPrimaryTextStyle,
      decoration: InputDecoration(
          labelText: "Gender",
          labelStyle: kPrimaryTextStyle,
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      // initialValue: 'Male',
      hint: Text(
        'Select Gender',
        style: kPrimaryTextStyle,
      ),
      validators: StaticVariable.listValidatorsRequired,
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
          .toList(),
    );
  }

  Widget _showDatePicker() {
    return FormBuilderDateTimePicker(
      attribute: "birthday",
      inputType: InputType.date,
      format: DateFormat("MM/dd/yyyy"),
      style: kPrimaryTextStyle,
      decoration: InputDecoration(
          labelText: 'Birthday',
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    );
  }

  Widget buildPhoneNumber(double sizeWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            width: sizeWidth * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.grey,),
              shape: BoxShape.rectangle,
            ),
            child: CountryCodePicker(
              onChanged: (countryCode) => onCountryCodeChange(countryCode),
              initialSelection: mAccountModel.countryCode,
              favorite: ['+84', 'VN'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
            )),
        Container(
          width: sizeWidth * 0.63,
          child: TextFieldWidget(
            mAttribute: 'phonenumber',
            mHindText: 'Phone Number',
            mTextInputType: TextInputType.phone,
            mValidators: [
              ...StaticVariable.listValidatorsRequired,
              FormBuilderValidators.numeric(errorText: "Phone number invalid")
            ],
          ),
        ),
      ],
    );
  }
}
