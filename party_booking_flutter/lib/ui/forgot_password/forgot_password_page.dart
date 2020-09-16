import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/authentication/user_password/bloc/user_password_bloc.dart';
import 'package:party_booking/src/user_repository.dart';

import 'forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocProvider(
        create: (context) =>
           UserPasswordBloc(userRepository: RepositoryProvider.of<UserRepository>(context)),
        child: ForgotPasswordForm(),
      ),
    );
  }
}