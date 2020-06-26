import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/update_profile_request_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/common/text_field.dart';

class EditProfileScreen extends StatefulWidget {
  final AccountModel mAccountModel;

  EditProfileScreen({@required this.mAccountModel});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];
  int _stateButton = 0;

  void _onUpdateClicked() {
    if (_fbKey.currentState.saveAndValidate()) {
      setState(() {
        _stateButton = 1;
      });

      final fullName = _fbKey.currentState.fields['fullname'].currentState.value;
      final email = _fbKey.currentState.fields['email'].currentState.value;
      final birthday = _fbKey.currentState.fields['birthday'].currentState.value;
      final gender = _fbKey.currentState.fields['gender'].currentState.value;
      final phoneNumber = _fbKey.currentState.fields['phonenumber'].currentState.value;

      int genderId = UserGender.values.indexWhere((e) => e.toString() == "UserGender.$gender");
      final model = UpdateProfileRequestModel(
          email: email,
          birthday: DateFormat('MM/dd/yyyy').format(birthday),
          fullName: fullName,
          phoneNumber: phoneNumber,
          gender:  genderId);
      _requestUpdateUserProfile(model);
    }
  }

  void _requestUpdateUserProfile(UpdateProfileRequestModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString(Constants.USER_TOKEN);

    final result = await AppApiService.create()
        .requestUpdateUser(token: userToken, model: model);
    if (result.isSuccessful) {
      UTiu.showToast(message: result.body.message);
      setState(() {
        _stateButton = 2;
      });
      prefs.setString(Constants.ACCOUNT_MODEL_KEY, accountModelToJson(result.body.account));
      Timer(Duration(milliseconds: 1500), () {
        Navigator.pop(context, result.body.account);
      });
    } else {
      setState(() {
        _stateButton = 0;
      });
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UTiu.showToast(message: model.message, isFalse: true);
    }
  }

  Widget _selectGender() {
    return FormBuilderDropdown(
      attribute: "gender",
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black),
      decoration: InputDecoration(
          labelText: "Gender",
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      // initialValue: 'Male',
      hint: Text('Select Gender', style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),),
      validators: [FormBuilderValidators.required()],
      items: ['Male', 'Female', 'Other']
          .map((gender) =>
              DropdownMenuItem(value: gender, child: Text(gender)))
          .toList(),
    );
  }

  Widget _showDatePicker() {
    return FormBuilderDateTimePicker(
      attribute: "birthday",
      inputType: InputType.date,
      format: DateFormat("MM/dd/yyyy"),
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
      decoration: InputDecoration(
          labelText: 'Select Gender',
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: FormBuilder(
          key: _fbKey,
          autovalidate: false,
          initialValue: {
            'fullname': widget.mAccountModel.fullName,
            'email': widget.mAccountModel.email,
            'phonenumber': (widget.mAccountModel.phoneNumber.toString() ?? 'Empty'),
            'birthday': DateFormat("MM/dd/yyyy").parse(widget.mAccountModel.birthday),
            'gender': getGenderStringFromIndex(widget.mAccountModel.gender),
          },
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
                    LogoAppWidget(
                      mLogoSize: 130,
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
                      mAttribute: 'email',
                      mHindText: 'Email',
                      mValidators: [
                        ...listValidators,
                        FormBuilderValidators.email()
                      ],
                      mTextInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 15.0),
                    buildPhoneNumber(MediaQuery.of(context).size.width - 72, listValidators),
                    SizedBox(height: 15.0),
                    _showDatePicker(),
                    SizedBox(height: 15.0),
                    _selectGender(),
                    SizedBox(
                      height: 35.0,
                    ),
                    AppButtonWidget(
                      buttonText: 'Update',
                      buttonHandler: _onUpdateClicked,
                      stateButton: _stateButton,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
    print("New Country selected: " + countryCode.toString());
  }
}
