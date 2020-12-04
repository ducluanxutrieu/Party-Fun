import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/text_field.dart';

import 'submitted_button.dart';

class EditProfileFillForm extends StatelessWidget {
  final AccountModel mAccountModel;
  final GlobalKey<FormBuilderState> fbKey;

  const EditProfileFillForm({
    Key key,
    @required this.mAccountModel,
    @required this.fbKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _countryCode = mAccountModel.countryCode ?? "+84";

    return FormBuilder(
      key: fbKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 50.0),
          TextFieldWidget(
            initialValue: mAccountModel.fullName,
            name: 'full_name',
            mHindText: 'Full Name',
            mValidators: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(context),
                FormBuilderValidators.minLength(context, 6)
              ],
            ),
          ),
          SizedBox(height: 15.0),
          TextFieldWidget(
            name: 'email',
            initialValue: mAccountModel.email,
            mHindText: 'Email',
            mValidators: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
              FormBuilderValidators.email(context),
            ]),
            mTextInputType: TextInputType.emailAddress,
          ),
          SizedBox(height: 15.0),
          buildPhoneNumber(
              context, MediaQuery.of(context).size.width - 72, _countryCode),
          SizedBox(height: 15.0),
          _showDatePicker(),
          SizedBox(height: 15.0),
          _selectGender(context),
          SizedBox(
            height: 35.0,
          ),
          SubmitEditProfileButton(fbKey: fbKey, countryCode: _countryCode),
        ],
      ),
    );
  }

  Widget _selectGender(BuildContext context) {
    return FormBuilderDropdown(
      name: "gender",
      initialValue: getGenderStringFromIndex(mAccountModel.gender),
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
      validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required(context)]),
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(
              value: gender,
              child: Text(
                gender,
                style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6.color),
              )))
          .toList(),
    );
  }

  Widget _showDatePicker() {
    return FormBuilderDateTimePicker(
      name: "birthday",
      initialValue: mAccountModel.birthday,
      inputType: InputType.date,
      format: DateFormat("MM/dd/yyyy"),
      style: kPrimaryTextStyle,
      decoration: InputDecoration(
          labelText: 'Birthday',
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    );
  }

  Widget buildPhoneNumber(
      BuildContext context, double sizeWidth, String countryCodeString) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            width: sizeWidth * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.grey,
              ),
              shape: BoxShape.rectangle,
            ),
            child: CountryCodePicker(
              onChanged: (countryCode) =>
                  countryCodeString = countryCode.toString(),
              initialSelection: mAccountModel.countryCode,
              favorite: ['+84', 'VN'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
            )),
        Container(
          width: sizeWidth * 0.63,
          child: FormBuilderTextField(
            name: "phone",
            initialValue: mAccountModel.phoneNumber.toString(),
            maxLines: 1,
            style: kPrimaryTextStyle,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: 'Phone Number',
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32))),
            validator: FormBuilderValidators.compose([
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
