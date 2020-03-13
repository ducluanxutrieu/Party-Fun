import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/service/app_image_api_service.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:party_booking/widgets/info_card.dart';
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

  @override
  void initState() {
    super.initState();
    _accountModel = widget.mAccountModel;
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

  _getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null && image.path != null && image.path.isNotEmpty) {
      var result = await AppImageAPIService.create().updateAvatar(image);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.edit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                  onTap: _getImage,
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
                text: _accountModel.phoneNumber,
                icon: Icons.phone,
                onPressed: () async {
                  String removeSpaceFromPhoneNumber = _accountModel.phoneNumber
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()));
                  //   Navigator.pop(profile);
                },
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
