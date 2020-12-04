import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/authentication/bloc/authentication_bloc.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/update_profile_request_model.dart';
import 'package:party_booking/src/authentication_repository.dart';
import '../bloc/edit_profile_bloc.dart';
import 'package:party_booking/widgets/common/app_button.dart';

class SubmitEditProfileButton extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey;
  final String _countryCode;

  SubmitEditProfileButton(
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
    return BlocListener<EditProfileBloc, EditProfileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == EditProfileStatus.profileUpdated ||
            state.status == EditProfileStatus.profileUpdateFailed) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.updateProfileResMes)),
            );

          if (state.status == EditProfileStatus.profileUpdated) {
            context.read<AuthenticationBloc>().add(AuthenticationStatusChanged(
                AuthenticationStatus.authenticatedOnlyServerUpdate));
            Navigator.of(context).pop();
          }
        }
      },
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) => AppButtonWidget(
          buttonText: 'Update',
          buttonHandler: () {
            if (_fbKey.currentState.saveAndValidate()) {
              UpdateProfileRequestModel updateProfileModel = _getInputValue();
              context
                  .read<EditProfileBloc>()
                  .add(EditProfileSubmitted(updateProfileModel));
            }
          },
          stateButton: getStateButton(state.status),
          // stateButton: _stateButton,
        ),
      ),
    );
  }

  UpdateProfileRequestModel _getInputValue() {
    final fullName = _fbKey.currentState.fields['full_name'].value;
    final email = _fbKey.currentState.fields['email'].value;
    final birthday = _fbKey.currentState.fields['birthday'].value;
    final gender = _fbKey.currentState.fields['gender'].value;
    final phoneNumber = _fbKey.currentState.fields['phone'].value;

    int genderId = UserGender.values
        .indexWhere((e) => e.toString() == "UserGender.$gender");
    final model = UpdateProfileRequestModel(
        email: email,
        birthday: DateFormat('yyyy-MM-dd').format(birthday) + 'T17:00:00.000Z',
        fullName: fullName,
        phoneNumber: phoneNumber,
        countryCode: _countryCode,
        gender: genderId);
    return model;
  }

  FormzStatus getStateButton(EditProfileStatus status) {
    switch (status) {
      case EditProfileStatus.unknown:
        return FormzStatus.pure;
      case EditProfileStatus.profileUpdating:
        return FormzStatus.submissionInProgress;
      case EditProfileStatus.profileUpdated:
        return FormzStatus.submissionSuccess;
      case EditProfileStatus.profileUpdateFailed:
        return FormzStatus.submissionFailure;
      default:
        return FormzStatus.pure;
    }
  }
}
