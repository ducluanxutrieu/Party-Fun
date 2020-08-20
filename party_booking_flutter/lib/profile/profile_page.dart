import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/authentication/bloc/authentication_bloc.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/edit_profile/%60view/edit_profile_screen.dart';

import 'profile_form.dart';

class ProfilePage extends StatelessWidget {
  void _goToEditProfileScreen(BuildContext context, AccountModel accountModel) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditProfileScreen(
              accountModel: accountModel,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previous, current) =>
            (previous.user.avatar != current.user.avatar ||
                previous.user.fullName != current.user.fullName ||
                previous.user.email != current.user.email ||
                previous.user.username != current.user.username ||
                previous.user.birthday != current.user.birthday ||
                previous.user.gender != current.user.gender ||
                previous.user.countryCode != current.user.countryCode),
        builder: (context, state) {
          AccountModel _accountModel = state.user;
          context.bloc<AuthenticationBloc>().add(AuthenticationUpdateUser());
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _goToEditProfileScreen(context, _accountModel);
              },
              child: Icon(Icons.edit),
            ),
            backgroundColor: Colors.green,
            body: ProfileForm(accountModel: _accountModel),
          );
        });
  }
}
