import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/login/bloc/login_bloc.dart';
import 'package:party_booking/src/authentication_repository.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context));
        },
        child: LoginForm(),
      ),
    );
  }
}
