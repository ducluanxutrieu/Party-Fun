import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:party_booking/src/user_repository.dart';

part 'user_password_event.dart';

part 'user_password_state.dart';

class UserPasswordBloc extends Bloc<UserPasswordEvent, UserPasswordState> {
  UserPasswordBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(UserPasswordState());

  final UserRepository _userRepository;

  @override
  Stream<UserPasswordState> mapEventToState(
    UserPasswordEvent event,
  ) async* {
    switch (event.runtimeType) {
      case ForgotPasswordSubmitted:
        yield* _mapForgotPasswordSubmittedToState(event, state);
        break;
      case UserPasswordChanged:
        yield _mapPasswordChangedToState(event, state);
        break;
      case UserNewPasswordChanged:
        yield _mapNewPasswordChangedToState(event, state);
        break;
      case UserRetypePasswordChanged:
        yield _mapRetypePasswordChangedToState(event, state);
        break;
      case ChangePasswordSubmitted:
        yield* _mapChangePasswordSubmittedToState(event, state);
        break;
      default:
    }
  }

  UserPasswordState _mapPasswordChangedToState(
    UserPasswordChanged event,
    UserPasswordState state,
  ) {
    final password = event.password;
    MapEntry<FormzStatus, String> result = validatePass(
        oldPass: password,
        newPass: state.newPassword,
        retypePass: state.retypePassword,
        type: 1);
    return state.changePassword(
        status: result.key, password: password, passMessage: result.value);
  }

  UserPasswordState _mapNewPasswordChangedToState(
    UserNewPasswordChanged event,
    UserPasswordState state,
  ) {
    final newPassword = event.newPassword;
    MapEntry<FormzStatus, String> result = validatePass(
        oldPass: state.password,
        newPass: newPassword,
        retypePass: state.retypePassword,
        type: 2);
    return state.changePassword(
      status: result.key,
      newPassword: newPassword,
      newPassMessage: result.value,
    );
  }

  UserPasswordState _mapRetypePasswordChangedToState(
    UserRetypePasswordChanged event,
    UserPasswordState state,
  ) {
    final retypePassword = event.retypePassword;
    MapEntry<FormzStatus, String> result = validatePass(
        newPass: state.newPassword,
        retypePass: retypePassword,
        oldPass: state.password,
        type: 3);
    return state.changePassword(
      status: result.key,
      retypePassword: retypePassword,
      retypePassMess: result.value,
    );
  }

  Stream<UserPasswordState> _mapChangePasswordSubmittedToState(
      ChangePasswordSubmitted event, UserPasswordState state) async* {
    yield state.changePassword(status: FormzStatus.submissionInProgress);
    try {
      MapEntry<String, bool> result;
      if (event.isChangePassword)
        result = await _userRepository.changePassword(
            password: state.password, newPassword: state.newPassword);
      else
        result = await _userRepository.resetPassword(
            code: state.password,
            newPassword: state.newPassword,
            username: event.username);
      if (result.value) {
        yield state.changePassword(
            status: FormzStatus.submissionSuccess, message: result.key);
        await Future<void>.delayed(const Duration(seconds: 1));
        yield state.changePassword(status: FormzStatus.pure, message: "");
      } else {
        yield state.changePassword(
            status: FormzStatus.submissionFailure, message: result.key);
        await Future<void>.delayed(const Duration(seconds: 1));
        yield state.changePassword(status: FormzStatus.pure, message: "");
      }
    } on Exception catch (cause) {
      yield state.changePassword(
          status: FormzStatus.submissionFailure, message: cause.toString());
      await Future<void>.delayed(const Duration(seconds: 1));
      yield state.changePassword(status: FormzStatus.pure, message: "");
    }
  }

  Stream<UserPasswordState> _mapForgotPasswordSubmittedToState(
      ForgotPasswordSubmitted event, UserPasswordState state) async* {
    yield ForgotPasswordState(
        status: FormzStatus.submissionInProgress, message: "");
    try {
      MapEntry<String, bool> result =
          await _userRepository.sendCodeForgotPassword(event.username);
      if (result.value) {
        yield ForgotPasswordState(
            status: FormzStatus.submissionSuccess, message: result.key);
      } else {
        yield ForgotPasswordState(
            status: FormzStatus.submissionFailure, message: result.key);
        await Future<void>.delayed(const Duration(seconds: 1));
        yield ForgotPasswordState(status: FormzStatus.pure, message: "");
      }
    } on Exception catch (cause) {
      yield ForgotPasswordState(
          status: FormzStatus.submissionFailure, message: cause.toString());
      await Future<void>.delayed(const Duration(seconds: 1));
      yield ForgotPasswordState(status: FormzStatus.pure, message: "");
    }
  }

  MapEntry<FormzStatus, String> validatePass(
      {String oldPass = "",
      String newPass = "",
      String retypePass = "",
      int type}) {
    FormzStatus status = FormzStatus.invalid;
    String message;
    if (oldPass == null ||
        newPass == null ||
        retypePass == null) {
      message = "";
    } else{
      switch (type) {
        case 1: if(oldPass.length < 6) message = 'too short!';
        break;
        case 2: if(newPass.length < 6) message = 'New password too short!';
        break;
        case 3: if(retypePass.length < 6) message = 'Retype password too short!';
        else if(newPass != retypePass) message = 'Retype password not matched!';
        break;
        default:
      }
    }
    if(message == null){
      status = FormzStatus.valid;
      message = "";
    }
    return MapEntry(status, message);
  }
}
