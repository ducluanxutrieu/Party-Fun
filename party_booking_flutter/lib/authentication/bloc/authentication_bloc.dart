import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/src/authentication_repository.dart';
import 'package:party_booking/src/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
    @required UserRepository userRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  @override
  void onTransition(Transition<AuthenticationEvent, AuthenticationState> transition) {
    print(transition);
    print(transition.nextState.status);
    print('authentication bloc');
    super.onTransition(transition);
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationRepository.logOut();
    }
  }

  @override
  Future<void> close() {
    print('On Close Authentication Bloc');
    _authenticationStatusSubscription?.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
    AuthenticationStatusChanged event,
  ) async {
    print('++++++++++++++');
    print(event.status);
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const AuthenticationState.unauthenticated();
      case AuthenticationStatus.authenticated:
        final user = await _tryGetLocalUser();
        return user != null
            ? AuthenticationState.authenticated(user)
            : const AuthenticationState.unauthenticated();
      case AuthenticationStatus.authenticatedOnlyServerUpdate:
        final user = await _tryGetUserInfo();
        return user != null
            ? AuthenticationState.authenticatedAndUpdated(user)
            : const AuthenticationState.unauthenticated();
      default:
        return const AuthenticationState.unknown();
    }
  }

  Future<AccountModel> _tryGetLocalUser() async {
    try {
      final user = await _userRepository.getUserFromPrefs();
      return user;
    } on Exception {
      return null;
    }
  }

  Future<AccountModel> _tryGetUserInfo() async {
    try {
      final user = await _userRepository.getUserFromServer();
      return user;
    } on Exception {
      return null;
    }
  }
}
