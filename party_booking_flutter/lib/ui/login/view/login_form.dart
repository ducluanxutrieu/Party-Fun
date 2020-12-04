import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formz/formz.dart';
import 'package:party_booking/authentication/bloc/authentication_bloc.dart';
import 'package:party_booking/src/authentication_repository.dart';
import '../bloc/login_bloc.dart';
import 'package:party_booking/ui/register/view/register_page.dart';
import 'package:party_booking/ui/forgot_password/forgot_password_page.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        } else if(state.status == FormzStatus.submissionSuccess)
          BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationStatusChanged(AuthenticationStatus.authenticated));
      },
      child: FormBuilder(
        key: _fbKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                LogoAppWidget(
                  mLogoSize: 150,
                ),
                SizedBox(height: 75.0),
                TextFieldWidget(
                  mHindText: 'Username',
                  name: 'username',
                  mTextInputType: TextInputType.emailAddress,
                  mValidators: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                ),
                SizedBox(height: 25.0),
                TextFieldWidget(
                  mHindText: 'Password',
                  name: 'password',
                  mShowObscureText: true,
                  mValidators: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                ),
                SizedBox(
                  height: 35.0,
                ),
                _LoginButton(fbKey: _fbKey),
                SizedBox(
                  height: 5,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  child: Text(
                    'Create New Account',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()));
                  },
                  child: Text(
                    "Forgot your password",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey;

  _LoginButton({Key key, @required GlobalKey<FormBuilderState> fbKey})
      : assert(fbKey != null),
        _fbKey = fbKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return AppButtonWidget(
            buttonText: 'Login',
            buttonHandler: () {
              if(_fbKey.currentState.saveAndValidate()) {
                String username = _fbKey
                    .currentState.fields['username'].value;
                String password = _fbKey
                    .currentState.fields['password'].value;
                context
                    .read<LoginBloc>()
                    .add(LoginSubmitted(username, password));
              }
            },
            stateButton: state.status,
          );
        });
  }
}
