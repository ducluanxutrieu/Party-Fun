import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/screen/change_password_screen.dart';
import 'package:party_booking/widgets/info_card.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({
    Key key,
    @required AccountModel accountModel,
  }) : _accountModel = accountModel, super(key: key);

  final AccountModel _accountModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_accountModel.avatar)),
          Text(
            _accountModel.username,
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Source Sans Pro',
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
              text: _accountModel.countryCode +
                  _accountModel.phoneNumber.toString(),
              icon: Icons.phone,
              onPressed: null),
          InfoCard(
              text: _accountModel.email, icon: Icons.mail, onPressed: null),
          InfoCard(
            text: DateFormat('dd-MM-yyyy').format(_accountModel.birthday),
            icon: Icons.date_range,
            onPressed: null,
          ),
          InfoCard(
            text: UserGender.values[_accountModel.gender]
                .toString()
                .replaceAll("UserGender.", ""),
            icon: FontAwesomeIcons.venusMars,
            onPressed: null,
          ),
          InfoCard(
            text: '****',
            icon: Icons.lock,
            isShowEdit: true,
            onPressed: () {
              _goToChangePassScreen(context, _accountModel.avatar);
            },
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _goToChangePassScreen(BuildContext context, String avatarUrl) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePasswordScreen(
                  avatarUrl: avatarUrl,
                )));
  }
}