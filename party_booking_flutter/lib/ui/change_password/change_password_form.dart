import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:party_booking/authentication/user_password/bloc/user_password_bloc.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/ui/login/view/login_page.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_app.dart';

class ChangePasswordForm extends StatelessWidget {
  ChangePasswordForm({Key key, this.avatarUrl, this.username})
      : super(key: key);

  final String avatarUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserPasswordBloc, UserPasswordState>(
      listener: (context, state) {
        if(state.message != null && state.message.isNotEmpty){
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        }
        if (state.status == FormzStatus.submissionSuccess) {
          Future<void>.delayed(const Duration(milliseconds: 300))
              .then((value) => {
                    if (avatarUrl != null)
                      Navigator.pop(context)
                    else //reset password
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                          (route) => false)
                  });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 36, right: 36),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              LogoAppWidget(
                mLogoSize: 150,
                imageUrl: avatarUrl,
              ),
              SizedBox(
                height: 80.0,
              ),
              _PasswordInput(
                isChangePassword: avatarUrl != null,
              ),
              SizedBox(
                height: 25,
              ),
              _NewPasswordInput(isNewPass: true),
              SizedBox(
                height: 25,
              ),
              _NewPasswordInput(isNewPass: false),
              SizedBox(
                height: 30,
              ),
              _SubmitButton(
                isChangePass: avatarUrl != null,
                username: username,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key key,
    this.isChangePass,
    this.username,
  }) : super(key: key);

  final bool isChangePass;
  final String username;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPasswordBloc, UserPasswordState>(
      builder: (context, state) {
        return AppButtonWidget(
          buttonText: 'Change',
          buttonHandler: () {
            if (state.status == FormzStatus.valid) {
              print("**************8");
              print(username);
              context.read<UserPasswordBloc>().add(ChangePasswordSubmitted(
                  isChangePassword: isChangePass, username: username));
            }
          },
          stateButton: state.status,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key key, @required bool isChangePassword})
      : assert(isChangePassword != null),
        _isChangePassword = isChangePassword,
        super(key: key);

  final bool _isChangePassword;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPasswordBloc, UserPasswordState>(
      buildWhen: (previous, current) => (previous.status != current.status ||
          previous.passMessage != current.passMessage),
      builder: (context, state) {
        String errorText;
        if (state.passMessage != null && state.passMessage.isNotEmpty) {
          errorText = _isChangePassword
              ? "Your Password ${state.passMessage}"
              : "Code ${state.passMessage}";
        }
        return TextField(
          maxLines: 1,
          style: kPrimaryTextStyle,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
              errorText: errorText,
              labelText: _isChangePassword ? 'Your Password' : 'Code',
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
          onChanged: (password) => context
              .read<UserPasswordBloc>()
              .add(UserPasswordChanged(password)),
        );
      },
    );
  }
}

class _NewPasswordInput extends StatelessWidget {
  const _NewPasswordInput({Key key, @required bool isNewPass})
      : assert(isNewPass != null),
        _isNewPass = isNewPass,
        super(key: key);

  final bool _isNewPass;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPasswordBloc, UserPasswordState>(
      buildWhen: (previous, current) => (previous.status != current.status ||
          previous.newPassMessage != current.newPassMessage ||
          previous.retypePassMess != current.retypePassMess),
      builder: (context, state) {
        return TextField(
            maxLines: 1,
            style: kPrimaryTextStyle,
            textInputAction: TextInputAction.next,
            obscureText: true,
            decoration: InputDecoration(
                errorText:
                    _isNewPass ? state.newPassMessage : state.retypePassMess,
                labelText: _isNewPass ? 'New Password' : 'Retype Password',
                contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32))),
            onChanged: (password) {
              _isNewPass
                  ? context
                      .read<UserPasswordBloc>()
                      .add(UserNewPasswordChanged(password))
                  : context
                      .read<UserPasswordBloc>()
                      .add(UserRetypePasswordChanged(password));
            });
      },
    );
  }
}
