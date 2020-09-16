import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/ui/register/bloc/register_bloc.dart';
import 'package:party_booking/ui/register/view/register_form.dart';
import 'package:party_booking/src/authentication_repository.dart';

class RegisterPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return RegisterBloc(
              authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context));
        },
        child: RegisterForm(),
      ),
    );
  }
}
