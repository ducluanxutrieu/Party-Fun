import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/register_request_model.dart';
import 'package:party_booking/data/network/model/update_profile_request_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  DateTime _dateTime;

  String _selectedGender=null;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];
  int _stateButton = 0;

  void _onUpdateClicked() {
    if(_fbKey.currentState.saveAndValidate()) {
      setState(() {
        _stateButton = 1;
      });

      final fullName = _fbKey.currentState.fields['fullname'].currentState
          .value;
      final email = _fbKey.currentState.fields['email'].currentState.value;
      final phoneNumber =
          _fbKey.currentState.fields['phonenumber'].currentState.value;
      final model = UpdateProfileRequestModel(email: email, birthday: '02/02/1990', fullName: fullName, phoneNumber: phoneNumber, sex: 'Female');

      requestRegister(model);
    }
  }

  void requestRegister(UpdateProfileRequestModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AccountModel accountModel = accountModelFromJson(prefs.getString(Constants.ACCOUNT_MODEL_KEY));

    final result = await AppApiService.create().requestUpdateUser(token: accountModel.token, model: model);
    if (result.isSuccessful) {
      UTiu.showToast(result.body.message);
      setState(() {
        _stateButton = 2;
      });
      Timer(Duration(milliseconds: 1500), () {
        Navigator.pop(context);
      });
    }else {
      setState(() {
        _stateButton = 0;
      });
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UTiu.showToast(model.message);
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
    final loginButton5  = DropdownButton(
      value: _selectedGender,
      items: _dropDownItem(),
      onChanged: (value){
        _selectedGender=value;
        setState(() {
        });
      },
      hint: Text('Select Gender'),
    );
    final loginButton1 = FlatButton(
        onPressed: () {
          showDatePicker(
              context: context,
              initialDate: _dateTime == null ? DateTime.now() : _dateTime,
              firstDate: DateTime(2001),
              lastDate: DateTime(2021)
          ).then((date) {
            setState(() {
              _dateTime = date;
            });
          });
        },
      child: Text(
        //_dateTime == null ? 'Nothing has been picked yet' : _dateTime.toString()
          'Pick Time'
      ),
    );
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
                    LogoAppWidget(mLogoSize: 130,),
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
                      mHindText:  _dateTime == null ? 'Birthday':'${formatDate(_dateTime, [dd, '/', mm, '/', yyyy])}',
                      // mTextInputType: TextInputType.phone,
                      //  mValidators: [
                      //  ...listValidators,
                      //FormBuilderValidators.numeric(
                      //  errorText: "Phone number invalid")
                      //],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    loginButton1,



                    SizedBox(height: 15.0),
                    TextFieldWidget(
                      //  mAttribute: 'email',
                      //    mHindText: _selectedGender,
                      mHindText:  _selectedGender == null ? 'Gender':_selectedGender,

                    ),

                    SizedBox(
                      height: 5,
                    ),
                    loginButton5,

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
  List<DropdownMenuItem<String>> _dropDownItem(){
    List<String> ddl=["Male","Female","Others"];
    return ddl.map(
            (value)=>DropdownMenuItem(
          value: value,
          child: Text(value),
        )
    ).toList();
  }

}