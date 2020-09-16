import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:party_booking/data/network/model/register_request_model.dart';
import 'package:party_booking/src/authentication_repository.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({@required AuthenticationRepository authenticationRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const RegisterState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterSubmitted)
      yield* _mapRegisterSubmittedToState(event, state);
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
    RegisterSubmitted event,
    RegisterState state,
  ) async* {
    yield state.copyWith(
        status: FormzStatus.submissionInProgress,
        registerModel: event.registerModel);
    try {
      String result =
          await _authenticationRepository.register(model: event.registerModel);
      if (result == "Register Successful!")
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      else {
        yield state.copyWith(status: FormzStatus.submissionFailure);
        await Future<void>.delayed(const Duration(seconds: 1));
        yield state.copyWith(status: FormzStatus.pure);
      }
    } on Exception catch (_) {
      yield state.copyWith(status: FormzStatus.submissionFailure);
      await Future<void>.delayed(const Duration(seconds: 1));
      yield state.copyWith(status: FormzStatus.pure);
    }
  }
}
