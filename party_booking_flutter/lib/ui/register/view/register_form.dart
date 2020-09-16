import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formz/formz.dart';
import 'package:party_booking/data/network/model/register_request_model.dart';
import 'package:party_booking/ui/register/bloc/register_bloc.dart';
import 'package:party_booking/ui/register/view/register_fill_form.dart';
import 'package:party_booking/widgets/common/app_button.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];

  @override
  Widget build(BuildContext context) {
    String _countryCode = '+84';
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Register Failure')),
            );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            children: <Widget>[
              RegisterFillForm(
                fbKey: _fbKey,
                countryCodeChange: (countryCode) {
                  _countryCode = countryCode;
                },
              ),
              _RegisterButton(
                fbKey: _fbKey,
                countryCode: _countryCode,
              ),
              SizedBox(
                height: 5,
              ),
              BackLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class BackLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(
        'Login',
        style: TextStyle(color: Colors.blue, fontSize: 18),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey;
  final String _countryCode;

  _RegisterButton(
      {Key key,
      @required GlobalKey<FormBuilderState> fbKey,
      @required String countryCode})
      : assert(fbKey != null),
        assert(countryCode != null),
        _fbKey = fbKey,
        _countryCode = countryCode,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return AppButtonWidget(
            buttonText: 'Register',
            buttonHandler: () {
              RegisterRequestModel model = _getRegisterModel();
              context.bloc<RegisterBloc>().add(RegisterSubmitted(model));
            },
            stateButton: state.status,
          );
        });
  }

  RegisterRequestModel _getRegisterModel() {
    final fullName = _fbKey.currentState.fields['fullname'].currentState.value;
    final username = _fbKey.currentState.fields['username'].currentState.value;
    final email = _fbKey.currentState.fields['email'].currentState.value;
    final String phoneNumber =
        _fbKey.currentState.fields['phonenumber'].currentState.value;
    final password = _fbKey.currentState.fields['password'].currentState.value;
    String fullPhoneNumber = phoneNumber;
    if (phoneNumber.startsWith('0')) {
      fullPhoneNumber = phoneNumber.substring(1);
    }
    fullPhoneNumber = _countryCode + fullPhoneNumber;
    print(fullPhoneNumber);
    return RegisterRequestModel(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
        phoneNumber: fullPhoneNumber);
  }
}
