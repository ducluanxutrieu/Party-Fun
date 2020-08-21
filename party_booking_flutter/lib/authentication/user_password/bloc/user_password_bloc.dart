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
        super(const UserPasswordState.forgotPassword(
            status: FormzStatus.pure, message: ""));

  final UserRepository _userRepository;

  @override
  Stream<UserPasswordState> mapEventToState(
    UserPasswordEvent event,
  ) async* {
    if (event is ForgotPasswordSubmitted) {
      yield* _mapForgotPasswordSubmittedToState(event, state);
    }
  }

  Stream<UserPasswordState> _mapForgotPasswordSubmittedToState(
      ForgotPasswordSubmitted event, UserPasswordState state) async* {
    yield UserPasswordState.forgotPassword(
        status: FormzStatus.submissionInProgress, message: "");
    try {
      MapEntry<String, bool> result =
          await _userRepository.resetPassword(event.username);
      if (result.value) {
        yield UserPasswordState.forgotPassword(
            status: FormzStatus.submissionSuccess, message: result.key);
      } else {
        yield UserPasswordState.forgotPassword(
            status: FormzStatus.submissionFailure, message: result.key);
        await Future<void>.delayed(const Duration(seconds: 1));
        yield UserPasswordState.forgotPassword(
            status: FormzStatus.pure, message: "");
      }
    } on Exception catch (cause) {
        yield UserPasswordState.forgotPassword(
            status: FormzStatus.submissionFailure, message: cause.toString());
        await Future<void>.delayed(const Duration(seconds: 1));
        yield UserPasswordState.forgotPassword(
            status: FormzStatus.pure, message: "");
    }
  }
}
