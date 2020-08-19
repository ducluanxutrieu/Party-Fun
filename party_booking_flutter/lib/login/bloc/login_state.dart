part of 'login_bloc.dart';

class LoginState extends Equatable {
  final FormzStatus status;
  final String username;
  final String password;

  const LoginState(
      {this.status = FormzStatus.pure, this.username = "", this.password = ""});

  LoginState copyWith({
    FormzStatus status,
    String username,
    String password,
  }) {
    return LoginState(
        status: status ?? this.status,
        username: username ?? this.username,
        password: password ?? this.password);
  }

  @override
  List<Object> get props => [status, username, password];
}
