import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/data/network/service/app_image_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:party_booking/widgets/info_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AccountModel mAccountModel;

  ProfileScreen({@required this.mAccountModel});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AccountModel _accountModel;
  String avatarUrl;

  void _updateUserProfile()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.USER_TOKEN);
    var result = await AppApiService.create().getUserProfile(token: token);
    if(result.isSuccessful){
      setState(() {
        _accountModel = result.body.account;
      });
      prefs.setString(Constants.ACCOUNT_MODEL_KEY, jsonEncode(_accountModel.toJson()));
    }else{
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UTiu.showToast(model.message);
    }
  }

  @override
  void initState() {
    super.initState();
    _accountModel = widget.mAccountModel;
    _updateUserProfile();
  }

  void _showDialog(BuildContext context, {String title, String msg}) {
    final dialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[
        RaisedButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (x) => dialog);
  }

  void _showBottomSheet(context) async{
    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return Container(
        child: new Wrap(
          children: <Widget>[
            new ListTile(
                leading: new Icon(Icons.camera),
                title: new Text('Camera'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.pop(context);
                }
            ),
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
    File image = await ImagePicker.pickImage(source: source);

    if (image != null && image.path != null && image.path.isNotEmpty) {
      var result = await AppImageAPIService.create(context).updateAvatar(image);
      if (result.success) {
        setState(() {
          UTiu.showToast('Change avatar successful');
          avatarUrl = result.message;
        });
      } else {
        UTiu.showToast(result.message);
      }
      print(result.toString());
    }

  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
//          _handleVideo(response.file);
        } else {
//          _handleImage(response.file);
        }
      });
    } else {
//      _handleError(response.exception);
    }
  }

  void _goToEditProfileScreen() async {
    AccountModel result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(mAccountModel: _accountModel,)));
    if (result != null) {
      setState(() {
        _accountModel = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'),),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           _goToEditProfileScreen();
        },
        child: Icon(Icons.edit),
      ),
      backgroundColor: Colors.green,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () => _showBottomSheet(context),
                  radius: 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: (avatarUrl == null)
                        ? NetworkImage(_accountModel.imageUrl)
                        : NetworkImage(avatarUrl),
                  )),
              Text(
                _accountModel.username,
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                ),
              ),
              Text(
                _accountModel.role,
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  fontSize: 30.0,
                  color: Colors.teal[50],
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.teal.shade700,
                ),
              ),
              InfoCard(
                text: _accountModel.fullName,
                icon: Icons.account_box,
              ),
              InfoCard(
                text: _accountModel.phoneNumber.toString(),
                icon: Icons.phone,
                onPressed: () async {
                  String removeSpaceFromPhoneNumber = _accountModel.phoneNumber.toString()
                      .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                  final phoneCall = 'tel:$removeSpaceFromPhoneNumber';

                  if (await launcher.canLaunch(phoneCall)) {
                    await launcher.launch(phoneCall);
                  } else {
                    _showDialog(
                      context,
                      title: 'Sorry',
                      msg: 'Phone number can not be called. Please try again!',
                    );
                  }
                },
              ),
              InfoCard(
                text: _accountModel.email,
                icon: Icons.mail,
                onPressed: () async {
                  final emailAddress = 'mailto:${_accountModel.email}';

                  if (await launcher.canLaunch(emailAddress)) {
                    await launcher.launch(emailAddress);
                  } else {
                    _showDialog(
                      context,
                      title: 'Sorry',
                      msg: 'Email can not be send. Please try again!',
                    );
                  }
                },
              ),
              InfoCard(
                text: _accountModel.birthday,
                icon: Icons.date_range,
                onPressed: null,
              ),
              InfoCard(
                text: _accountModel.sex,
                icon: FontAwesomeIcons.venusMars,
                onPressed: null,
              ),
              InfoCard(
                text: '******',
                icon: Icons.lock,
                onPressed: null,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
