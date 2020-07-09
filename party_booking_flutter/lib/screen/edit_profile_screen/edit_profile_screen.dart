import 'dart:async';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/update_profile_request_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/data/network/service/app_image_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/edit_profile_screen/edit_profile_form.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final AccountModel mAccountModel;

  EditProfileScreen({@required this.mAccountModel});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  int _stateButton = 0;
  String _countryCode;
  String avatarUrl;

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
          birthday: DateFormat('yyyy-MM-dd').format(birthday) + 'T17:00:00.000Z',
          fullName: fullName,
          phoneNumber: phoneNumber,
          countryCode: _countryCode,
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
      UiUtiu.showToast(message: result.body.message);
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
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
  }

  void _onCountryChange(CountryCode countryCode) {
    print("New Country selected: " + countryCode.toString());
    _countryCode = countryCode.toString();
  }

  @override
  void initState() {
    _countryCode = widget.mAccountModel.countryCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40,),
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(avatarUrl ??= widget.mAccountModel.avatar),
              child: IconButton(icon: Icon(Icons.camera_alt), onPressed: () => _showBottomSheet(context),iconSize: 60,),
            ),
            EditProfileForm(fbKey: _fbKey, mAccountModel: widget.mAccountModel, onCountryCodeChange: (countryCode) => _onCountryChange(countryCode),),
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
    );
  }


  void _showBottomSheet(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getImage(ImageSource.camera);
                      Navigator.pop(context);
                    }),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Gallery'),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  _getImage(source) async {
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: source);
    File image = File(pickedFile.path);

    if (image != null && image.path != null && image.path.isNotEmpty) {
      var result = await AppImageAPIService.create(context).updateAvatar(image);
      if (result != null) {
        setState(() {
          UiUtiu.showToast(message: 'Change avatar successful');
          avatarUrl = result.data;
        });
      } else {
        UiUtiu.showToast(message: result.message, isFalse: true);
      }
      print(result.toString());
    }
  }
}
