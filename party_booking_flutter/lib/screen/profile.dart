import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/widgets/info_card.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ProfileScreen extends StatefulWidget {
  final AccountModel mAccountModel;

  ProfileScreen({@required this.mAccountModel});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AccountModel _accountModel;
  File _image;

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

  Future getImage() async {
    Dio dio = new Dio();
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    var photoFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (photoFile != null &&
        photoFile.path != null &&
        photoFile.path.isNotEmpty) {
      FormData formData = new FormData.fromMap({
        'image': await MultipartFile.fromFile(photoFile.path)
      });
      var response = await dio.post(
        "http://139.180.131.30:3000/user/uploadavatar",
        data: formData,
        options: Options(
            headers: {
              'authorization': _accountModel.token,
            },
            method: "POST"
        ),
      );
      if(response.statusCode == 200){
        print(response.headers);
      }
      // Create a FormData
//      String fileName = basename(photoFile.path);
//      print("File Name : $fileName");
//      print("File Size : ${photoFile.lengthSync()}");
//      formData.add("user_picture", new UploadFileInfo(photoFile, fileName));
    }
  }



//    var result = await AppApiService.create().requestUpdateAvatar(token: _accountModel.token, image: formData);
//    if(result.isSuccessful){
//      UTiu.showToast(result.body.message);
//      setState(() {
//        _image = photoFile;
//      });
//    }else{
//      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
//      UTiu.showToast(model.message);
//    }
//  }

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
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: getImage,
              radius: 50,
              child: _image == null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_accountModel.imageurl))
                  : ClipOval(
                      child: Image.file(
                        _image,
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
            ),
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
              text: _accountModel.imageurl,
              icon: Icons.web,
              onPressed: () async {
                if (await launcher.canLaunch(_accountModel.imageurl)) {
                  await launcher.launch(_accountModel.imageurl);
                } else {
                  _showDialog(
                    context,
                    title: 'Sorry',
                    msg: 'URL can not be opened. Please try again!',
                  );
                }
              },
            ),
            InfoCard(
              text: 'Việt Nam',
              icon: Icons.location_city,
              onPressed: null,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.green,
      //teal[200],
    );
  }
}
