import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formz/formz.dart';
import 'package:party_booking/authentication/user_password/bloc/user_password_bloc.dart';
import 'package:party_booking/ui/change_password/change_password_page.dart';
import 'package:party_booking/widgets/common/app_button.dart';

class SubmitButton extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey;

  SubmitButton({Key key, @required GlobalKey<FormBuilderState> fbKey})
      : assert(fbKey != null),
        _fbKey = fbKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String username = "";
    return BlocBuilder<UserPasswordBloc, UserPasswordState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == FormzStatus.submissionSuccess) {
          Future<void>.delayed(Duration(milliseconds: 200), () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangePasswordPage(
                  username: username,
                )));
          });
        }
        return AppButtonWidget(
          buttonText: 'Next',
          buttonHandler: () {
            if (_fbKey.currentState.saveAndValidate()) {
              username =
                  _fbKey.currentState.fields['username'].currentState.value;
              context
                  .bloc<UserPasswordBloc>()
                  .add(ForgotPasswordSubmitted(username));
            }
          },
          stateButton: state.status,
        );
      },
    );
  }
}
