import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/authentication/user_password/bloc/user_password_bloc.dart';
import 'package:party_booking/src/user_repository.dart';

import 'change_password_form.dart';

class ChangePasswordPage extends StatelessWidget {
  final String username;
  final String avatarUrl;

  ChangePasswordPage({this.username, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(username == null ? 'Change Password' : ' Reset Password'),
      ),
      body: BlocProvider(
        create: (context) => UserPasswordBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context)),
        child: ChangePasswordForm(
          avatarUrl: avatarUrl,
          username: username,
        ),
      ),
    );
  }
}