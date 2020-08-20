import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:party_booking/src/authentication_repository.dart';

import 'edit_profile_form.dart';

class EditProfileScreen extends StatelessWidget {
  final AccountModel accountModel;
  
  EditProfileScreen({Key key, this.accountModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: BlocProvider(
        create: (context) => EditProfileBloc(
          authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context)
        ),
        child: EditProfileForm(accountModel: accountModel),
      ),
    );
  }
}