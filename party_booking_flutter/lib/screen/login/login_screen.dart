import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/bloc_providers.dart';
import 'package:party_booking/res/static_variable.dart';
import 'package:party_booking/screen/forgot_password_screen.dart';
import 'package:party_booking/screen/login/login_bloc.dart';
import 'package:party_booking/screen/register/register_screen.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_app.dart';
import 'package:party_booking/widgets/common/text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {

    final createNewAccountButton = FlatButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterScreen()));
      },
      child: Text(
        'Create New Account',
        style: TextStyle(color: Colors.green, fontSize: 18),
      ),
    );

    return Scaffold(
      body: FormBuilder(
        key: _fbKey,
        autovalidate: false,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: BlocProvider(
              bloc: LoginBloc(),
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
                    mAttribute: 'username',
                    mTextInputType: TextInputType.emailAddress,
                    mValidators: StaticVariable.listValidatorsRequired,
                  ),
                  SizedBox(height: 25.0),
                  TextFieldWidget(
                    mHindText: 'Password',
                    mAttribute: 'password',
                    mShowObscureText: true,
                    mValidators: StaticVariable.listValidatorsRequired,
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  LoginButton(globalKey: _fbKey,),
                  SizedBox(
                    height: 5,
                  ),
                  createNewAccountButton,
                  SizedBox(
                    height: 40,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()));
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
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
    @required GlobalKey<FormBuilderState> globalKey,
  }) : _globalKey = globalKey, super(key: key);

  final GlobalKey<FormBuilderState> _globalKey;

  @override
  Widget build(BuildContext context) {
    final LoginBloc _bloc = LoginBloc();

    return StreamBuilder(
      initialData: AppButtonState.None,
      stream: _bloc.loginButtonStatusStream,
      builder: (context, snapshot) {
       return AppButtonWidget(
          buttonText: 'Login',
          buttonHandler: () => _bloc.loginPressed(_globalKey, context),
          stateButton: snapshot.data,
        );
      },
    );
  }
}
