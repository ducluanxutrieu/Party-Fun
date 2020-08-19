import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:formz/formz.dart';
import 'package:party_booking/src/authentication_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({@required AuthenticationRepository authenticationRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const LoginState());

  final AuthenticationRepository _authenticationRepository;
  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginSubmitted) yield* _mapLoginSubmittedToState(event, state);
  }

  Stream<LoginState> _mapLoginSubmittedToState(
    LoginSubmitted event,
    LoginState state,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress, username: event.username, password: event.password);
    try {
      String result = await _authenticationRepository.logIn(
        username: event.username,
        password: event.password,
      );
      if (result == "Login Successful!")
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
