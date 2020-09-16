part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  LoginSubmitted(this.username, this.password);

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}
